// swiftlint:disable type_name
import Prelude

extension Reward {
  public enum lens {
    public static let backersCount = Lens<Reward, Int?>(
      view: { $0.backersCount },
      set: { Reward(backersCount: $0, description: $1.description,
        estimatedDeliveryOn: $1.estimatedDeliveryOn, id: $1.id, limit: $1.limit, minimum: $1.minimum,
        remaining: $1.remaining, shipping: $1.shipping) }
    )

    public static let description = Lens<Reward, String>(
      view: { $0.description },
      set: { Reward(backersCount: $1.backersCount, description: $0,
        estimatedDeliveryOn: $1.estimatedDeliveryOn, id: $1.id, limit: $1.limit, minimum: $1.minimum,
        remaining: $1.remaining, shipping: $1.shipping) }
    )

    public static let estimatedDeliveryOn = Lens<Reward, NSTimeInterval?>(
      view: { $0.estimatedDeliveryOn },
      set: { Reward(backersCount: $1.backersCount, description: $1.description,
        estimatedDeliveryOn: $0, id: $1.id, limit: $1.limit, minimum: $1.minimum,
        remaining: $1.remaining, shipping: $1.shipping) }
    )

    public static let id = Lens<Reward, Int>(
      view: { $0.id },
      set: { Reward(backersCount: $1.backersCount, description: $1.description,
        estimatedDeliveryOn: $1.estimatedDeliveryOn, id: $0, limit: $1.limit, minimum: $1.minimum,
        remaining: $1.remaining, shipping: $1.shipping) }
    )

    public static let limit = Lens<Reward, Int?>(
      view: { $0.limit },
      set: { Reward(backersCount: $1.backersCount, description: $1.description,
        estimatedDeliveryOn: $1.estimatedDeliveryOn, id: $1.id, limit: $0, minimum: $1.minimum,
        remaining: $1.remaining, shipping: $1.shipping) }
    )

    public static let minimum = Lens<Reward, Int>(
      view: { $0.minimum },
      set: { Reward(backersCount: $1.backersCount, description: $1.description,
        estimatedDeliveryOn: $1.estimatedDeliveryOn, id: $1.id, limit: $1.limit, minimum: $0,
        remaining: $1.remaining, shipping: $1.shipping) }
    )

    public static let remaining = Lens<Reward, Int?>(
      view: { $0.remaining },
      set: { Reward(backersCount: $1.backersCount, description: $1.description,
        estimatedDeliveryOn: $1.estimatedDeliveryOn, id: $1.id, limit: $1.limit, minimum: $1.minimum,
        remaining: $0, shipping: $1.shipping) }
    )

    public static let shipping = Lens<Reward, Reward.Shipping>(
      view: { $0.shipping },
      set: { Reward(backersCount: $1.backersCount, description: $1.description,
        estimatedDeliveryOn: $1.estimatedDeliveryOn, id: $1.id, limit: $1.limit, minimum: $1.minimum,
        remaining: $1.remaining, shipping: $0) }
    )
  }
}
