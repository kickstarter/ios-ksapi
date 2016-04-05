import Argo
import Models
import Curry

public struct CommentsEnvelope {
  public let comments: [Comment]
}

extension CommentsEnvelope: Decodable {
  public static func decode(json: JSON) -> Decoded<CommentsEnvelope> {
    return curry(CommentsEnvelope.init)
      <^> json <|| "comments"
  }
}
