import Argo
import Curry

extension User {
  public struct Avatar {
    public let medium: String
    public let small: String
    public let large: String?
  }
}

extension User.Avatar: Decodable {
  public static func decode(json: JSON) -> Decoded<User.Avatar> {
    return curry(User.Avatar.init)
      <^> json <| "medium"
      <*> json <| "small"
      <*> json <|? "large"
  }
}

extension User.Avatar: EncodableType {
  public func encode() -> [String:AnyObject] {
    var ret = [
      "medium": self.medium,
      "small": self.small
    ]

    if let large = self.large {
      ret["large"] = large
    }

    return ret
  }
}
