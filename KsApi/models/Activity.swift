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
    case Backing          = "backing"
    case BackingAmount    = "backing_amount"
    case BackingCanceled  = "backing_canceled"
    case BackingDropped   = "backing_dropped"
    case BackingProposal  = "backing_proposal"
    case BackingReward    = "backing_reward"
    case Cancellation     = "cancellation"
    case CommentPost      = "comment_post"
    case CommentProject   = "comment_project"
    case Failure          = "failure"
    case Follow           = "follow"
    case Funding          = "funding"
    case Launch           = "launch"
    case Success          = "success"
    case Suspension       = "suspension"
    case Update           = "update"
    case Watch            = "watch"
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
