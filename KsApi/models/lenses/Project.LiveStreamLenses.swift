// swiftlint:disable type_name
import Prelude

extension Project.LiveStream {
  public enum lens {
    public static let id = Lens<Project.LiveStream, String>(
      view: { $0.id },
      set: { .init(id: $0, isLiveNow: $1.isLiveNow, name: $1.name, startDate: $1.startDate, url: $1.url) }
    )

    public static let isLiveNow = Lens<Project.LiveStream, Bool>(
      view: { $0.isLiveNow },
      set: { .init(id: $1.id, isLiveNow: $0, name: $1.name, startDate: $1.startDate, url: $1.url) }
    )

    public static let name = Lens<Project.LiveStream, String>(
      view: { $0.name },
      set: { .init(id: $1.id, isLiveNow: $1.isLiveNow, name: $0, startDate: $1.startDate, url: $1.url) }
    )

    public static let startDate = Lens<Project.LiveStream, TimeInterval>(
      view: { $0.startDate },
      set: { .init(id: $1.id, isLiveNow: $1.isLiveNow, name: $1.name, startDate: $0, url: $1.url) }
    )

    public static let url = Lens<Project.LiveStream, String>(
      view: { $0.url },
      set: { .init(id: $1.id, isLiveNow: $1.isLiveNow, name: $1.name, startDate: $1.startDate, url: $0) }
    )
  }
}
