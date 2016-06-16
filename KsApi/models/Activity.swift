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
    case backing          = "backing"
    case backingAmount    = "backing-amount"
    case backingCanceled  = "backing-canceled"
    case backingDropped   = "backing-dropped"
    case backingReward    = "backing-reward"
    case cancellation     = "cancellation"
    case commentPost      = "comment-post"
    case commentProject   = "comment-project"
    case failure          = "failure"
    case follow           = "follow"
    case funding          = "funding"
    case launch           = "launch"
    case success          = "success"
    case suspension       = "suspension"
    case update           = "update"
    case watch            = "watch"
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
