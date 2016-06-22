import Argo
import Curry
import Foundation
import ReactiveCocoa
import Result

private func parseJSONData(data: NSData) -> AnyObject? {
  return try? NSJSONSerialization.JSONObjectWithData(data, options: [])
}

private let queue = dispatch_queue_create("com.kickstarter.ksapi", nil)

internal extension NSURLSession {

  // Wrap an NSURLSession producer with error envelope logic.
  internal func rac_dataResponse(request: NSURLRequest, uploading fileUrl: NSURL? = nil)
    -> SignalProducer<NSData, ErrorEnvelope> {

      let producer = fileUrl.map { self.rac_dataWithRequest(request, uploading: $0) }
        ?? self.rac_dataWithRequest(request)

      return producer
        .startOn(QueueScheduler(queue: queue))
        .flatMapError { _ in SignalProducer(error: .couldNotParseErrorEnvelopeJSON) } // NSError
        .flatMap(.Concat) { data, response -> SignalProducer<NSData, ErrorEnvelope> in
          guard let response = response as? NSHTTPURLResponse else { fatalError() }

          guard
            (200..<300).contains(response.statusCode),
            let headers = response.allHeaderFields as? [String:String],
            contentType = headers["Content-Type"] where contentType.hasPrefix("application/json")
            else {

              print("[KsApi] Failure \(self.sanitized(request))")

              if let json = parseJSONData(data) {
                switch decode(json) as Decoded<ErrorEnvelope> {
                case let .Success(envelope):
                  // Got the error envelope
                  return SignalProducer(error: envelope)
                case let .Failure(error):
                  print("Argo decoding error envelope error: \(error)")
                  return SignalProducer(error: .couldNotDecodeJSON(error))
                }
              } else {
                print("Couldn't parse error envelope JSON.")
                return SignalProducer(error: .couldNotParseErrorEnvelopeJSON)
              }
            }

          print("[KsApi] Success \(self.sanitized(request))")
          return SignalProducer(value: data)
        }
  }

  // Converts an NSURLSessionTask into a signal producer of raw JSON data. If the JSON does not parse
  // successfully, an `ErrorEnvelope.errorJSONCouldNotParse()` error is emitted.
  internal func rac_JSONResponse(request: NSURLRequest, uploading fileUrl: NSURL? = nil)
    -> SignalProducer<AnyObject, ErrorEnvelope> {

      return self.rac_dataResponse(request, uploading: fileUrl)
        .map(parseJSONData)
        .flatMap { json -> SignalProducer<AnyObject, ErrorEnvelope> in
          guard let json = json else {
            return .init(error: .couldNotParseJSON)
          }
          return .init(value: json)
        }
  }

  // swiftlint:disable force_try
  private static let sanitationRules = [
    "oauth_token=[REDACTED]":
      try! NSRegularExpression(pattern: "oauth_token=([a-zA-Z0-9]*)", options: .CaseInsensitive),
    "client_id=[REDACTED]":
      try! NSRegularExpression(pattern: "client_id=([a-zA-Z0-9]*)", options: .CaseInsensitive),
    "access_token=[REDACTED]":
      try! NSRegularExpression(pattern: "access_token=([a-zA-Z0-9]*)", options: .CaseInsensitive),
    "password=[REDACTED]":
      try! NSRegularExpression(pattern: "password=([a-zA-Z0-9]*)", options: .CaseInsensitive)
    ]
  // swiftlint:enable force_try

  // Strips sensitive materials from the request, e.g. oauth token, client id, fb token, password, etc...
  private func sanitized(request: NSURLRequest) -> String {
    guard let urlString = request.URL?.absoluteString else { return "" }

    return NSURLSession.sanitationRules.reduce(urlString) { accum, templateAndRule in
      let (template, rule) = templateAndRule
      let range = NSRange(location: 0, length: accum.characters.count)
      return rule.stringByReplacingMatchesInString(accum,
                                                   options: .WithTransparentBounds,
                                                   range: range,
                                                   withTemplate: template)
    } ?? ""
  }
}

private let defaultSessionError =
  NSError(domain: "com.kickstarter.KsApi.rac_dataWithRequest", code: 1, userInfo: nil)

extension NSURLSession {
  // Returns a producer that will execute the given upload once for each invocation of start().
  private func rac_dataWithRequest(request: NSURLRequest, uploading file: NSURL)
    -> SignalProducer<(NSData, NSURLResponse), NSError> {

      return SignalProducer { observer, disposable in
        let task = self.uploadTaskWithRequest(request, fromFile: file) { data, response, error in
          guard let data = data, response = response else {
            observer.sendFailed(error ?? defaultSessionError)
            return
          }
          observer.sendNext((data, response))
          observer.sendCompleted()
        }
        disposable += task.cancel
        task.resume()
      }
  }
}
