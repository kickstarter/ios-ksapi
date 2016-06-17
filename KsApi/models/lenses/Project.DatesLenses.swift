// swiftlint:disable type_name
import Prelude

extension Project.Dates {
  public enum lens {
    public static let deadline = Lens<Project.Dates, NSTimeInterval>(
      view: { $0.deadline },
      set: { Project.Dates(deadline: $0, launchedAt: $1.launchedAt, potdAt: $1.potdAt,
        stateChangedAt: $1.stateChangedAt) }
    )

    public static let launchedAt = Lens<Project.Dates, NSTimeInterval>(
      view: { $0.launchedAt },
      set: { Project.Dates(deadline: $1.deadline, launchedAt: $0, potdAt: $1.potdAt,
        stateChangedAt: $1.stateChangedAt) }
    )

    public static let potdAt = Lens<Project.Dates, NSTimeInterval?>(
      view: { $0.potdAt },
      set: { Project.Dates(deadline: $1.deadline, launchedAt: $1.launchedAt, potdAt: $0,
        stateChangedAt: $1.stateChangedAt) }
    )

    public static let stateChangedAt = Lens<Project.Dates, NSTimeInterval>(
      view: { $0.stateChangedAt },
      set: { Project.Dates(deadline: $1.deadline, launchedAt: $1.launchedAt, potdAt: $1.potdAt,
        stateChangedAt: $0) }
    )
  }
}
