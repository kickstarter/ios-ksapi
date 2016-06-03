import Models
import Prelude

public struct DiscoveryParams {
  public let backed: Bool?
  public let category: Models.Category?
  public let hasVideo: Bool?
  public let includePOTD: Bool?
  public let page: Int?
  public let perPage: Int?
  public let query: String?
  public let recommended: Bool?
  public let seed: Int?
  public let similarTo: Project?
  public let social: Bool?
  public let sort: Sort?
  public let staffPicks: Bool?
  public let starred: Bool?
  public let state: State?

  public enum State: String {
    case All = "all"
    case Live = "live"
    case Successful = "successful"
  }

  public enum Sort: String {
    case EndingSoon = "end_date"
    case Magic = "magic"
    case MostFunded = "most_funded"
    case Newest = "newest"
    case Popular = "popularity"
  }

  public static let defaults = DiscoveryParams(backed: nil, category: nil, hasVideo: nil,
                                               includePOTD: nil, page: nil, perPage: nil, query: nil,
                                               recommended: nil, seed: nil, similarTo: nil, social: nil,
                                               sort: nil, staffPicks: nil, starred: nil, state: nil)

  public var queryParams: [String:String] {
    var params: [String:String] = [
      "staff_picks": self.staffPicks?.description,
      "has_video": self.hasVideo?.description,
      "starred": self.starred == true ? "1" : self.starred == false ? "-1" : nil,
      "backed": self.backed == true ? "1" : self.backed == false ? "-1" : nil,
      "social": self.social == true ? "1" : self.social == false ? "-1" : nil,
      "recommended": self.recommended?.description,
      "similar_to": self.similarTo?.id.description,
      "category_id": self.category?.id.description,
      "term": self.query,
      "state": self.state?.rawValue,
      "sort": self.sort?.rawValue,
      "page": self.page?.description,
      "per_page": self.perPage?.description,
      "seed": self.seed?.description,
    ].compact()

    // Include the POTD only when searching for staff picks sorted by magic / no sort
    if params == ["staff_picks": "true"] ||
       params == ["staff_picks": "true", "sort": DiscoveryParams.Sort.Magic.rawValue] {

      params["include_potd"] = self.includePOTD?.description
    }

    return params
  }
}

extension DiscoveryParams: Equatable {}
public func == (a: DiscoveryParams, b: DiscoveryParams) -> Bool {
  return a.queryParams == b.queryParams
}

extension DiscoveryParams: Hashable {
  public var hashValue: Int {
    return self.description.hash
  }
}

extension DiscoveryParams: CustomStringConvertible, CustomDebugStringConvertible {
  public var description: String {
    return self.queryParams.description
  }

  public var debugDescription: String {
    return self.queryParams.debugDescription
  }
}
