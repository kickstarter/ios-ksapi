import Argo
import Curry

public struct CheckoutEnvelope {
  public enum State: String {
    case authorizing
    case failed
    case successful
    case verifying
  }
  public let state: State
  public let stateReason: String
}

extension CheckoutEnvelope: Decodable {
  public static func decode(_ json: JSON) -> Decoded<CheckoutEnvelope> {
    let create = curry(CheckoutEnvelope.init)
    return create
      <^> json <| "state"
      <*> json <| "state_reason" <|> .Success("")
  }
}

extension CheckoutEnvelope.State: Decodable {
}
