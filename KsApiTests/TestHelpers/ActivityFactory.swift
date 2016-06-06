@testable import KsApi

extension Activity {

  internal static let template = Activity(
    category: .Update,
    createdAt: NSDate().timeIntervalSince1970,
    id: 1,
    project: Project.template,
    update: nil,
    user: User.template
  )
}
