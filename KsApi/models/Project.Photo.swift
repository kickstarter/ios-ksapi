import Argo
import Curry

extension Project {
  public struct Photo {
    public let full: String
    public let med: String
    public let size1024x768: String
    public let small: String
  }
}

extension Project.Photo: Decodable {
  static public func decode(json: JSON) -> Decoded<Project.Photo> {
    let create = curry(Project.Photo.init)
    return create
      <^> json <| "full"
      <*> json <| "med"
      <*> (json <| "1024x768") <|> (json <| "1024x576")
      <*> json <| "small"
  }
}
