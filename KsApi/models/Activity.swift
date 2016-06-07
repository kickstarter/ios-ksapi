import Foundation
import Argo
import Curry

public struct Activity {
  public let category: Activity.Category
  public let createdAt: NSTimeInterval
  public let id: Int
  public let project: Project?
  public let update: Update?
  public let user: User?

  public enum Category: String {
    // swiftlint:disable type_name
    case backing          = "backing"
    case backingAmount    = "backing_amount"
    case backingCanceled  = "backing_canceled"
    case backingDropped   = "backing_dropped"
    case backingProposal  = "backing_proposal"
    case backingReward    = "backing_reward"
    case cancellation     = "cancellation"
    case commentPost      = "comment_post"
    case commentProject   = "comment_project"
    case failure          = "failure"
    case follow           = "follow"
    case funding          = "funding"
    case launch           = "launch"
    case success          = "success"
    case suspension       = "suspension"
    case update           = "update"
    case watch            = "watch"
    // swiftlint:enable type_name
  }
}

extension Activity: Equatable {
}
public func == (lhs: Activity, rhs: Activity) -> Bool {
  return lhs.id == rhs.id
}

extension Activity.Category: Decodable {
}

extension Activity: Decodable {
  public static func decode(json: JSON) -> Decoded<Activity> {
    let create = curry(Activity.init)
    return create
      <^> json <|  "category"
      <*> json <|  "created_at"
      <*> json <|  "id"
      <*> json <|? "project"
      <*> json <|? "update"
      <*> json <|? "user"
  }
}
