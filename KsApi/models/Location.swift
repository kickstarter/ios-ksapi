import Argo
import Curry

public struct Location {
  public let displayableName: String
  public let id: Int
  public let name: String
}

extension Location: Equatable {}
public func == (lhs: Location, rhs: Location) -> Bool {
  return lhs.id == rhs.id
}

extension Location: Decodable {
  static public func decode(json: JSON) -> Decoded<Location> {
    return curry(Location.init)
      <^> json <| "displayable_name"
      <*> json <| "id"
      <*> json <| "name"
  }
}
