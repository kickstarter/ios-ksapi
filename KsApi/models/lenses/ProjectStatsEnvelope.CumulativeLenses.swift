// swiftlint:disable type_name
import Prelude

extension ProjectStatsEnvelope.Cumulative {
  public enum lens {

    public static let averagePledge = Lens<ProjectStatsEnvelope.Cumulative, Int>(
      view: { $0.averagePledge },
      set: { .init(averagePledge: $0, backersCount: $1.backersCount, goal: $1.goal,
        percentRaised: $1.percentRaised, pledged: $1.pledged) }
    )

    public static let backersCount = Lens<ProjectStatsEnvelope.Cumulative, Int>(
      view: { $0.backersCount },
      set: { .init(averagePledge: $1.averagePledge, backersCount: $0, goal: $1.goal,
        percentRaised: $1.percentRaised, pledged: $1.pledged) }
    )

    public static let goal = Lens<ProjectStatsEnvelope.Cumulative, Int>(
      view: { $0.goal },
      set: { .init(averagePledge: $1.averagePledge, backersCount: $1.backersCount, goal: $0,
        percentRaised: $1.percentRaised, pledged: $1.pledged) }
    )

    public static let percentRaised = Lens<ProjectStatsEnvelope.Cumulative, Double>(
      view: { $0.percentRaised },
      set: { .init(averagePledge: $1.averagePledge, backersCount: $1.backersCount, goal: $1.goal,
        percentRaised: $0, pledged: $1.pledged) }
    )

    public static let pledged = Lens<ProjectStatsEnvelope.Cumulative, Int>(
      view: { $0.pledged },
      set: { .init(averagePledge: $1.averagePledge, backersCount: $1.backersCount, goal: $1.goal,
        percentRaised: $1.percentRaised, pledged: $0) }
    )
  }
}
