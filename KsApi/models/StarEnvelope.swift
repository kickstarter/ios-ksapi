import Argo
import Curry

public struct StarEnvelope {
  public let user: User
  public let project: Project
}

extension StarEnvelope: Decodable {
  public static func decode(_ json: JSON) -> Decoded<StarEnvelope> {
    return curry(StarEnvelope.init)
      <^> json <| "user"
      <*> json <| "project"
  }
}
