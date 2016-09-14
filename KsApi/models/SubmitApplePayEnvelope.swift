import Argo
import Curry

public struct SubmitApplePayEnvelope {
  public let thankYouUrl: String
  public let status: Int
}

extension SubmitApplePayEnvelope: Decodable {
  public static func decode(json: JSON) -> Decoded<SubmitApplePayEnvelope> {
    return curry(SubmitApplePayEnvelope.init)
      <^> json <| ["data", "thankyou_url"]
      <*> json <| "status"
  }
}
