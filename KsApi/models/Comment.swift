import Argo
import Curry

public struct Comment {
  public let author: User
  public let body: String
  public let createdAt: NSTimeInterval
  public let deletedAt: NSTimeInterval?
  public let id: Int
}

extension Comment: Decodable {
  public static func decode(json: JSON) -> Decoded<Comment> {
    return curry(Comment.init)
      <^> json <| "author"
      <*> json <| "body"
      <*> json <| "created_at"
      <*> (json <|? "deleted_at" >>- decodePositiveTimeInterval)
      <*> json <| "id"
  }
}

extension Comment: Equatable {
}
public func == (lhs: Comment, rhs: Comment) -> Bool {
  return lhs.id == rhs.id
}

// Decode a time interval so that non-positive values are coalesced to `nil`. We do this because the API
// sends back `0` when the comment hasn't been deleted, and we'd rather handle that value as `nil`.
private func decodePositiveTimeInterval(interval: NSTimeInterval?) -> Decoded<NSTimeInterval?> {
  if let interval = interval where interval > 0.0 {
    return .Success(interval)
  }
  return .Success(nil)
}
