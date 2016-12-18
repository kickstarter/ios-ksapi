import Argo
import Curry

public struct Config {
  public let abExperiments: [String:String]
  public let appId: Int
  public let applePayCountries: [String]
  public let countryCode: String
  public let features: [String:Bool]
  public let iTunesLink: String
  public let launchedCountries: [Project.Country]
  public let locale: String
  public let stripePublishableKey: String
}

extension Config: Decodable {
  public static func decode(_ json: JSON) -> Decoded<Config> {
    let create = curry(Config.init)
    let tmp = create
      <^> decodeDictionary(json <| "ab_experiments")
      <*> json <| "app_id"
      <*> json <|| "apple_pay_countries"
      <*> json <| "country_code"
      <*> decodeDictionary(json <| "features")
    return tmp
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
    lhs.applePayCountries == rhs.applePayCountries &&
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
    result["ab_experiments"] = self.abExperiments as AnyObject?
    result["app_id"] = self.appId as AnyObject?
    result["apple_pay_countries"] = self.applePayCountries as AnyObject?
    result["country_code"] = self.countryCode as AnyObject?
    result["features"] = self.features as AnyObject?
    result["itunes_link"] = self.iTunesLink as AnyObject?
    result["launched_countries"] = self.launchedCountries.map { $0.encode() }
    result["locale"] = self.locale as AnyObject?
    result["stripe"] = ["publishable_key": self.stripePublishableKey]
    return result
  }
}

// Useful for getting around swift optimization bug: https://github.com/thoughtbot/Argo/issues/363
// Turns out using `>>-` or `flatMap` on a `Decoded` fails to compile with optimizations on, so this
// function does it manually.
private func decodeDictionary<T: Decodable>(_ j: Decoded<JSON>)
  -> Decoded<[String:T]> where T.DecodedType == T {
  switch j {
  case let .Success(json): return [String: T].decode(json)
  case let .Failure(e): return .Failure(e)
  }
}
