import struct Models.Project
import struct Models.User
import protocol Argo.Decodable
import enum Argo.Decoded
import enum Argo.JSON
import func Argo.<|
import func Argo.<^>
import func Argo.<*>
import func Curry.curry

public struct StarEnvelope {
  public let user: User
  public let project: Project
}

extension StarEnvelope : Decodable {
  public static func decode(json: JSON) -> Decoded<StarEnvelope> {
    return curry(StarEnvelope.init)
      <^> json <| "user"
      <*> json <| "project"
  }
}
