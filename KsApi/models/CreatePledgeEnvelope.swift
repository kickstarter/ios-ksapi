import Argo
import Curry

public struct CreatePledgeEnvelope {
  public let checkoutUrl: String
  public let status: Int
}

extension CreatePledgeEnvelope: Decodable {
  public static func decode(json: JSON) -> Decoded<CreatePledgeEnvelope> {
    return curry(CreatePledgeEnvelope.init)
      <^> json <| ["data", "checkout_url"]
      <*> json <| "status"
  }
}
