import Argo
import Curry
import Runes

public let fetchStartupQuery: Set<Query> = [
  .rootCategories(
    [
      .id,
      .name,
      .subcategories(
        [
          .id,
          .name
        ]
      )
    ]
  ),
  .supportedCountries(
    [
      .code,
      .name
    ]
  )
]

public struct StartUpQueryResult: Decodable, RootCategoriesField, SupportedCountriesField {
  public private(set) var rootCategories: [Category]
  public private(set) var supportedCountries: [Country]
  
  public static func decode(_ json: JSON) -> Decoded<StartUpQueryResult> {
    return pure(curry(StartUpQueryResult.init))
      <*> json <|| ["data", "rootCategories"]
      <*> json <|| ["data", "supportedCountries"]
  }
  
  public struct Category: Decodable, CategoryType, IdField, NameField, SubcategoriesField {
    public private(set) var id: String
    public private(set) var name: String
    public private(set) var subcategories: [Category]
    
    public static func decode(_ json: JSON) -> Decoded<StartUpQueryResult.Category> {
      return pure(curry(Category.init))
        <*> json <| "id"
        <*> json <| "name"
        <*> (json <|| ["subcategories", "nodes"] <|> .success([]))
    }
  }
  
  public struct Country: Decodable, CountryType, CodeField, NameField {
    public private(set) var code: String
    public private(set) var name: String
    
    public static func decode(_ json: JSON) -> Decoded<StartUpQueryResult.Country> {
      return pure(curry(Country.init))
        <*> json <| "code"
        <*> json <| "name"
    }
  }
}
