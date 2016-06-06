import Argo
import Curry
import Foundation

public struct Message {
  public let body: String
  public let createdAt: NSTimeInterval
  public let id: Int
  public let recipient: User
  public let sender: User
}

extension Message: Decodable {
  public static func decode(json: JSON) -> Decoded<Message> {
    let create = curry(Message.init)
    return create
      <^> json <| "body"
      <*> json <| "created_at"
      <*> json <| "id"
      <*> json <| "recipient"
      <*> json <| "sender"
  }
}
