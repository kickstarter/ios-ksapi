import Argo
import Curry

public struct Reward {
  public let backersCount: Int?
  public let description: String
  public let estimatedDeliveryOn: NSTimeInterval?
  public let id: Int
  public let limit: Int?
  public let minimum: Int
  public let remaining: Int?
  public let shipping: Shipping

  /// Returns `true` is this is the "fake" "No reward" reward.
  public var isNoReward: Bool {
    return id == 0
  }

  public struct Shipping {
    public let enabled: Bool
    public let preference: Preference?
    public let summary: String?

    // swiftlint:disable type_name
    public enum Preference: String {
      case none
      case restricted
      case unrestricted
    }
    // swiftlint:enable type_name
  }
}

extension Reward: Equatable {}
public func == (lhs: Reward, rhs: Reward) -> Bool {
  return lhs.id == rhs.id
}

extension Reward: Comparable {}
public func < (lhs: Reward, rhs: Reward) -> Bool {
  if lhs.minimum < rhs.minimum {
    return true
  }
  if lhs.minimum == rhs.minimum && lhs.id < rhs.id {
    return true
  }
  return false
}

extension Reward: Decodable {
  public static func decode(json: JSON) -> Decoded<Reward> {
    let create = curry(Reward.init)
    let tmp = create
      <^> json <|? "backers_count"
      <*> (json <| "description" <|> json <| "reward")
      <*> json <|? "estimated_delivery_on"
      <*> json <| "id"
    return tmp
      <*> json <|? "limit"
      <*> json <| "minimum"
      <*> json <|? "remaining"
      <*> Reward.Shipping.decode(json)
  }
}

extension Reward.Shipping: Decodable {
  public static func decode(json: JSON) -> Decoded<Reward.Shipping> {
    return curry(Reward.Shipping.init)
      <^> json <| "shipping_enabled" <|> .Success(false)
      <*> json <|? "shipping_preference"
      <*> json <|? "shipping_summary"
  }
}

extension Reward.Shipping.Preference: Decodable {
}
