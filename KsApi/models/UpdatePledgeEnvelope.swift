import Argo
import Curry

public struct UpdatePledgeEnvelope {
  public let newCheckoutUrl: String?
  public let status: Int
}

extension UpdatePledgeEnvelope: Decodable {
  public static func decode(json: JSON) -> Decoded<UpdatePledgeEnvelope> {
    return curry(UpdatePledgeEnvelope.init)
      <^> json <|? ["data", "new_checkout_url"]
      <*> json <| "status"
  }
}
