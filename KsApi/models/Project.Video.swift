import Argo
import Curry

extension Project {
  public struct Video {
    public let id: Int
    public let high: String
  }
}

extension Project.Video: Decodable {
  static public func decode(json: JSON) -> Decoded<Project.Video> {
    return curry(Project.Video.init)
      <^> json <| "id"
      <*> json <| "high"
  }
}
