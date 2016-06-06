// swiftlint:disable type_name
import Prelude

extension MessageThread {
  public enum lens {
    public static let id = Lens<MessageThread, Int>(
      view: { $0.id },
      set: { MessageThread(backing: $1.backing, closed: $1.closed, id: 0, lastMessage: $1.lastMessage,
        participant: $1.participant, project: $1.project, unreadMessagesCount: $1.unreadMessagesCount) }
    )
  }
}
