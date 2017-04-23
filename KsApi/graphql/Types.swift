import Argo

public protocol IdField {
  var id: String { get }
}

public protocol NameField {
  var name: String { get }
}

public protocol CategoryField {
  associatedtype _CategoryType: CategoryType
  var category: _CategoryType { get }
}

public protocol CreatorField {
  associatedtype _UserType: UserType
  var creator: _UserType { get }
}

public protocol LocationField {
  associatedtype _LocationType: LocationType
  var location: _LocationType { get }
}

public protocol RootCategoriesField {
  associatedtype _CategoryType: CategoryType
  var rootCategories: [_CategoryType] { get }
}

public protocol SubcategoriesField {
  associatedtype _CategoryType: CategoryType
  var subcategories: [_CategoryType] { get }
}

public protocol SupportedCountriesField {
  associatedtype _CountryType: CountryType
  var supportedCountries: [_CountryType] { get }
}

public protocol CodeField {
  var code: String { get }
}

public protocol StateField {
  var state: GQLState { get }
}

public protocol ImageUrlField {
  var imageUrl: String { get }
}

public protocol FundingRatioField {
  var fundingRatio: Float { get }
}

public protocol DescriptionField {
  var description: String { get }
}

public protocol BackedProjectsField {
  associatedtype _ProjectType: ProjectType
  var backedProjects: [_ProjectType] { get }
}

public protocol RewardsField {
  associatedtype _RewardType: RewardType
  var rewards: [_RewardType] { get }
}

public protocol MeField {
  associatedtype _UserType: UserType
  var me: _UserType { get }
}

public enum GQLState: Decodable {
  case CANCELED
  case LIVE
  case FAILED
  case STARTED
  case SUBMITTED
  case SUCCESSFUL
  case SUSPENDED
  case UNKNOWN
  
  public static func decode(_ json: JSON) -> Decoded<GQLState> {
    switch json {
    case .string("CANCELED"):
      return .success(.CANCELED)
    case .string("LIVE"):
      return .success(.LIVE)
    case .string("FAILED"):
      return .success(.FAILED)
    case .string("STARTED"):
      return .success(.STARTED)
    case .string("SUBMITTED"):
      return .success(.SUBMITTED)
    case .string("SUCCESSFUL"):
      return .success(.SUCCESSFUL)
    case .string("SUSPENDED"):
      return .success(.SUSPENDED)
    default:
      return .success(.UNKNOWN)
    }
  }
}

public protocol CountryType {}
public protocol CategoryType {}
public protocol ProjectType {}
public protocol UserType {}
public protocol LocationType {}
public protocol RewardType {}
