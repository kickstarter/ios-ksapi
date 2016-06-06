// swiftlint:disable type_name
import Prelude

extension User {
  public enum lens {
    public static let avatar = Lens<User, User.Avatar>(
      view: { $0.avatar },
      set: { User(avatar: $0, id: $1.id, name: $1.name, newsletters: $1.newsletters,
        notifications: $1.notifications, stats: $1.stats) }
    )

    public static let id = Lens<User, Int>(
      view: { $0.id },
      set: { User(avatar: $1.avatar, id: $0, name: $1.name, newsletters: $1.newsletters,
        notifications: $1.notifications, stats: $1.stats) }
    )

    public static let name = Lens<User, String>(
      view: { $0.name },
      set: { User(avatar: $1.avatar, id: $1.id, name: $0, newsletters: $1.newsletters,
        notifications: $1.notifications, stats: $1.stats) }
    )

    public static let newsletters = Lens<User, User.NewsletterSubscriptions>(
      view: { $0.newsletters },
      set: { User(avatar: $1.avatar, id: $1.id, name: $1.name, newsletters: $0,
        notifications: $1.notifications, stats: $1.stats) }
    )

    public static let notifications = Lens<User, User.Notifications>(
      view: { $0.notifications },
      set: { User(avatar: $1.avatar, id: $1.id, name: $1.name, newsletters: $1.newsletters,
        notifications: $0, stats: $1.stats) }
    )

    public static let stats = Lens<User, User.Stats>(
      view: { $0.stats },
      set: { User(avatar: $1.avatar, id: $1.id, name: $1.name, newsletters: $1.newsletters,
        notifications: $1.notifications, stats: $0) }
    )
  }
}

extension LensType where Whole == User, Part == User.NewsletterSubscriptions {
  public var games: Lens<User, Bool?> {
    return User.lens.newsletters • User.NewsletterSubscriptions.lens.games
  }

  public var happening: Lens<User, Bool?> {
    return User.lens.newsletters • User.NewsletterSubscriptions.lens.happening
  }

  public var promo: Lens<User, Bool?> {
    return User.lens.newsletters • User.NewsletterSubscriptions.lens.promo
  }

  public var weekly: Lens<User, Bool?> {
    return User.lens.newsletters • User.NewsletterSubscriptions.lens.weekly
  }
}

extension LensType where Whole == User, Part == User.Notifications {
  public var backings: Lens<User, Bool?> {
    return User.lens.notifications • User.Notifications.lens.backings
  }

  public var comments: Lens<User, Bool?> {
    return User.lens.notifications • User.Notifications.lens.comments
  }

  public var follower: Lens<User, Bool?> {
    return User.lens.notifications • User.Notifications.lens.follower
  }

  public var friendActivity: Lens<User, Bool?> {
    return User.lens.notifications • User.Notifications.lens.friendActivity
  }

  public var postLikes: Lens<User, Bool?> {
    return User.lens.notifications • User.Notifications.lens.postLikes
  }

  public var updates: Lens<User, Bool?> {
    return User.lens.notifications • User.Notifications.lens.updates
  }

  public var mobileBackings: Lens<User, Bool?> {
    return User.lens.notifications • User.Notifications.lens.mobileBackings
  }

  public var mobileComments: Lens<User, Bool?> {
    return User.lens.notifications • User.Notifications.lens.mobileComments
  }

  public var mobileFollower: Lens<User, Bool?> {
    return User.lens.notifications • User.Notifications.lens.mobileFollower
  }

  public var mobileFriendActivity: Lens<User, Bool?> {
    return User.lens.notifications • User.Notifications.lens.mobileFriendActivity
  }

  public var mobilePostLikes: Lens<User, Bool?> {
    return User.lens.notifications • User.Notifications.lens.mobilePostLikes
  }

  public var mobileUpdates: Lens<User, Bool?> {
    return User.lens.notifications • User.Notifications.lens.mobileUpdates
  }
}

extension LensType where Whole == User, Part == User.Stats {
  public var backedProjectsCount: Lens<User, Int?> {
    return User.lens.stats • User.Stats.lens.backedProjectsCount
  }

  public var createdProjectsCount: Lens<User, Int?> {
    return User.lens.stats • User.Stats.lens.createdProjectsCount
  }

  public var starredProjectsCount: Lens<User, Int?> {
    return User.lens.stats • User.Stats.lens.starredProjectsCount
  }
}
