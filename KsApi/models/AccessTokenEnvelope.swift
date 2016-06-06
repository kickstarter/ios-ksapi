import Argo
import Curry

public struct AccessTokenEnvelope {
  public let accessToken: String
  public let user: User
}

extension AccessTokenEnvelope: Decodable {
  public static func decode(json: JSON) -> Decoded<AccessTokenEnvelope> {
    return curry(AccessTokenEnvelope.init)
      <^> json <| "access_token"
      <*> json <| "user"
  }
}
