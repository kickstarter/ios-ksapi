import Argo
import ReactiveSwift

public func fetch<A: Decodable>(query: Set<Query>) -> SignalProducer<A, ApiError>
  where A == A.DecodedType {

    return SignalProducer<A, ApiError> { observer, _ in

      let url = URL(string: "http://ksr.dev/graph")!
      var request = URLRequest(url: url)
      request.httpBody = "query=\(Query.build(query))".data(using: .utf8)
      request.httpMethod = "POST"

      let task = URLSession.shared.dataTask(with: request) { data, _, error in
        defer { observer.sendCompleted() }
        if let error = error {
          // todo: http status code?
          observer.send(error: .requestError(error))
          return
        }
        guard let data = data else {
          // todo: what to do? data AND error are nil?!
          return
        }

        guard let jsonObject = try? JSONSerialization.jsonObject(with: data, options: []) else {
          observer.send(error: .invalidJson(responseString: String(data: data, encoding: .utf8)))
          return
        }
        let json = JSON(jsonObject)
        let decoded = A.decode(json)

        switch decoded {
        case let .success(value):
          observer.send(value: value)
        case let .failure(error):
          let jsonString = String(data: data, encoding: .utf8)
          if let gqlError = GQLError.decode(JSON(jsonObject)).value {
            observer.send(error: .gqlError(gqlError))
          } else {
            observer.send(error: .argoError(jsonString: jsonString, error))
          }
        }
      }

      task.resume()
    }
}
