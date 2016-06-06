// swiftlint:disable type_name
import Prelude

extension Message {
  public enum lens {
    public static let id = Lens<Message, Int>(
      view: { $0.id },
      set: { Message(body: $1.body, createdAt: $1.createdAt, id: $0, recipient: $1.recipient,
        sender: $1.sender) }
    )
  }
}
