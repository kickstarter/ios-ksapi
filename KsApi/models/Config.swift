import Argo
import Curry
import Models

public struct Config {
  public let abExperiments: [String:String]
  public let appId: Int
  public let countryCode: String
  public let features: [String:Bool]
  public let iTunesLink: String
  public let launchedCountries: [Project.Country]
  public let locale: String
  public let stripePublishableKey: String
}

extension Config: Decodable {
  public static func decode(json: JSON) -> Decoded<Config> {
    let create = curry(Config.init)
    return create
      <^> (json <| "ab_experiments" >>- [String:String].decode)
      <*> json <| "app_id"
      <*> json <| "country_code"
      <*> (json <| "features" >>- [String:Bool].decode)
      <*> json <| "itunes_link"
      <*> json <|| "launched_countries"
      <*> json <| "locale"
      <*> json <| ["stripe", "publishable_key"]
  }
}

extension Config: Equatable {
}
public func == (lhs: Config, rhs: Config) -> Bool {
  return lhs.abExperiments == rhs.abExperiments &&
    lhs.appId == rhs.appId &&
    lhs.countryCode == rhs.countryCode &&
    lhs.features == rhs.features &&
    lhs.iTunesLink == rhs.iTunesLink &&
    lhs.launchedCountries == rhs.launchedCountries &&
    lhs.locale == rhs.locale &&
    lhs.stripePublishableKey == rhs.stripePublishableKey
}

extension Config: EncodableType {
  public func encode() -> [String : AnyObject] {
    var result: [String:AnyObject] = [:]
    result["ab_experiments"] = self.abExperiments
    result["app_id"] = self.appId
    result["country_code"] = self.countryCode
    result["features"] = self.features
    result["itunes_link"] = self.iTunesLink
    result["launched_countries"] = self.launchedCountries.map { $0.encode() }
    result["locale"] = self.locale
    result["stripe"] = ["publishable_key": self.stripePublishableKey]
    return result
  }
}
