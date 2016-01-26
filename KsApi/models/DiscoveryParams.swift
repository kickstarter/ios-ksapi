import Models
import Prelude

public struct DiscoveryParams {
  public let staffPicks: Bool?
  public let hasVideo: Bool?
  public let starred: Bool?
  public let backed: Bool?
  public let social: Bool?
  public let recommended: Bool?
  public let similarTo: Project?
  public let category: Models.Category?
  public let query: String?
  public let state: State?
  public let sort: Sort?
  public let page: Int?
  public let perPage: Int?
  public let includePOTD: Bool?
  public let seed: Int?

  public enum State: String {
    case All = "all"
    case Live = "live"
    case Successful = "successful"
  }

  public enum Sort: String {
    case Magic = "magic"
    case Popular = "popularity"
    case EndingSoon = "end_date"
    case Newest = "newest"
    case MostFunded = "most_funded"
  }

  static let defaultPage = 1
  static let defaultPerPage = 15

  public init(
    staffPicks: Bool? = nil,
    hasVideo: Bool? = nil,
    starred: Bool? = nil,
    backed: Bool? = nil,
    social: Bool? = nil,
    recommended: Bool? = nil,
    similarTo: Project? = nil,
    category: Models.Category? = nil,
    query: String? = nil,
    state: State? = nil,
    sort: Sort? = nil,
    page: Int? = defaultPage,
    perPage: Int? = defaultPerPage,
    includePOTD: Bool? = nil,
    seed: Int? = nil) {
      self.staffPicks = staffPicks
      self.hasVideo = hasVideo
      self.starred = starred
      self.backed = backed
      self.social = social
      self.recommended = recommended
      self.similarTo = similarTo
      self.category = category
      self.query = query
      self.state = state
      self.sort = sort
      self.page = page
      self.perPage = perPage
      self.includePOTD = includePOTD
      self.seed = seed
  }

  public func with(
    staffPicks staffPicks: Bool? = nil,
    hasVideo: Bool? = nil,
    starred: Bool? = nil,
    backed: Bool? = nil,
    social: Bool? = nil,
    recommended: Bool? = nil,
    similarTo: Project? = nil,
    category: Models.Category? = nil,
    query: String? = nil,
    state: State? = nil,
    sort: Sort? = nil,
    page: Int? = nil,
    perPage: Int? = nil,
    includePOTD: Bool? = nil,
    seed: Int? = nil) -> DiscoveryParams {

    return DiscoveryParams(
      staffPicks: staffPicks ?? self.staffPicks,
      hasVideo: hasVideo ?? self.hasVideo,
      starred: starred ?? self.starred,
      backed: backed ?? self.backed,
      social: social ?? self.social,
      recommended: recommended ?? self.recommended,
      similarTo: similarTo ?? self.similarTo,
      category: category ?? self.category,
      query: query ?? self.query,
      state: state ?? self.state,
      sort: sort ?? self.sort,
      page: page ?? self.page,
      perPage: perPage ?? self.perPage,
      includePOTD: includePOTD ?? self.includePOTD,
      seed: seed ?? self.seed)
  }

  public func nextPage() -> DiscoveryParams {
    return self.with(page: (page ?? 1) + 1)
  }

  public var queryParams: [String:String] {
    return [
      "staff_picks": self.staffPicks?.description,
      "has_video": self.hasVideo?.description,
      "starred": self.starred?.description,
      "backed" : self.backed?.description,
      "social": self.social?.description,
      "recommended": self.recommended?.description,
      "similar_to": self.similarTo?.id.description,
      "category_id": self.category?.id.description,
      "term": self.query,
      "state": self.state?.rawValue,
      "sort": self.sort?.rawValue,
      "page": self.page?.description,
      "per_page": self.perPage?.description,
      "include_potd": self.includePOTD?.description,
      "seed": self.seed?.description,
    ].compact()
  }
}

extension DiscoveryParams : Equatable {}
public func == (a: DiscoveryParams, b: DiscoveryParams) -> Bool {
  return a.queryParams == b.queryParams
}

extension DiscoveryParams : CustomStringConvertible, CustomDebugStringConvertible {
  public var description: String {
    return self.queryParams.description
  }

  public var debugDescription: String {
    return self.queryParams.debugDescription
  }
}
