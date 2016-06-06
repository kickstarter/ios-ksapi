@testable import KsApi
import Prelude

extension Reward {
  internal static let template = Reward(
    backersCount: 50,
    description: "A cool thing",
    estimatedDeliveryOn: NSDate().timeIntervalSince1970 + 60.0 * 60.0 * 24.0 * 365.0,
    id: 1,
    limit: 100,
    minimum: 10,
    remaining: 50,
    shipping: Reward.Shipping(
      enabled: true,
      preference: .none,
      summary: "Ships anywhere in the world"
    )
  )

  internal static let noReward = template
    |> Reward.lens.id .~ 0
    <> Reward.lens.description .~ "No reward"
    <> Reward.lens.backersCount .~ nil
    <> Reward.lens.estimatedDeliveryOn .~ nil
    <> Reward.lens.remaining .~ nil
    <> Reward.lens.minimum .~ 1
    <> Reward.lens.limit .~ nil
}
