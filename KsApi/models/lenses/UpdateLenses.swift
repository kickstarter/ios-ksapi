// swiftlint:disable type_name
import Prelude

extension Update {
  public enum lens {
    public static let id = Lens<Update, Int>(
      view: { $0.id },
      set: { Update(body: $1.body, commentsCount: $1.commentsCount, hasLiked: $1.hasLiked, id: $0,
        isPublic: $1.isPublic, likesCount: $1.likesCount, projectId: $1.projectId,
        publishedAt: $1.publishedAt, sequence: $1.sequence, title: $1.title, urls: $1.urls, user: $1.user,
        visible: $1.visible) }
    )
  }
}
