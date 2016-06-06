@testable import KsApi

extension Backing {
  internal static let template = Backing(
    amount: 10,
    backerId: 1,
    id: 1,
    locationId: 1,
    pledgedAt: 123456789.0,
    projectCountry: "US",
    projectId: 1,
    reward: Reward.template,
    rewardId: 1,
    sequence: 10,
    shippingAmount: 2,
    status: .pledged
  )
}
