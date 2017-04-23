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
