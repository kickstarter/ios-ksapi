// swiftlint:disable type_name
import Prelude

extension Location {
  public enum lens {
    public static let displayableName = Lens<Location, String>(
      view: { $0.displayableName },
      set: { Location(displayableName: $0, id: $1.id, name: $1.name) }
    )

    public static let id = Lens<Location, Int>(
      view: { $0.id },
      set: { Location(displayableName: $1.displayableName, id: $0, name: $1.name) }
    )

    public static let name = Lens<Location, String>(
      view: { $0.name },
      set: { Location(displayableName: $1.displayableName, id: $1.id, name: $0) }
    )
  }
}
