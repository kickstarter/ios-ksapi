import Argo
import Curry
import Runes

public let profileQuery: Set<Query> = [
  .me(
    [
      .backedProjects(
        [
          .id,
          .fundingRatio,
          .imageUrl(blur: false, width: 300),
          .name,
          .state
        ]
      ),
      .id,
      .name,
      .imageUrl(width: 300),
      .location(
        [
          .id,
          .name
        ]
      )
    ]
  )
]

public struct ProfileQueryResult: Decodable, MeField {
  public private(set) var me: User
  
  public static func decode(_ json: JSON) -> Decoded<ProfileQueryResult> {
    return pure(ProfileQueryResult.init) <*> json <| ["data", "me"]
  }
  
  public struct User: Decodable, UserType, BackedProjectsField, IdField, NameField, ImageUrlField, LocationField {
    public private(set) var backedProjects: [Project]
    public private(set) var id: String
    public private(set) var name: String
    public private(set) var imageUrl: String
    public private(set) var location: Location
    
    public static func decode(_ json: JSON) -> Decoded<ProfileQueryResult.User> {
      return pure(curry(User.init))
        <*> json <|| ["backedProjects", "nodes"]
        <*> json <| "id"
        <*> json <| "name"
        <*> json <| "imageUrl"
        <*> json <| "location"
    }
    
    public struct Location: Decodable, LocationType, IdField, NameField {
      public private(set) var id: String
      public private(set) var name: String
      
      public static func decode(_ json: JSON) -> Decoded<ProfileQueryResult.User.Location> {
        return pure(curry(Location.init))
          <*> json <| "id"
          <*> json <| "name"
      }
    }
    
    public struct Project: Decodable, ProjectType, IdField, FundingRatioField, ImageUrlField, NameField, StateField {
      public private(set) var id: String
      public private(set) var fundingRatio: Float
      public private(set) var imageUrl: String
      public private(set) var name: String
      public private(set) var state: GQLState
      
      public static func decode(_ json: JSON) -> Decoded<ProfileQueryResult.User.Project> {
        return pure(curry(Project.init))
          <*> json <| "id"
          <*> json <| "fundingRatio"
          <*> json <| "imageUrl"
          <*> json <| "name"
          <*> json <| "state"
      }
    }
  }
}

//public let fetchStartupQuery: Set<Query> = [
//  .rootCategories(
//    [
//      .id,
//      .name,
//      .subcategories(
//        [
//          .id,
//          .name
//        ]
//      )
//    ]
//  ),
//  .supportedCountries(
//    [
//      .code,
//      .name
//    ]
//  )
//]
//
//public struct StartUpQueryResult: Decodable, RootCategoriesField, SupportedCountriesField {
//  public private(set) var rootCategories: [Category]
//  public private(set) var supportedCountries: [Country]
//  
//  public static func decode(_ json: JSON) -> Decoded<StartUpQueryResult> {
//    return pure(curry(StartUpQueryResult.init))
//      <*> json <|| ["data", "rootCategories"]
//      <*> json <|| ["data", "supportedCountries"]
//  }
//  
//  public struct Category: Decodable, CategoryType, IdField, NameField, SubcategoriesField {
//    public private(set) var id: String
//    public private(set) var name: String
//    public private(set) var subcategories: [Category]
//    
//    public static func decode(_ json: JSON) -> Decoded<StartUpQueryResult.Category> {
//      return pure(curry(Category.init))
//        <*> json <| "id"
//        <*> json <| "name"
//        <*> (json <|| ["subcategories", "nodes"] <|> .success([]))
//    }
//  }
//  
//  public struct Country: Decodable, CountryType, CodeField, NameField {
//    public private(set) var code: String
//    public private(set) var name: String
//    
//    public static func decode(_ json: JSON) -> Decoded<StartUpQueryResult.Country> {
//      return pure(curry(Country.init))
//        <*> json <| "code"
//        <*> json <| "name"
//    }
//  }
//}
