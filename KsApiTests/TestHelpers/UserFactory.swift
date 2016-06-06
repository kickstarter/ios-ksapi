@testable import KsApi

extension User {
  internal static let template = User(
    avatar: User.Avatar.template,
    id: 1,
    name: "Blob",
    newsletters: User.NewsletterSubscriptions.template,
    notifications: User.Notifications.template,
    stats: User.Stats.template
  )
}
