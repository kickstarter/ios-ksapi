// swiftlint:disable type_name
import Prelude

extension ProjectStatsEnvelope {
  public enum lens {
    public static let cumulative = Lens<ProjectStatsEnvelope, ProjectStatsEnvelope.Cumulative>(
      view: { $0.cumulative },
      set: { ProjectStatsEnvelope(cumulative: $0, fundingDistribution: $1.fundingDistribution,
        referrerStats: $1.referrerStats, rewardStats: $1.rewardStats,
        videoStats: $1.videoStats) }
    )

    public static let referrerStats =
      Lens<ProjectStatsEnvelope, [ProjectStatsEnvelope.ReferrerStats]>(
        view: { $0.referrerStats },
        set: { ProjectStatsEnvelope(cumulative: $1.cumulative, fundingDistribution: $1.fundingDistribution,
          referrerStats: $0, rewardStats: $1.rewardStats, videoStats: $1.videoStats) }
    )

    public static let rewardStats = Lens<ProjectStatsEnvelope, [RewardStats]>(
      view: { $0.rewardStats },
      set: { ProjectStatsEnvelope(cumulative: $1.cumulative, fundingDistribution: $1.fundingDistribution,
        referrerStats: $1.referrerStats, rewardStats: $0,
        videoStats: $1.videoStats) }
    )

    public static let videoStats = Lens<ProjectStatsEnvelope, ProjectStatsEnvelope.VideoStats?>(
      view: { $0.videoStats },
      set: { ProjectStatsEnvelope(cumulative: $1.cumulative, fundingDistribution: $1.fundingDistribution,
        referrerStats: $1.referrerStats, rewardStats: $1.rewardStats,
        videoStats: $0) }
    )
  }
}
