import Argo
import Curry

extension Project {
  public struct Country {
    public let countryCode: String
    public let currencyCode: String
    public let currencySymbol: String
    public let trailingCode: Bool

    public static let US = Country(countryCode: "US", currencyCode: "USD", currencySymbol: "$",
                                   trailingCode: true)
    public static let CA = Country(countryCode: "CA", currencyCode: "CAD", currencySymbol: "$",
                                   trailingCode: true)
    public static let AU = Country(countryCode: "AU", currencyCode: "AUD", currencySymbol: "$",
                                   trailingCode: true)
    public static let NZ = Country(countryCode: "NZ", currencyCode: "NZD", currencySymbol: "$",
                                   trailingCode: true)

    public static let GB = Country(countryCode: "GB", currencyCode: "GBP", currencySymbol: "£",
                                   trailingCode: false)

    public static let NL = Country(countryCode: "NL", currencyCode: "EUR", currencySymbol: "€",
                                   trailingCode: false)
    public static let IE = Country(countryCode: "IE", currencyCode: "EUR", currencySymbol: "€",
                                   trailingCode: false)
    public static let DE = Country(countryCode: "DE", currencyCode: "EUR", currencySymbol: "€",
                                   trailingCode: false)
    public static let ES = Country(countryCode: "ES", currencyCode: "EUR", currencySymbol: "€",
                                   trailingCode: false)
    public static let FR = Country(countryCode: "FR", currencyCode: "EUR", currencySymbol: "€",
                                   trailingCode: false)
    public static let IT = Country(countryCode: "IT", currencyCode: "EUR", currencySymbol: "€",
                                   trailingCode: false)
    public static let AT = Country(countryCode: "AT", currencyCode: "EUR", currencySymbol: "€",
                                   trailingCode: false)
    public static let BE = Country(countryCode: "BE", currencyCode: "EUR", currencySymbol: "€",
                                   trailingCode: false)
    public static let LU = Country(countryCode: "LU", currencyCode: "EUR", currencySymbol: "€",
                                   trailingCode: false)

    public static let SE = Country(countryCode: "SE", currencyCode: "SEK", currencySymbol: "kr",
                                   trailingCode: true)
    public static let DK = Country(countryCode: "DK", currencyCode: "DKK", currencySymbol: "kr",
                                   trailingCode: true)
    public static let NO = Country(countryCode: "NO", currencyCode: "NOK", currencySymbol: "kr",
                                   trailingCode: true)
    public static let CH = Country(countryCode: "CH", currencyCode: "CHF", currencySymbol: "kr",
                                   trailingCode: true)
  }
}

extension Project.Country: Decodable {
  public static func decode(json: JSON) -> Decoded<Project.Country> {
    let create = curry(Project.Country.init)

    // Sometimes country JSON comes in this format, e.g. in project JSON.
    let firstPass = create
      <^> json <| "country"
      <*> json <| "currency"
      <*> json <| "currency_symbol"
      <*> json <| "currency_trailing_code"

    // Sometimes country JSON comes in this format, e.g. the config file.
    return firstPass <|> (create
      <^> json <| "name"
      <*> json <| "currency_code"
      <*> json <| "currency_symbol"
      <*> json <| "trailing_code")
  }
}

extension Project.Country: EncodableType {
  public func encode() -> [String : AnyObject] {
    var result: [String:AnyObject] = [:]
    result["country"] = self.countryCode
    result["currency"] = self.currencyCode
    result["currency_symbol"] = self.currencySymbol
    result["currency_trailing_code"] = self.trailingCode
    return result
  }
}

extension Project.Country: Equatable {}
public func == (lhs: Project.Country, rhs: Project.Country) -> Bool {
  return lhs.countryCode == rhs.countryCode &&
    lhs.currencySymbol == rhs.currencySymbol &&
    lhs.currencyCode == rhs.currencyCode &&
    lhs.trailingCode == rhs.trailingCode
}

extension Project.Country: CustomStringConvertible {
  public var description: String {
    return "(\(self.countryCode), \(self.currencyCode), \(self.currencySymbol))"
  }
}
