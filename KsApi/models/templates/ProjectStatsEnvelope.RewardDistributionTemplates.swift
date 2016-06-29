extension ProjectStatsEnvelope.RewardStats {
  internal static let template = ProjectStatsEnvelope.RewardStats(
    backersCount: 50,
    rewardId: 400,
    minimum: 10,
    pledged: 500
  )

  internal static let unPledged = ProjectStatsEnvelope.RewardStats(
    backersCount: 0,
    rewardId: 0,
    minimum: 1,
    pledged: 0
  )
}
