// Hopefully this can be code gen'd
import Argo
import Curry
import Runes

public struct ProfileQueryResult: Decodable {
  public private(set) var me: User

  public static func decode(_ json: JSON) -> Decoded<ProfileQueryResult> {
    return pure(curry(self.init))
      <*> json <| ["data", "me"]
  }

  public struct User: Decodable, UserType, UserBackedProjectsConnectionField, IdField, NameField, ImageUrlField,
  LocationField {
    public private(set) var backedProjects: UserBackedProjectsConnection
    public private(set) var id: String
    public private(set) var name: String
    public private(set) var imageUrl: String
    public private(set) var location: Location

    public static func decode(_ json: JSON) -> Decoded<ProfileQueryResult.User> {
      let tmp1 = pure(curry(self.init))
        <*> json <| "backedProjects"
        <*> json <| "id"
        <*> json <| "name"
      let tmp2 = tmp1
        <*> json <| "imageUrl"
        <*> json <| "location"
      return tmp2
    }

    public struct UserBackedProjectsConnection: Decodable, UserBackedProjectsConnectionType, ProjectNodesField, PageInfoField {
      public private(set) var nodes: [Project]
      public private(set) var pageInfo: PageInfo

      public static func decode(_ json: JSON) -> Decoded<ProfileQueryResult.User.UserBackedProjectsConnection> {
        return pure(curry(self.init))
          <*> json <|| "nodes"
          <*> json <| "pageInfo"
      }

      public struct Project: Decodable, Equatable, ProjectType, DeadlineAtField, IdField, FundingRatioField, ImageUrlField, NameField, StateField {
        public private(set) var deadlineAt: TimeInterval?
        public private(set) var id: String
        public private(set) var fundingRatio: Float
        public private(set) var imageUrl: String
        public private(set) var name: String
        public private(set) var state: GQLProjectState

        public static func decode(_ json: JSON) -> Decoded<Project> {
          let tmp1 = pure(curry(self.init))
            <*> json <| "deadlineAt"
            <*> json <| "id"
            <*> json <| "fundingRatio"
          let tmp2 = tmp1
            <*> json <| "imageUrl"
            <*> json <| "name"
            <*> json <| "state"
          return tmp2
        }

        public static func == (lhs: Project, rhs: Project) -> Bool {
          return lhs.id == rhs.id
        }
      }

      public struct PageInfo: Decodable, PageInfoType, EndCursorField {
        public private(set) var endCursor: String?

        public static func decode(_ json: JSON) -> Decoded<PageInfo> {
          return pure(curry(self.init))
            <*> json <|? "endCursor"
        }
      }
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

  }
}
