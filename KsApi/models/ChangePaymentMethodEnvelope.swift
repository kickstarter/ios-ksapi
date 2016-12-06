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
      <*> ((json <| "status" >>- stringToIntOrZero) <|> (json <| "status"))
  }
}

private func stringToIntOrZero(string: String) -> Decoded<Int> {
  return
    Double(string).flatMap(Int.init).map(Decoded.Success)
      ?? Int(string).map(Decoded.Success)
      ?? .Success(0)
}
