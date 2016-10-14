import Argo
import Curry

public struct ChangePaymentMethodEnvelope {
  public let newCheckoutUrl: String?
  public let status: Int
}

extension ChangePaymentMethodEnvelope: Decodable {
  public static func decode(json: JSON) -> Decoded<ChangePaymentMethodEnvelope> {
    return curry(ChangePaymentMethodEnvelope.init)
      <^> json <|? ["data", "new_checkout_url"]
      <*> json <| "status"
  }
}
