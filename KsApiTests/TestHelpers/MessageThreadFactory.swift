@testable import KsApi

extension MessageThread {
  internal static let template = MessageThread(
    backing: nil,
    closed: false,
    id: 1,
    lastMessage: Message.template,
    participant: User.template,
    project: Project.template,
    unreadMessagesCount: 1
  )
}
