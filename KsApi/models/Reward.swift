import Argo
import Curry
import Prelude

public struct Reward {
  public let backersCount: Int?
  public let description: String
  public let estimatedDeliveryOn: NSTimeInterval?
  public let id: Int
  public let limit: Int?
  public let minimum: Int
  public let remaining: Int?
  public let rewardsItems: [RewardsItem]
  public let shipping: Shipping
  public let title: String?

  /// Returns `true` is this is the "fake" "No reward" reward.
  public var isNoReward: Bool {
    return self.id == Reward.noReward.id
  }

  public struct Shipping {
    public let enabled: Bool
    public let preference: Preference?
    public let summary: String?

    public enum Preference: String {
      case none
      case restricted
      case unrestricted
    }
  }
}

extension Reward: Equatable {}
public func == (lhs: Reward, rhs: Reward) -> Bool {
  return lhs.id == rhs.id
}

private let minimumAndIdComparator = Reward.lens.minimum.comparator <> Reward.lens.id.comparator

extension Reward: Comparable {}
public func < (lhs: Reward, rhs: Reward) -> Bool {
  return minimumAndIdComparator.isOrdered(lhs, rhs)
}

extension Reward: Decodable {
  public static func decode(json: JSON) -> Decoded<Reward> {
    let create = curry(Reward.init)
    let tmp = create
      <^> json <|? "backers_count"
      <*> (json <| "description" <|> json <| "reward")
      <*> json <|? "estimated_delivery_on"
      <*> json <| "id"
      <*> json <|? "limit"
    return tmp
      <*> json <| "minimum"
      <*> json <|? "remaining"
      <*> ((json <|| "rewards_items") <|> .Success([]))
      <*> Reward.Shipping.decode(json)
      <*> json <|? "title"
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

extension Reward.Shipping.Preference: Decodable {}
