// swiftlint:disable type_name
import Prelude

extension ProjectStatsEnvelope {
  public enum lens {

    public static let cumulative = Lens<ProjectStatsEnvelope, ProjectStatsEnvelope.Cumulative>(
      view: { $0.cumulative },
      set: { ProjectStatsEnvelope(cumulative: $0, fundingDistribution: $1.fundingDistribution,
        referralDistribution: $1.referralDistribution, rewardStats: $1.rewardStats,
        videoStats: $1.videoStats) }
    )

    public static let rewardStats = Lens<ProjectStatsEnvelope, [RewardStats]>(
      view: { $0.rewardStats },
      set: { ProjectStatsEnvelope(cumulative: $1.cumulative, fundingDistribution: $1.fundingDistribution,
        referralDistribution: $1.referralDistribution, rewardStats: $0,
        videoStats: $1.videoStats) }
    )

    public static let videoStats = Lens<ProjectStatsEnvelope, ProjectStatsEnvelope.VideoStats?>(
      view: { $0.videoStats },
      set: { ProjectStatsEnvelope(cumulative: $1.cumulative, fundingDistribution: $1.fundingDistribution,
        referralDistribution: $1.referralDistribution, rewardStats: $1.rewardStats,
        videoStats: $0) }
    )
  }
}
