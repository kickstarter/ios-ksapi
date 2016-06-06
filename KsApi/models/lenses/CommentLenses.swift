// swiftlint:disable type_name
import Prelude

extension Comment {
  public enum lens {
    public static let deletedAt = Lens<Comment, NSTimeInterval?>(
      view: { $0.deletedAt },
      set: { Comment(author: $1.author, body: $1.body, createdAt: $1.createdAt, deletedAt: $0, id: $1.id) }
    )

    public static let id = Lens<Comment, Int>(
      view: { $0.id },
      set: { Comment(author: $1.author, body: $1.body, createdAt: $1.createdAt, deletedAt: $1.deletedAt,
        id: $0) }
    )
  }
}
