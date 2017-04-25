// Hopefully this can be code gen'd
import Argo
import Curry
import Runes

public struct ProjectPageQueryResult: Decodable, ProjectField {
  public private(set) var project: Project

  public static func decode(_ json: JSON) -> Decoded<ProjectPageQueryResult> {
    return pure(curry(ProjectPageQueryResult.init))
      <*> json <| ["data", "project"]
  }

  public struct Project: Decodable, ProjectType, CanceledAtField, CategoryField, DeadlineAtField, DescriptionField, FundingRatioField, IdField, ImageUrlField, IsProjectWeLoveField, LocationField, NameField, percentFundedField, PledgedField, RewardsField, StateField, UpdatesField, UrlField {

    public private(set) var canceledAt: TimeInterval?
    public private(set) var category: Category
    public private(set) var deadlineAt: TimeInterval?
    public private(set) var description: String
    public private(set) var fundingRatio: Float
    public private(set) var goal: Money
    public private(set) var id: String
    public private(set) var imageUrl: String
    public private(set) var isProjectWeLove: Bool
    public private(set) var location: Location
    public private(set) var name: String
    public private(set) var percentFunded: Float
    public private(set) var pledged: Money
    public private(set) var rewards: [Reward]
    public private(set) var slug: String
    public private(set) var state: GQLProjectState
    public private(set) var updates: Updates
    public private(set) var url: String

    public static func decode(_ json: JSON) -> Decoded<ProjectPageQueryResult.Project> {
      let tmp1 = pure(curry(Project.init))
        <*> json <|? "canceledAt"
        <*> json <| "category"
        <*> json <| "deadlineAt"
      let tmp2 = tmp1
        <*> json <| "description"
        <*> json <| "fundingRatio"
        <*> json <| "goal"
      let tmp3 = tmp2
        <*> json <| "id"
        <*> json <| "imageUrl"
        <*> json <| "isProjectWeLove"
      let tmp4 = tmp3
        <*> json <| "location"
        <*> json <| "name"
        <*> json <| "percentFunded"
      let tmp5 = tmp4
        <*> json <| "pledged"
        <*> json <|| ["rewards", "nodes"]
        <*> json <| "slug"
      let tmp6 = tmp5
        <*> json <| "state"
        <*> json <| "updates"
        <*> json <| "url"
      return tmp6
    }

    public struct Category: Decodable, CategoryType, IdField, NameField {
      public private(set) var id: String
      public private(set) var name: String

      public static func decode(_ json: JSON) -> Decoded<ProjectPageQueryResult.Project.Category> {
        return pure(curry(self.init))
          <*> json <| "id"
          <*> json <| "name"
      }
    }

    public struct Location: Decodable, LocationType, IdField, NameField {
      public private(set) var id: String
      public private(set) var name: String

      public static func decode(_ json: JSON) -> Decoded<ProjectPageQueryResult.Project.Location> {
        return pure(curry(self.init))
          <*> json <| "id"
          <*> json <| "name"
      }
    }

    public struct Money: Decodable, MoneyType, AmountField, CurrencyField {
      public private(set) var amount: String
      public private(set) var currency: GQLCurrency

      public static func decode(_ json: JSON) -> Decoded<ProjectPageQueryResult.Project.Money> {
        return pure(curry(self.init))
          <*> json <| "amount"
          <*> json <| "currency"
      }
    }

    public struct Reward: Decodable, RewardType, DescriptionField, IdField, NameField {
      public private(set) var description: String
      public private(set) var id: String
      public private(set) var name: String

      public static func decode(_ json: JSON) -> Decoded<ProjectPageQueryResult.Project.Reward> {
        return pure(curry(self.init))
          <*> json <| "description"
          <*> json <| "id"
          <*> json <| "name"
      }
    }

    public struct Updates: Decodable, UpdatesType, TotalCountField {
      public private(set) var totalCount: Int

      public static func decode(_ json: JSON) -> Decoded<ProjectPageQueryResult.Project.Updates> {
        return pure(curry(self.init)) <*> json <| "totalCount"
      }
    }
  }
}
