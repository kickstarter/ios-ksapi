import Argo
import Curry

public struct User {
  public let avatar: Avatar
  public let facebookConnected: Bool?
  public let id: Int
  public let isFriend: Bool?
  public let location: Location?
  public let name: String
  public let newsletters: NewsletterSubscriptions
  public let notifications: Notifications
  public let social: Bool?
  public let stats: Stats

  public struct Avatar {
    public let large: String?
    public let medium: String
    public let small: String
  }

  public struct NewsletterSubscriptions {
    public let games: Bool?
    public let happening: Bool?
    public let promo: Bool?
    public let weekly: Bool?
  }

  public struct Notifications {
    public let backings: Bool?
    public let comments: Bool?
    public let follower: Bool?
    public let friendActivity: Bool?
    public let mobileBackings: Bool?
    public let mobileComments: Bool?
    public let mobileFollower: Bool?
    public let mobileFriendActivity: Bool?
    public let mobilePostLikes: Bool?
    public let mobileUpdates: Bool?
    public let postLikes: Bool?
    public let updates: Bool?
  }

  public struct Stats {
    public let backedProjectsCount: Int?
    public let createdProjectsCount: Int?
    public let memberProjectsCount: Int?
    public let starredProjectsCount: Int?
    public let unansweredSurveysCount: Int?
    public let unreadMessagesCount: Int?
  }

  public var isCreator: Bool {
    return (self.stats.createdProjectsCount ?? 0) > 0
  }
}

extension User: Equatable {}
public func == (lhs: User, rhs: User) -> Bool {
  return lhs.id == rhs.id
}

extension User: CustomDebugStringConvertible {
  public var debugDescription: String {
    return "User(id: \(id), name: \"\(name)\")"
  }
}

extension User: Decodable {
  public static func decode(_ json: JSON) -> Decoded<User> {
    let create = curry(User.init)
    let tmp = create
      <^> json <| "avatar"
      <*> json <|? "facebook_connected"
      <*> json <| "id"
      <*> json <|? "is_friend"
      <*> json <|? "location"
    return tmp
      <*> json <| "name"
      <*> User.NewsletterSubscriptions.decode(json)
      <*> User.Notifications.decode(json)
      <*> json <|? "social"
      <*> User.Stats.decode(json)
  }
}

extension User: EncodableType {
  public func encode() -> [String:AnyObject] {
    var result: [String:AnyObject] = [:]
    result["avatar"] = self.avatar.encode() as AnyObject?
    result["facebook_connected"] = self.facebookConnected as AnyObject?? ?? false as AnyObject?
    result["id"] = self.id as AnyObject?
    result["is_friend"] = self.isFriend as AnyObject?? ?? false as AnyObject?
    result["location"] = self.location?.encode() as AnyObject?
    result["name"] = self.name as AnyObject?
    result = result.withAllValuesFrom(self.newsletters.encode())
    result = result.withAllValuesFrom(self.notifications.encode())
    result = result.withAllValuesFrom(self.stats.encode())

    return result
  }
}

extension User.Avatar: Decodable {
  public static func decode(_ json: JSON) -> Decoded<User.Avatar> {
    return curry(User.Avatar.init)
      <^> json <|? "large"
      <*> json <| "medium"
      <*> json <| "small"
  }
}

extension User.Avatar: EncodableType {
  public func encode() -> [String:AnyObject] {
    var ret = [
      "medium": self.medium,
      "small": self.small
    ]

    ret["large"] = self.large

    return ret as [String : AnyObject]
  }
}

extension User.NewsletterSubscriptions: Decodable {
  public static func decode(_ json: JSON) -> Decoded<User.NewsletterSubscriptions> {
    return curry(User.NewsletterSubscriptions.init)
      <^> json <|? "games_newsletter"
      <*> json <|? "happening_newsletter"
      <*> json <|? "promo_newsletter"
      <*> json <|? "weekly_newsletter"
  }
}

extension User.NewsletterSubscriptions: EncodableType {
  public func encode() -> [String: AnyObject] {
    var result: [String: AnyObject] = [:]
    result["games_newsletter"] = self.games as AnyObject?
    result["happening_newsletter"] = self.happening as AnyObject?
    result["promo_newsletter"] = self.promo as AnyObject?
    result["weekly_newsletter"] = self.weekly as AnyObject?
    return result
  }
}

extension User.NewsletterSubscriptions: Equatable {}
public func == (lhs: User.NewsletterSubscriptions, rhs: User.NewsletterSubscriptions) -> Bool {
  return lhs.games == rhs.games &&
    lhs.happening == rhs.happening &&
    lhs.promo == rhs.promo &&
    lhs.weekly == rhs.weekly
}

extension User.Notifications: Decodable {
  public static func decode(_ json: JSON) -> Decoded<User.Notifications> {
    let create = curry(User.Notifications.init)
    let tmp1 = create
      <^> json <|? "notify_of_backings"
      <*> json <|? "notify_of_comments"
      <*> json <|? "notify_of_follower"
      <*> json <|? "notify_of_friend_activity"
    let tmp2 = tmp1
      <*> json <|? "notify_mobile_of_backings"
      <*> json <|? "notify_mobile_of_comments"
      <*> json <|? "notify_mobile_of_follower"
      <*> json <|? "notify_mobile_of_friend_activity"
    return tmp2
      <*> json <|? "notify_mobile_of_post_likes"
      <*> json <|? "notify_mobile_of_updates"
      <*> json <|? "notify_of_post_likes"
      <*> json <|? "notify_of_updates"
  }
}

extension User.Notifications: EncodableType {
  public func encode() -> [String : AnyObject] {
    var result: [String: AnyObject] = [:]
    result["notify_of_backings"] = self.backings as AnyObject?
    result["notify_of_comments"] = self.comments as AnyObject?
    result["notify_of_follower"] = self.follower as AnyObject?
    result["notify_of_friend_activity"] = self.friendActivity as AnyObject?
    result["notify_of_post_likes"] = self.postLikes as AnyObject?
    result["notify_of_updates"] = self.updates as AnyObject?
    result["notify_mobile_of_backings"] = self.mobileBackings as AnyObject?
    result["notify_mobile_of_comments"] = self.mobileComments as AnyObject?
    result["notify_mobile_of_follower"] = self.mobileFollower as AnyObject?
    result["notify_mobile_of_friend_activity"] = self.mobileFriendActivity as AnyObject?
    result["notify_mobile_of_post_likes"] = self.mobilePostLikes as AnyObject?
    result["notify_mobile_of_updates"] = self.mobileUpdates as AnyObject?
    return result
  }
}

extension User.Notifications: Equatable {}
public func == (lhs: User.Notifications, rhs: User.Notifications) -> Bool {
  return lhs.backings == rhs.backings &&
    lhs.comments == rhs.comments &&
    lhs.follower == rhs.follower &&
    lhs.friendActivity == rhs.friendActivity &&
    lhs.mobileBackings == rhs.mobileBackings &&
    lhs.mobileComments == rhs.mobileComments &&
    lhs.mobileFollower == rhs.mobileFollower &&
    lhs.mobileFriendActivity == rhs.mobileFriendActivity &&
    lhs.mobilePostLikes == rhs.mobilePostLikes &&
    lhs.mobileUpdates == rhs.mobileUpdates &&
    lhs.postLikes == rhs.postLikes &&
    lhs.updates == rhs.updates
}

extension User.Stats: Decodable {
  public static func decode(_ json: JSON) -> Decoded<User.Stats> {
    let create = curry(User.Stats.init)
    return create
      <^> json <|? "backed_projects_count"
      <*> json <|? "created_projects_count"
      <*> json <|? "member_projects_count"
      <*> json <|? "starred_projects_count"
      <*> json <|? "unanswered_surveys_count"
      <*> json <|? "unread_messages_count"
  }
}

extension User.Stats: EncodableType {
  public func encode() -> [String: AnyObject] {
    var result: [String: AnyObject] = [:]
    result["backed_projects_count"] =  self.backedProjectsCount as AnyObject?
    result["created_projects_count"] = self.createdProjectsCount as AnyObject?
    result["member_projects_count"] = self.memberProjectsCount as AnyObject?
    result["starred_projects_count"] = self.starredProjectsCount as AnyObject?
    result["unanswered_surveys_count"] = self.unansweredSurveysCount as AnyObject?
    result["unread_messages_count"] =  self.unreadMessagesCount as AnyObject?
    return result
  }
}
