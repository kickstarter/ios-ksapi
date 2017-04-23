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

  public struct Project: Decodable, ProjectType, IdField, NameField {
    public private(set) var id: String
    public private(set) var name: String

    public static func decode(_ json: JSON) -> Decoded<ProjectPageQueryResult.Project> {
      return pure(curry(Project.init))
        <*> json <| "id"
        <*> json <| "name"
    }
  }
}
