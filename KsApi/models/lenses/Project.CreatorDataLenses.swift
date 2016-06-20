// swiftlint:disable type_name
import Prelude

extension Project.CreatorData {
  public enum lens {
    public static let lastUpdatePublishedAt = Lens<Project.CreatorData, NSTimeInterval?>(
      view: { $0.lastUpdatePublishedAt },
      set: { Project.CreatorData(lastUpdatePublishedAt: $0, permissions: $1.permissions,
        unreadMessagesCount: $1.unreadMessagesCount, unseenActivityCount: $1.unseenActivityCount) }
    )

    public static let permissions = Lens<Project.CreatorData, [Project.CreatorData.Permission]>(
      view: { $0.permissions },
      set: { Project.CreatorData(lastUpdatePublishedAt: $1.lastUpdatePublishedAt, permissions: $0,
        unreadMessagesCount: $1.unreadMessagesCount, unseenActivityCount: $1.unseenActivityCount) }
    )

    public static let unreadMessagesCount = Lens<Project.CreatorData, Int?>(
      view: { $0.unreadMessagesCount },
      set: { Project.CreatorData(lastUpdatePublishedAt: $1.lastUpdatePublishedAt, permissions: $1.permissions,
        unreadMessagesCount: $0, unseenActivityCount: $1.unseenActivityCount) }
    )

    public static let unseenActivityCount = Lens<Project.CreatorData, Int?>(
      view: { $0.unseenActivityCount },
      set: { Project.CreatorData(lastUpdatePublishedAt: $1.lastUpdatePublishedAt, permissions: $1.permissions,
        unreadMessagesCount: $1.unreadMessagesCount, unseenActivityCount: $0) }
    )
  }
}
