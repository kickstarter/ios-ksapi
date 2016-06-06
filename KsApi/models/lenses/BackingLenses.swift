// swiftlint:disable type_name
import Prelude

extension Backing {
  public enum lens {
    public static let id = Lens<Backing, Int>(
      view: { $0.id },
      set: { Backing(amount: $1.amount, backerId: $1.backerId, id: $0, locationId: $1.locationId,
        pledgedAt: $1.pledgedAt, projectCountry: $1.projectCountry, projectId: $1.projectId,
        reward: $1.reward, rewardId: $1.rewardId, sequence: $1.sequence, shippingAmount: $1.shippingAmount,
        status: $1.status) }
    )

    public static let reward = Lens<Backing, Reward?>(
      view: { $0.reward },
      set: { Backing(amount: $1.amount, backerId: $1.backerId, id: $1.id, locationId: $1.locationId,
        pledgedAt: $1.pledgedAt, projectCountry: $1.projectCountry, projectId: $1.projectId,
        reward: $0, rewardId: $1.rewardId, sequence: $1.sequence, shippingAmount: $1.shippingAmount,
        status: $1.status) }
    )

    public static let rewardId = Lens<Backing, Int?>(
      view: { $0.rewardId },
      set: { Backing(amount: $1.amount, backerId: $1.backerId, id: $1.id, locationId: $1.locationId,
        pledgedAt: $1.pledgedAt, projectCountry: $1.projectCountry, projectId: $1.projectId,
        reward: $1.reward, rewardId: $0, sequence: $1.sequence, shippingAmount: $1.shippingAmount,
        status: $1.status) }
    )
  }
}
