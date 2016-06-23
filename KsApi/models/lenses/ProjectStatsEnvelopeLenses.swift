// swiftlint:disable type_name
import Prelude

extension ProjectStatsEnvelope {
  public enum lens {
    public static let videoStats = Lens<ProjectStatsEnvelope, ProjectStatsEnvelope.VideoStats?>(
      view: { $0.videoStats },
      set: { ProjectStatsEnvelope(cumulative: $1.cumulative, fundingDistribution: $1.fundingDistribution,
        referralDistribution: $1.referralDistribution, rewardDistribution: $1.rewardDistribution,
        videoStats: $0) }
    )
  }
}
