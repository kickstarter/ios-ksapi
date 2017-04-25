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

  public struct Project: Decodable, ProjectType, CanceledAtField, CategoryField, DeadlineAtField, DescriptionField, IdField, NameField {

    public private(set) var canceledAt: TimeInterval?
    public private(set) var category: Category
    public private(set) var deadlineAt: TimeInterval?
    public private(set) var description: String
    public private(set) var fundingRatio: Float
    public private(set) var goal: Money
    public private(set) var id: String
    public private(set) var name: String

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
        <*> json <| "name"
      return tmp3
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

    public struct Money: Decodable, CurrencyType, AmountField, CurrencyField {
      public private(set) var amount: String
      public private(set) var currency: GQLCurrency

      public static func decode(_ json: JSON) -> Decoded<ProjectPageQueryResult.Project.Money> {
        return pure(curry(self.init))
          <*> json <| "amount"
          <*> json <| "currency"
      }
    }
  }
}
