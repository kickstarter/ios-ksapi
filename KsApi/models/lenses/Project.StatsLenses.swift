// swiftlint:disable type_name
import Prelude

extension Project.Stats {
  public enum lens {
    public static let backersCount = Lens<Project.Stats, Int>(
      view: { $0.backersCount },
      set: { Project.Stats(backersCount: $0, commentsCount: $1.commentsCount, goal: $1.goal,
        pledged: $1.pledged, updatesCount: $1.updatesCount) }
    )

    public static let commentsCount = Lens<Project.Stats, Int?>(
      view: { $0.commentsCount },
      set: { Project.Stats(backersCount: $1.backersCount, commentsCount: $0, goal: $1.goal,
        pledged: $1.pledged, updatesCount: $1.updatesCount) }
    )

    public static let goal = Lens<Project.Stats, Int>(
      view: { $0.goal },
      set: { Project.Stats(backersCount: $1.backersCount, commentsCount: $1.commentsCount, goal: $0,
        pledged: $1.pledged, updatesCount: $1.updatesCount) }
    )

    public static let pledged = Lens<Project.Stats, Int>(
      view: { $0.pledged },
      set: { Project.Stats(backersCount: $1.backersCount, commentsCount: $1.commentsCount, goal: $1.goal,
        pledged: $0, updatesCount: $1.updatesCount) }
    )

    public static let updatesCount = Lens<Project.Stats, Int?>(
      view: { $0.updatesCount },
      set: { Project.Stats(backersCount: $1.backersCount, commentsCount: $1.commentsCount, goal: $1.goal,
        pledged: $1.pledged, updatesCount: $0) }
    )

    public static let fundingProgress = Lens<Project.Stats, Float>(
      view: { $0.fundingProgress },
      set: { Project.Stats(backersCount: $1.backersCount, commentsCount: $1.commentsCount, goal: $1.goal,
        pledged: Int($0 * Float($1.goal)), updatesCount: $1.updatesCount) }
    )
  }
}
