// Hopefully this can be code gen'd
// swiftlint:disable type_name
import Argo

public protocol CategoryType {}
public protocol CountryType {}
public protocol LocationType {}
public protocol MoneyType {}
public protocol ProjectType {}
public protocol ProjectsType {}
public protocol RewardType {}
public protocol UpdateType {}
public protocol UpdatesType {}
public protocol UserType {}

public protocol IdField {
  var id: String { get }
}

public protocol NameField {
  var name: String { get }
}

public protocol CanceledAtField {
  var canceledAt: TimeInterval? { get }
}

public protocol DeadlineAtField {
  var deadlineAt: TimeInterval? { get }
}

public protocol AmountField {
  var amount: String { get }
}

public protocol CurrencyField {
  var currency: GQLCurrency { get }
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

public protocol ProjectField {
  associatedtype _ProjectType: ProjectType
  var project: _ProjectType { get }
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
  var state: GQLProjectState { get }
}

public protocol ImageUrlField {
  var imageUrl: String { get }
}

public protocol SlugField {
  var slug: String { get }
}

public protocol UpdatesField {
  associatedtype _UpdatesType: UpdatesType
  var updates: _UpdatesType { get }
}

public protocol UrlField {
  var url: String { get }
}

public protocol FundingRatioField {
  var fundingRatio: Float { get }
}

public protocol DescriptionField {
  var description: String { get }
}

public protocol TotalCountField {
  var totalCount: Int { get }
}

public protocol IsProjectWeLoveField {
  var isProjectWeLove: Bool { get }
}

public protocol percentFundedField {
  var percentFunded: Float { get }
}

public protocol PledgedField {
  associatedtype _MoneyType: MoneyType
  var pledged: _MoneyType { get }
}

public protocol BackedProjectsField {
  associatedtype _ProjectType: ProjectType
  var backedProjects: [_ProjectType] { get }
}

// FIXME: this is a hack. it's technically a object of the form {projects: {nodes {}}
public protocol ProjectsField {
  associatedtype _ProjectsType: ProjectsType
  var projects: _ProjectsType { get }
}

public protocol RewardsField {
  associatedtype _RewardType: RewardType
  var rewards: [_RewardType] { get }
}

public protocol MeField {
  associatedtype _UserType: UserType
  var me: _UserType { get }
}

public enum GQLProjectState: Decodable {
  case CANCELED
  case LIVE
  case FAILED
  case STARTED
  case SUBMITTED
  case SUCCESSFUL
  case SUSPENDED
  case UNKNOWN

  public static func decode(_ json: JSON) -> Decoded<GQLProjectState> {
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

public enum GQLCurrency: Decodable {
  case AUD
  case CAD
  case CHF
  case DKK
  case EUR
  case GBP
  case HKD
  case MXN
  case NOK
  case NZD
  case SEK
  case SGD
  case USD
  case unknown(currency: String)

  public static func decode(_ json: JSON) -> Decoded<GQLCurrency> {
    switch json {
    case .string("AUD"):
      return .success(.AUD)
    case .string("CAD"):
      return .success(.CAD)
    case .string("CHF"):
      return .success(.CHF)
    case .string("DKK"):
      return .success(.DKK)
    case .string("EUR"):
      return .success(.EUR)
    case .string("GBP"):
      return .success(.GBP)
    case .string("HKD"):
      return .success(.HKD)
    case .string("MXN"):
      return .success(.MXN)
    case .string("NOK"):
      return .success(.NOK)
    case .string("NZD"):
      return .success(.NZD)
    case .string("SEK"):
      return .success(.SEK)
    case .string("SGD"):
      return .success(.SGD)
    case .string("USD"):
      return .success(.USD)
    case let .string(currency):
      return .success(.unknown(currency: currency))
    case .array, .bool, .null, .number, .object:
      return .failure(.typeMismatch(expected: "String", actual: "\(json)"))
    }
  }
}
