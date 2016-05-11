import Alamofire
import Argo
import Foundation
import ReactiveCocoa

internal extension Alamofire.Request {
  static let queue = dispatch_queue_create("com.kickstarter.ksapi", nil)
  /*
  Turns an Alamofire request into a signal of a model by:

  - Download data and parsing JSON.
  - Decoding JSON into a model.
  - Fail if the decoding returns `nil`.
  */
  internal func decodeModel<M: Decodable where M == M.DecodedType>(_: M.Type) ->
    SignalProducer<M, ErrorEnvelope> {

    return self.rac_JSONResponse()
      .map { json in decode(json) as Decoded<M> }
      .flatMap(.Concat) { (decoded: Decoded<M>) -> SignalProducer<M, ErrorEnvelope> in
        if let value = decoded.value {
          return SignalProducer(value: value)
        } else if let error = decoded.error {
          print("Argo decoding model error: \(error)")
          return SignalProducer(error: .couldNotDecodeJSON(error))
        }
        return .empty
      }
  }

  // Convert an Alamofire request into a signal producer of `NSData`.
  private func rac_dataResponse() -> SignalProducer<NSData, ErrorEnvelope> {

    return SignalProducer { observer, dispossable in
      return self.responseData { response in

        switch response.result {
        case let .Success(value):
          print("[KsApi] Success \(self.sanitizedRequest())")
          observer.sendNext(value)
          observer.sendCompleted()
        case .Failure:
          print("[KsApi] Failure \(self.sanitizedRequest())")

          if let json = response.data.flatMap(parseJSONData) {
            switch decode(json) as Decoded<ErrorEnvelope> {
            case let .Success(envelope):
              // Got the error envelope
              observer.sendFailed(envelope)
            case let .Failure(error):
              print("Argo decoding error envelope error: \(error)")
              observer.sendFailed(.couldNotDecodeJSON(error))
            }
          } else {
            print("Couldn't parse error envelope JSON.")
            observer.sendFailed(.couldNotParseErrorEnvelopeJSON)
          }
        }
      }
    }
  }

  // Converts an Alamofire request into a signal producer of raw JSON data. If the JSON does not parse
  // successfully, an `ErrorEnvelope.errorJSONCouldNotParse()` error is emitted.
  private func rac_JSONResponse() -> SignalProducer<AnyObject, ErrorEnvelope> {
    return rac_dataResponse()
      .observeOn(QueueScheduler(queue: Alamofire.Request.queue))
      .map(parseJSONData)
      .flatMap(.Concat) { json -> SignalProducer<AnyObject, ErrorEnvelope> in
        if let json = json {
          return SignalProducer(value: json)
        }
        return SignalProducer(error: ErrorEnvelope.couldNotParseJSON)
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
  private func sanitizedRequest() -> String? {
    guard let urlString = self.request?.URL?.absoluteString else { return nil }

    return Alamofire.Request.sanitationRules.reduce(urlString) { accum, templateAndRule in
      let (template, rule) = templateAndRule
      let range = NSRange(location: 0, length: accum.characters.count)
      return rule.stringByReplacingMatchesInString(accum,
                                                   options: .WithTransparentBounds,
                                                   range: range,
                                                   withTemplate: template)
    }
  }
}
