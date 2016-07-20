import Argo
import Curry

public struct ProjectStatsEnvelope {
  public let cumulativeStats: CumulativeStats
  public let fundingDistribution: [FundingDateStats]
  public let referralDistribution: [ReferrerStats]
  public let rewardDistribution: [RewardStats]
  public let videoStats: VideoStats?

  public struct CumulativeStats {
    public let averagePledge: Int
    public let backersCount: Int
    public let goal: Int
    public let percentRaised: Double
    public let pledged: Int
  }

  public struct FundingDateStats {
    public let backersCount: Int
    public let cumulativePledged: Int
    public let cumulativeBackersCount: Int
    public let date: NSTimeInterval
    public let pledged: Int
  }

  public struct ReferrerStats {
    public let backersCount: Int
    public let code: String
    public let percentageOfDollars: Double
    public let pledged: Int
    public let referrerName: String
    public let referrerType: ReferrerType

    public enum ReferrerType {
      case custom
      case external
      case `internal`
      case unknown
    }
  }

  public struct RewardStats {
    public let backersCount: Int
    public let rewardId: Int
    public let minimum: Int
    public let pledged: Int

    public static let zero = RewardStats(backersCount: 0, rewardId: 0, minimum: 0, pledged: 0)
  }

  public struct VideoStats {
    public let externalCompletions: Int
    public let externalStarts: Int
    public let internalCompletions: Int
    public let internalStarts: Int
  }
}

extension ProjectStatsEnvelope: Decodable {
  public static func decode(json: JSON) -> Decoded<ProjectStatsEnvelope> {
    return curry(ProjectStatsEnvelope.init)
      <^> json <| "cumulative"
      <*> json <|| "funding_distribution"
      <*> json <|| "referral_distribution"
      <*> json <|| "reward_distribution"
      <*> json <|? "video_stats"
  }
}

extension ProjectStatsEnvelope.CumulativeStats: Decodable {
  public static func decode(json: JSON) -> Decoded<ProjectStatsEnvelope.CumulativeStats> {
    return curry(ProjectStatsEnvelope.CumulativeStats.init)
      <^> json <| "average_pledge"
      <*> json <| "backers_count"
      <*> (json <| "goal" >>- stringToInt)
      <*> json <| "percent_raised"
      <*> (json <| "pledged" >>- stringToInt)
  }
}

extension ProjectStatsEnvelope.CumulativeStats: Equatable {}
public func == (lhs: ProjectStatsEnvelope.CumulativeStats, rhs: ProjectStatsEnvelope.CumulativeStats)
  -> Bool {
    return lhs.averagePledge == rhs.averagePledge
}

extension ProjectStatsEnvelope.FundingDateStats: Decodable {
  public static func decode(json: JSON) -> Decoded<ProjectStatsEnvelope.FundingDateStats> {
    return curry(ProjectStatsEnvelope.FundingDateStats.init)
      <^> (json <| "backers_count" <|> .Success(0))
      <*> ((json <| "cumulative_pledged" >>- stringToInt) <|> (json <| "cumulative_pledged"))
      <*> json <| "cumulative_backers_count"
      <*> json <| "date"
      <*> ((json <| "pledged" >>- stringToInt) <|> .Success(0))
  }
}

extension ProjectStatsEnvelope.FundingDateStats: Equatable {}
public func == (lhs: ProjectStatsEnvelope.FundingDateStats, rhs: ProjectStatsEnvelope.FundingDateStats) -> Bool {
  return lhs.date == rhs.date
}

extension ProjectStatsEnvelope.ReferrerStats: Decodable {
  public static func decode(json: JSON) -> Decoded<ProjectStatsEnvelope.ReferrerStats> {
    return curry(ProjectStatsEnvelope.ReferrerStats.init)
      <^> json <| "backers_count"
      <*> json <| "code"
      <*> (json <| "percentage_of_dollars" >>- stringToDouble)
      <*> (json <| "pledged" >>- stringToInt)
      <*> json <| "referrer_name"
      <*> json <| "referrer_type"
  }
}

extension ProjectStatsEnvelope.ReferrerStats: Equatable {}
public func == (lhs: ProjectStatsEnvelope.ReferrerStats, rhs: ProjectStatsEnvelope.ReferrerStats) -> Bool {
  return lhs.code == rhs.code
}

extension ProjectStatsEnvelope.ReferrerStats.ReferrerType: Decodable {
  public static func decode(json: JSON) -> Decoded<ProjectStatsEnvelope.ReferrerStats.ReferrerType> {
    if case .String(let referrerType) = json {
      switch referrerType.lowercaseString {
      case "custom":
        return .Success(.custom)
      case "external":
        return .Success(.external)
      case "kickstarter":
        return .Success(.`internal`)
      default:
        return .Success(.unknown)
      }
    }
    return .Success(.unknown)
  }
}

extension ProjectStatsEnvelope.RewardStats: Decodable {
  public static func decode(json: JSON) -> Decoded<ProjectStatsEnvelope.RewardStats> {
    let create = curry(ProjectStatsEnvelope.RewardStats.init)
    return create
      <^> json <| "backers_count"
      <*> json <| "reward_id"
      <*> (json <| "minimum" >>- stringToInt)
      <*> (json <| "pledged" >>- stringToInt)
  }
}

extension ProjectStatsEnvelope.RewardStats: Equatable {}
public func == (lhs: ProjectStatsEnvelope.RewardStats, rhs: ProjectStatsEnvelope.RewardStats)
  -> Bool {
  return lhs.rewardId == rhs.rewardId
}

extension ProjectStatsEnvelope.VideoStats: Decodable {
  public static func decode(json: JSON) -> Decoded<ProjectStatsEnvelope.VideoStats> {
    let create = curry(ProjectStatsEnvelope.VideoStats.init)
    return create
      <^> json <| "external_completions"
      <*> json <| "external_starts"
      <*> json <| "internal_completions"
      <*> json <| "internal_starts"
  }
}

extension ProjectStatsEnvelope.VideoStats: Equatable {}
public func == (lhs: ProjectStatsEnvelope.VideoStats, rhs: ProjectStatsEnvelope.VideoStats) -> Bool {
  return
    lhs.externalCompletions == rhs.externalCompletions &&
    lhs.externalStarts == rhs.externalStarts &&
    lhs.internalCompletions == rhs.internalCompletions &&
    lhs.internalStarts == rhs.internalStarts
}

private func stringToInt(string: String) -> Decoded<Int> {
  return
    Double(string).flatMap(Int.init).map(Decoded.Success) ??
      Int(string).map(Decoded.Success) ??
      .Success(0)
}

private func stringToDouble(string: String) -> Decoded<Double> {
  return Double(string).map(Decoded.Success) ?? .Success(0)
}
