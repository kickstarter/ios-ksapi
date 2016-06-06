import Prelude

/**
 A list of possible requests that can be made for Kickstarter data.
 */
public enum Route {
  case Activities(categories: [Activity.Category])
  case Backing(projectId: Int, backerId: Int)
  case Categories
  case Category(Int)
  case Config
  case Discover(DiscoveryParams)
  case FacebookLogin(facebookAccessToken: String, code: String?)
  case FacebookSignup(facebookAccessToken: String, sendNewsletters: Bool)
  case Login(email: String, password: String, code: String?)
  case MarkAsRead(MessageThread)
  case MessagesForThread(MessageThread)
  case MessagesForBacking(KsApi.Backing)
  case MessageThreads(mailbox: Mailbox, project: KsApi.Project?)
  case Project(Int)
  case ProjectComments(KsApi.Project)
  case PostProjectComment(KsApi.Project, body: String)
  case PostUpdateComment(Update, body: String)
  case ResetPassword(email: String)
  case SearchMessages(query: String, project: KsApi.Project?)
  case SendMessage(body: String, messageThread: MessageThread)
  case Signup(name: String, email: String, password: String, passwordConfirmation: String,
    sendNewsletters: Bool)
  case Star(KsApi.Project)
  case ToggleStar(KsApi.Project)
  case UpdateComments(Update)
  case UserSelf
  case User(KsApi.User)
  case UpdateUserSelf(KsApi.User)

  internal var requestProperties: (method: KsApi.Method, path: String, query: [String:AnyObject]) {
    switch self {
    case let .Activities(categories):
      return (.GET, "/v1/activities", ["categories": categories.map { $0.rawValue }])

    case let Backing(projectId, backerId):
      return (.GET, "/v1/projects/\(projectId)/backers/\(backerId)", [:])

    case .Categories:
      return (.GET, "/v1/categories", [:])

    case let .Category(id):
      return (.GET, "/v1/categories/\(id)", [:])

    case .Config:
      return (.GET, "/v1/app/ios/config", [:])

    case let .Discover(params):
      return (.GET, "/v1/discover", params.queryParams)

    case let .FacebookLogin(facebookAccessToken, code):
      var params = ["access_token": facebookAccessToken, "intent": "login"]
      params["code"] = code
      return (.PUT, "/v1/facebook/access_token", params)

    case let .FacebookSignup(facebookAccessToken, sendNewsletters):
      let params: [String:AnyObject] = ["access_token": facebookAccessToken,
                                        "intent": "register",
                                        "send_newsletters": sendNewsletters,
                                        "newsletter_opt_in": sendNewsletters]
      return (.PUT, "/v1/facebook/access_token", params)

    case let .Login(email, password, code):
      var params = ["email": email, "password": password]
      params["code"] = code
      return (.POST, "/xauth/access_token", params)

    case let .MarkAsRead(messageThread):
      return (.PUT, "/v1/message_threads/\(messageThread.id)/read", [:])

    case let .MessagesForThread(messageThread):
      return (.GET, "/v1/message_threads/\(messageThread.id)/messages", [:])

    case let .MessagesForBacking(backing):
      return (.GET, "/v1/projects/\(backing.projectId)/backers/\(backing.backerId)/messages", [:])

    case let .MessageThreads(mailbox, project):
      if let project = project {
        return (.GET, "/v1/projects/\(project.id)/message_threads/\(mailbox.rawValue)", [:])
      }
      return (.GET, "/v1/message_threads/\(mailbox.rawValue)", [:])

    case let .Project(id):
      return (.GET, "/v1/projects/\(id)", [:])

    case let .ProjectComments(p):
      return (.GET, "/v1/projects/\(p.id)/comments", [:])

    case let .PostProjectComment(p, body):
      return (.POST, "/v1/projects/\(p.id)/comments", ["body": body])

    case let .PostUpdateComment(u, body):
      return (.POST, "/v1/projects/\(u.projectId)/updates/\(u.id)/comments", ["body": body])

    case let .ResetPassword(email):
      return (.POST, "/v1/users/reset", ["email": email])

    case let .SearchMessages(query, project):
      if let project = project {
        return (.GET, "/v1/projects/\(project.id)/message_threads/search", ["q": query])
      }
      return (.GET, "/v1/message_threads/search", ["q": query])

    case let .SendMessage(body, messageThread):
      return (.POST, "/v1/message_threads/\(messageThread.id)/messages", ["body": body])

    case let .Signup(name, email, password, passwordConfirmation, sendNewsletters):
      let params: [String:AnyObject] = ["name": name,
                                        "email": email,
                                        "newsletter_opt_in": sendNewsletters,
                                        "password": password,
                                        "password_confirmation": passwordConfirmation,
                                        "send_newsletters": sendNewsletters]
      return (.POST, "/v1/users", params)

    case let .Star(p):
      return (.PUT, "/v1/projects/\(p.id)/star", [:])

    case let .ToggleStar(p):
      return (.POST, "/v1/projects/\(p.id)/star/toggle", [:])

    case let UpdateComments(u):
      return (.GET, "/v1/projects/\(u.projectId)/updates/\(u.id)/comments", [:])

    case .UserSelf:
      return (.GET, "/v1/users/self", [:])

    case let .User(user):
      return (.GET, "/v1/users/\(user.id)", [:])

    case let .UpdateUserSelf(user):
      let params = user.notifications.encode().withAllValuesFrom(user.newsletters.encode())
      return (.PUT, "v1/users/self", params)
    }
  }
}
