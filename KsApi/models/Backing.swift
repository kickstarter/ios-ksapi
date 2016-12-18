import Argo
import Curry

public struct Backing {
  public let amount: Int
  public let backer: User?
  public let backerId: Int
  public let id: Int
  public let locationId: Int?
  public let pledgedAt: TimeInterval
  public let projectCountry: String
  public let projectId: Int
  public let reward: Reward?
  public let rewardId: Int?
  public let sequence: Int
  public let shippingAmount: Int?
  public let status: Status

  public enum Status: String {
    case canceled
    case collected
    case dropped
    case errored
    case pledged
    case preauth
  }
}

extension Backing: Equatable {
}
public func == (lhs: Backing, rhs: Backing) -> Bool {
  return lhs.id == rhs.id
}

extension Backing: Decodable {
  public static func decode(_ json: JSON) -> Decoded<Backing> {
    let create = curry(Backing.init)
    let tmp = create
      <^> json <| "amount"
      <*> json <|? "backer"
      <*> json <| "backer_id"
      <*> json <| "id"
      <*> json <|? "location_id"
      <*> json <| "pledged_at"
      <*> json <| "project_country"
    return tmp
      <*> json <| "project_id"
      <*> json <|? "reward"
      <*> json <|? "reward_id"
      <*> json <| "sequence"
      <*> json <|? "shipping_amount"
      <*> json <| "status"
  }
}

extension Backing.Status: Decodable {
}
