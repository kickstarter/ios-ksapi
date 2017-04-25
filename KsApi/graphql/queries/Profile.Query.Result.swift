// Hopefully this can be code gen'd
import Argo
import Curry
import Runes

public struct ProfileQueryResult: Decodable, MeField {
  public private(set) var me: User

  public static func decode(_ json: JSON) -> Decoded<ProfileQueryResult> {
    return pure(ProfileQueryResult.init) <*> json <| ["data", "me"]
  }

  public struct User: Decodable, UserType, BackedProjectsField, IdField, NameField, ImageUrlField,
  LocationField {
    public private(set) var backedProjects: [Project]
    public private(set) var id: String
    public private(set) var name: String
    public private(set) var imageUrl: String
    public private(set) var location: Location

    public static func decode(_ json: JSON) -> Decoded<ProfileQueryResult.User> {
      let tmp1 = pure(curry(User.init))
        <*> json <|| ["backedProjects", "nodes"]
        <*> json <| "id"
        <*> json <| "name"
      let tmp2 = tmp1
        <*> json <| "imageUrl"
        <*> json <| "location"
      return tmp2
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

    public struct Project: Decodable, ProjectType, IdField, FundingRatioField, ImageUrlField, NameField,
    StateField {
      public private(set) var id: String
      public private(set) var fundingRatio: Float
      public private(set) var imageUrl: String
      public private(set) var name: String
      public private(set) var state: GQLProjectState

      public static func decode(_ json: JSON) -> Decoded<ProfileQueryResult.User.Project> {
        let tmp1 = pure(curry(Project.init))
          <*> json <| "id"
          <*> json <| "fundingRatio"
          <*> json <| "imageUrl"
        let tmp2 = tmp1
          <*> json <| "name"
          <*> json <| "state"
        return tmp2
      }
    }
  }
}
