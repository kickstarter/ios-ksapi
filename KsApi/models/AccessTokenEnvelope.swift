import Argo
import struct Models.User
import func Curry.curry

public struct AccessTokenEnvelope {
  public let accessToken: String
  public let user: User

  init(access_token: String, user: User) {
    self.accessToken = access_token
    self.user = user
  }
}

extension AccessTokenEnvelope : Decodable {
  public static func decode(json: JSON) -> Decoded<AccessTokenEnvelope> {
    return curry(AccessTokenEnvelope.init)
      <^> json <| "access_token"
      <*> json <| "user"
  }
}
