// swiftlint:disable type_name
import Prelude

extension Item {
  public enum lens {
    public static let amount = Lens<Item, Float>(
      view: { $0.amount },
      set: { .init(amount: $0, description: $1.description, id: $1.id, name: $1.name,
        projectId: $1.projectId, taxable: $1.taxable) }
    )

    public static let description = Lens<Item, String?>(
      view: { $0.description },
      set: { .init(amount: $1.amount, description: $0, id: $1.id, name: $1.name,
        projectId: $1.projectId, taxable: $1.taxable) }
    )

    public static let id = Lens<Item, Int>(
      view: { $0.id },
      set: { .init(amount: $1.amount, description: $1.description, id: $0, name: $1.name,
        projectId: $1.projectId, taxable: $1.taxable) }
    )

    public static let name = Lens<Item, String>(
      view: { $0.name },
      set: { .init(amount: $1.amount, description: $1.description, id: $1.id, name: $0,
        projectId: $1.projectId, taxable: $1.taxable) }
    )

    public static let projectId = Lens<Item, Int>(
      view: { $0.projectId },
      set: { .init(amount: $1.amount, description: $1.description, id: $1.id, name: $1.name,
        projectId: $0, taxable: $1.taxable) }
    )

    public static let taxable = Lens<Item, Bool?>(
      view: { $0.taxable },
      set: { .init(amount: $1.amount, description: $1.description, id: $1.id, name: $1.name,
        projectId: $1.projectId, taxable: $0) }
    )
  }
}
