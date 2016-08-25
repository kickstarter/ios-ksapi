import Argo
import Curry
import Prelude

public struct Project {
  public let backing: Backing?
  public let blurb: String
  public let category: Category
  public let country: Country
  public let creator: User
  public let memberData: MemberData
  public let dates: Dates
  public let id: Int
  public let location: Location
  public let name: String
  public let personalization: Personalization
  public let photo: Photo
  public let rewards: [Reward]
  public let slug: String
  public let state: State
  public let stats: Stats
  public let urls: UrlsEnvelope
  public let video: Video?

  public struct UrlsEnvelope {
    public let web: WebEnvelope

    public struct WebEnvelope {
      public let project: String
    }
  }

  public enum State: String, Decodable {
    case canceled
    case failed
    case live
    case purged
    case started
    case submitted
    case successful
    case suspended
  }

  public struct Stats {
    public let backersCount: Int
    public let commentsCount: Int?
    public let goal: Int
    public let pledged: Int
    public let staticUsdRate: Float
    public let updatesCount: Int?

    /// Percent funded as measured from `0.0` to `1.0`. See `percentFunded` for a value from `0` to `100`.
    public var fundingProgress: Float {
      return self.goal == 0 ? 0.0 : Float(self.pledged) / Float(self.goal)
    }

    /// Percent funded as measured from `0` to `100`. See `fundingProgress` for a value between `0.0`
    /// and `1.0`.
    public var percentFunded: Int {
      return Int(floor(self.fundingProgress * 100.0))
    }

    /// Pledged amount converted to USD.
    public var pledgedUsd: Int {
      return Int(floor(Float(self.pledged) * self.staticUsdRate))
    }

    /// Goal amount converted to USD.
    public var goalUsd: Int {
      return Int(floor(Float(self.goal) * self.staticUsdRate))
    }
  }

  public struct MemberData {
    public let lastUpdatePublishedAt: NSTimeInterval?
    public let permissions: [Permission]
    public let unreadMessagesCount: Int?
    public let unseenActivityCount: Int?

    public enum Permission: String {
      case editProject = "edit_project"
      case editFaq = "edit_faq"
      case post = "post"
      case comment = "comment"
      case viewPledges = "view_pledges"
      case fulfillment = "fulfillment"
      case unknown = "unknown"
    }
  }

  public struct Dates {
    public let deadline: NSTimeInterval
    public let featuredAt: NSTimeInterval?
    public let launchedAt: NSTimeInterval
    public let potdAt: NSTimeInterval?
    public let stateChangedAt: NSTimeInterval
  }

  public struct Personalization {
    public let backing: Backing?
    public let friends: [User]?
    public let isBacking: Bool?
    public let isStarred: Bool?
  }

  public struct Photo {
    public let full: String
    public let med: String
    public let size1024x768: String
    public let small: String
  }

  public var endsIn48Hours: Bool {
    return self.dates.deadline - NSDate().timeIntervalSince1970 <= 60.0 * 60.0 * 48.0
  }

  public func isFeaturedToday(today today: NSDate = NSDate(), calendar: NSCalendar = .currentCalendar())
    -> Bool {
    guard let featuredAt = self.dates.featuredAt else { return false }
    return isDateToday(date: featuredAt, today: today, calendar: calendar)
  }

  public func isPotdToday(today today: NSDate = NSDate(), calendar: NSCalendar = .currentCalendar()) -> Bool {
    guard let potdAt = self.dates.potdAt else { return false }
    return isDateToday(date: potdAt, today: today, calendar: calendar)
  }

  private func isDateToday(date date: NSTimeInterval, today: NSDate, calendar: NSCalendar) -> Bool {
    let startOfToday = calendar.startOfDayForDate(today)
    return Double.abs(startOfToday.timeIntervalSince1970 - date) < 60.0 * 60.0 * 24.0
  }
}

extension Project: Equatable {}
public func == (lhs: Project, rhs: Project) -> Bool {
  return lhs.id == rhs.id
}

extension Project: CustomDebugStringConvertible {
  public var debugDescription: String {
    return "Project(id: \(self.id), name: \"\(self.name)\")"
  }
}

extension Project: Decodable {
  static public func decode(json: JSON) -> Decoded<Project> {
    let create = curry(Project.init)
    let tmp1 = create
      <^> json <|? "backing"
      <*> json <| "blurb"
      <*> json <| "category"
      <*> Project.Country.decode(json)
      <*> json <| "creator"
    let tmp2 = tmp1
      <*> Project.MemberData.decode(json)
      <*> Project.Dates.decode(json)
      <*> json <| "id"
      <*> json <| "location"
      <*> json <| "name"
      <*> Project.Personalization.decode(json)
    return tmp2
      <*> json <| "photo"
      <*> (json <|| "rewards" <|> .Success([]))
      <*> json <| "slug"
      <*> json <| "state"
      <*> Project.Stats.decode(json)
      <*> json <| "urls"
      <*> json <|? "video"
  }
}

extension Project.UrlsEnvelope: Decodable {
  static public func decode(json: JSON) -> Decoded<Project.UrlsEnvelope> {
    return curry(Project.UrlsEnvelope.init)
      <^> json <| "web"
  }
}

extension Project.UrlsEnvelope.WebEnvelope: Decodable {
  public static func decode(json: JSON) -> Decoded<Project.UrlsEnvelope.WebEnvelope> {
    return curry(Project.UrlsEnvelope.WebEnvelope.init)
      <^> json <| "project"
  }
}

extension Project.Stats: Decodable {
  public static func decode(json: JSON) -> Decoded<Project.Stats> {
    return curry(Project.Stats.init)
      <^> json <| "backers_count"
      <*> json <|? "comments_count"
      <*> json <| "goal"
      <*> json <| "pledged"
      <*> (json <| "static_usd_rate") <|> .Success(1.0)
      <*> json <|? "updates_count"
  }
}

extension Project.MemberData: Decodable {
  public static func decode(json: JSON) -> Decoded<Project.MemberData> {
    return curry(Project.MemberData.init)
      <^> json <|? "last_update_published_at"
      <*> (removeUnknowns <^> (json <|| "permissions") <|> .Success([]))
      <*> json <|? "unread_messages_count"
      <*> json <|? "unseen_activity_count"
  }
}

extension Project.Dates: Decodable {
  public static func decode(json: JSON) -> Decoded<Project.Dates> {
    return curry(Project.Dates.init)
      <^> json <| "deadline"
      <*> json <|? "featured_at"
      <*> json <| "launched_at"
      <*> json <|? "potd_at"
      <*> json <| "state_changed_at"
  }
}

extension Project.Personalization: Decodable {
  public static func decode(json: JSON) -> Decoded<Project.Personalization> {
    return curry(Project.Personalization.init)
      <^> json <|? "backing"
      <*> json <||? "friends"
      <*> json <|? "is_backing"
      <*> json <|? "is_starred"
  }
}

extension Project.Photo: Decodable {
  static public func decode(json: JSON) -> Decoded<Project.Photo> {
    let create = curry(Project.Photo.init)
    return create
      <^> json <| "full"
      <*> json <| "med"
      <*> (json <| "1024x768") <|> (json <| "1024x576")
      <*> json <| "small"
  }
}

extension Project.MemberData.Permission: Decodable {
  public static func decode(json: JSON) -> Decoded<Project.MemberData.Permission> {
    if case .String(let permission) = json {
      return self.init(rawValue: permission).map(pure) ?? .Success(.unknown)
    }
    return .Success(.unknown)
  }
}

private func removeUnknowns(xs: [Project.MemberData.Permission]) -> [Project.MemberData.Permission] {
  return xs.filter { $0 != .unknown }
}
