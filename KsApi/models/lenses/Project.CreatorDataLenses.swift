// swiftlint:disable type_name
import Prelude

extension Project.CreatorData {
  public enum lens {
    public static let lastUpdatePublishedAt = Lens<Project.CreatorData, NSTimeInterval?>(
      view: { $0.lastUpdatePublishedAt },
      set: { Project.CreatorData(lastUpdatePublishedAt: $0, unreadMessagesCount: $1.unreadMessagesCount,
        unseenActivityCount: $1.unseenActivityCount) }
    )

    public static let unreadMessagesCount = Lens<Project.CreatorData, Int?>(
      view: { $0.unreadMessagesCount },
      set: { Project.CreatorData(lastUpdatePublishedAt: $1.lastUpdatePublishedAt, unreadMessagesCount: $0,
        unseenActivityCount: $1.unseenActivityCount) }
    )

    public static let unseenActivityCount = Lens<Project.CreatorData, Int?>(
      view: { $0.unseenActivityCount },
      set: { Project.CreatorData(lastUpdatePublishedAt: $1.lastUpdatePublishedAt,
        unreadMessagesCount: $1.unreadMessagesCount, unseenActivityCount: $0) }
    )
  }
}
