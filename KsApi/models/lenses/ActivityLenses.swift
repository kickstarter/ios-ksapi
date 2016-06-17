// swiftlint:disable type_name
import Prelude

extension Activity {
  public enum lens {
    public static let category = Lens<Activity, Activity.Category>(
      view: { $0.category },
      set: { Activity(category: $0, createdAt: $1.createdAt, id: $1.id, project: $1.project,
        update: $1.update, user: $1.user) }
    )

    public static let id = Lens<Activity, Int>(
      view: { $0.id },
      set: { Activity(category: $1.category, createdAt: $1.createdAt, id: $0, project: $1.project,
        update: $1.update, user: $1.user) }
    )

    public static let project = Lens<Activity, Project?>(
      view: { $0.project },
      set: { Activity(category: $1.category, createdAt: $1.createdAt, id: $1.id, project: $0,
        update: $1.update, user: $1.user) }
    )

    public static let update = Lens<Activity, Update?>(
      view: { $0.update },
      set: { Activity(category: $1.category, createdAt: $1.createdAt, id: $1.id, project: $1.project,
        update: $0, user: $1.user) }
    )

    public static let user = Lens<Activity, User?>(
      view: { $0.user },
      set: { Activity(category: $1.category, createdAt: $1.createdAt, id: $1.id, project: $1.project,
        update: $1.update, user: $0) }
    )
  }
}
