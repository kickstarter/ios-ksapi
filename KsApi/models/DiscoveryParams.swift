import Argo
import Curry
import Prelude

public struct DiscoveryParams {
  public let backed: Bool?
  public let category: Category?
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

  public enum State: String, Decodable {
    case all
    case live
    case successful
  }

  public enum Sort: String, Decodable {
    case endingSoon = "end_date"
    case magic
    case mostFunded = "most_funded"
    case newest
    case popular = "popularity"
  }

  public static let defaults = DiscoveryParams(backed: nil, category: nil, hasVideo: nil,
                                               includePOTD: nil, page: nil, perPage: nil, query: nil,
                                               recommended: nil, seed: nil, similarTo: nil, social: nil,
                                               sort: nil, staffPicks: nil, starred: nil, state: nil)

  public var queryParams: [String:String] {
    var params: [String:String] = [:]
    params["staff_picks"] = self.staffPicks?.description
    params["has_video"] = self.hasVideo?.description
    params["starred"] = self.starred == true ? "1" : self.starred == false ? "-1" : nil
    params["backed"] = self.backed == true ? "1" : self.backed == false ? "-1" : nil
    params["social"] = self.social == true ? "1" : self.social == false ? "-1" : nil
    params["recommended"] = self.recommended?.description
    params["similar_to"] = self.similarTo?.id.description
    params["category_id"] = self.category?.id.description
    params["term"] = self.query
    params["state"] = self.state?.rawValue
    params["sort"] = self.sort?.rawValue
    params["page"] = self.page?.description
    params["per_page"] = self.perPage?.description
    params["seed"] = self.seed?.description

    // Include the POTD only when searching for staff picks sorted by magic / no sort
    if params == ["staff_picks": "true"] ||
       params == ["staff_picks": "true", "sort": DiscoveryParams.Sort.magic.rawValue] {

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

extension DiscoveryParams: Decodable {
  public static func decode(json: JSON) -> Decoded<DiscoveryParams> {
    let j = curry(DiscoveryParams.init)
      <^> (json <|? "backed" >>- stringIntToBool)
      <*> json <|? "category"
      <*> (json <|? "has_video" >>- stringToBool)
      <*> (json <|? "include_potd" >>- stringToBool)
      <*> (json <|? "page" >>- stringToInt)
      <*> (json <|? "per_page" >>- stringToInt)
      <*> json <|? "term"
    return j
      <*> (json <|? "recommended" >>- stringToBool)
      <*> (json <|? "seed" >>- stringToInt)
      <*> json <|? "similar_to"
      <*> (json <|? "social" >>- stringIntToBool)
      <*> json <|? "sort"
      <*> (json <|? "staff_picks" >>- stringToBool)
      <*> (json <|? "starred" >>- stringIntToBool)
      <*> json <|? "state"
  }
}

private func stringToBool(string: String?) -> Decoded<Bool?> {
  guard let string = string else { return .Success(nil) }
  switch string {
  // taken from server's `value_to_boolean` function
  case "true", "1", "t", "T", "true", "TRUE", "on", "ON":
    return .Success(true)
  case "false", "0", "f", "F", "false", "FALSE", "off", "OFF":
    return .Success(false)
  default:
    return .Failure(.Custom("Could not parse string into bool."))
  }
}

private func stringToInt(string: String?) -> Decoded<Int?> {
  guard let string = string else { return .Success(nil) }
  return Int(string).map(Decoded.Success) ?? .Failure(.Custom("Could not parse string into int."))
}

private func stringIntToBool(string: String?) -> Decoded<Bool?> {
  guard let string = string else { return .Success(nil) }
  return Int(string)
    .optionalFilter { $0 <= 1 && $0 >= -1 }
    .map { .Success($0 == 0 ? nil : $0 == 1) }
    ?? .Failure(.Custom("Could not parse string into bool."))
}
