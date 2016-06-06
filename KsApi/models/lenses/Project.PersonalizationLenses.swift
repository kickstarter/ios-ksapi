// swiftlint:disable type_name
import Prelude

extension Project.Personalization {
  public enum lens {
    public static let backing = Lens<Project.Personalization, Backing?>(
      view: { $0.backing },
      set: { Project.Personalization(backing: $0, isBacking: $1.isBacking, isStarred: $1.isStarred) }
    )

    public static let isBacking = Lens<Project.Personalization, Bool?>(
      view: { $0.isBacking },
      set: { Project.Personalization(backing: $1.backing, isBacking: $0, isStarred: $1.isStarred) }
    )

    public static let isStarred = Lens<Project.Personalization, Bool?>(
      view: { $0.isStarred },
      set: { Project.Personalization(backing: $1.backing, isBacking: $1.isBacking, isStarred: $0) }
    )
  }
}
