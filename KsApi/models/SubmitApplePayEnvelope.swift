import Argo
import Curry

public struct SubmitApplePayEnvelope {
  public let thankYouUrl: String
  public let status: Int
}

extension SubmitApplePayEnvelope: Decodable {
  public static func decode(_ json: JSON) -> Decoded<SubmitApplePayEnvelope> {
    return curry(SubmitApplePayEnvelope.init)
      <^> json <| ["data", "thankyou_url"]
      <*> ((json <| "status" >>- stringToIntOrZero) <|> (json <| "status"))
  }
}

private func stringToIntOrZero(_ string: String) -> Decoded<Int> {
  return
    Double(string).flatMap(Int.init).map(Decoded.Success)
      ?? Int(string).map(Decoded.Success)
      ?? .Success(0)
}
