import struct Models.Activity
import struct Models.Category
import struct Models.Project
import struct Models.User

/**
 A list of possible requests that can be made for Kickstarter data.
*/
public enum Route {
  case Activities(categories: [Activity.Category])
  case Discover(DiscoveryParams)
  case Project(Models.Project)
  case UserSelf
  case User(Models.User)
  case Categories
  case Category(Models.Category)
  case ToggleStar(Models.Project)
  case Star(Models.Project)
  case Login(email: String, password: String)

  internal var requestProperties: (method: KsApi.Method, path: String, query: [String:AnyObject]) {
    switch self {
    case let .Activities(categories):
      return (.GET, "/v1/activities", ["categories": categories.map { $0.rawValue }])
    case let .Discover(params):
      return (.GET, "/v1/discover", params.queryParams)
    case let .Project(p):
      return (.GET, "/v1/projects/\(p.id)", [:])
    case .UserSelf:
      return (.GET, "/v1/users/self", [:])
    case let .User(user):
      return (.GET, "/v1/users/\(user.id)", [:])
    case .Categories:
      return (.GET, "/v1/categories", [:])
    case let .Category(c):
      return (.GET, "/v1/categories/\(c.id)", [:])
    case let .ToggleStar(p):
      return (.POST, "/v1/projects/\(p.id)/star/toggle", [:])
    case let .Star(p):
      return (.PUT, "/v1/projects/\(p.id)/star", [:])
    case let .Login(email, password):
      return (.POST, "/xauth/access_token", ["email": email, "password": password])
    }
  }
}
