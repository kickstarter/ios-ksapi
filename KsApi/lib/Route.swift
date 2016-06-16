import Prelude

/**
 A list of possible requests that can be made for Kickstarter data.
 */
public enum Route {
  case activities(categories: [Activity.Category])
  case backing(projectId: Int, backerId: Int)
  case categories
  case category(Int)
  case config
  case discover(DiscoveryParams)
  case facebookConnect(facebookAccessToken: String)
  case facebookLogin(facebookAccessToken: String, code: String?)
  case facebookSignup(facebookAccessToken: String, sendNewsletters: Bool)
  case friends
  case friendStats
  case followAllFriends
  case followFriend(userId: Int)
  case login(email: String, password: String, code: String?)
  case markAsRead(MessageThread)
  case messagesForThread(MessageThread)
  case messagesForBacking(Backing)
  case messageThreads(mailbox: Mailbox, project: Project?)
  case project(Int)
  case projectComments(Project)
  case projectNotifications
  case projects(member: Bool)
  case postProjectComment(Project, body: String)
  case postUpdateComment(Update, body: String)
  case resetPassword(email: String)
  case searchMessages(query: String, project: Project?)
  case sendMessage(body: String, messageThread: MessageThread)
  case signup(name: String, email: String, password: String, passwordConfirmation: String,
    sendNewsletters: Bool)
  case star(Project)
  case toggleStar(Project)
  case unfollowFriend(userId: Int)
  case updateComments(Update)
  case userSelf
  case user(User)
  case updateProjectNotification(notification: ProjectNotification)
  case updateUserSelf(User)

  internal var requestProperties: (method: Method, path: String, query: [String:AnyObject]) {
    switch self {
    case let .activities(categories):
      return (.GET, "/v1/activities", ["categories": categories.map { $0.rawValue }])

    case let .backing(projectId, backerId):
      return (.GET, "/v1/projects/\(projectId)/backers/\(backerId)", [:])

    case .categories:
      return (.GET, "/v1/categories", [:])

    case let .category(id):
      return (.GET, "/v1/categories/\(id)", [:])

    case .config:
      return (.GET, "/v1/app/ios/config", [:])

    case let .discover(params):
      return (.GET, "/v1/discover", params.queryParams)

    case let .facebookConnect(token):
      return (.PUT, "v1/facebook/connect", ["access_token": token])

    case let .facebookLogin(facebookAccessToken, code):
      var params = ["access_token": facebookAccessToken, "intent": "login"]
      params["code"] = code
      return (.PUT, "/v1/facebook/access_token", params)

    case let .facebookSignup(facebookAccessToken, sendNewsletters):
      let params: [String:AnyObject] = ["access_token": facebookAccessToken,
                                        "intent": "register",
                                        "send_newsletters": sendNewsletters,
                                        "newsletter_opt_in": sendNewsletters]
      return (.PUT, "/v1/facebook/access_token", params)

    case .friends:
      return (.GET, "v1/users/self/friends/find", [:])

    case .friendStats:
      return (.GET, "v1/users/self/friends/find", ["count": 0])

    case .followAllFriends:
      return (.PUT, "v1/users/self/friends/follow_all", [:])

    case let .followFriend(userId):
      return (.POST, "v1/users/self/friends", ["followed_id": userId])

    case let .login(email, password, code):
      var params = ["email": email, "password": password]
      params["code"] = code
      return (.POST, "/xauth/access_token", params)

    case let .markAsRead(messageThread):
      return (.PUT, "/v1/message_threads/\(messageThread.id)/read", [:])

    case let .messagesForThread(messageThread):
      return (.GET, "/v1/message_threads/\(messageThread.id)/messages", [:])

    case let .messagesForBacking(backing):
      return (.GET, "/v1/projects/\(backing.projectId)/backers/\(backing.backerId)/messages", [:])

    case let .messageThreads(mailbox, project):
      if let project = project {
        return (.GET, "/v1/projects/\(project.id)/message_threads/\(mailbox.rawValue)", [:])
      }
      return (.GET, "/v1/message_threads/\(mailbox.rawValue)", [:])

    case let .project(id):
      return (.GET, "/v1/projects/\(id)", [:])

    case let .projectComments(p):
      return (.GET, "/v1/projects/\(p.id)/comments", [:])

    case .projectNotifications:
      return (.GET, "/v1/users/self/notifications", [:])

    case let .projects(member):
      return (.GET, "/v1/users/self/projects", ["member": member])

    case let .postProjectComment(p, body):
      return (.POST, "/v1/projects/\(p.id)/comments", ["body": body])

    case let .postUpdateComment(u, body):
      return (.POST, "/v1/projects/\(u.projectId)/updates/\(u.id)/comments", ["body": body])

    case let .resetPassword(email):
      return (.POST, "/v1/users/reset", ["email": email])

    case let .searchMessages(query, project):
      if let project = project {
        return (.GET, "/v1/projects/\(project.id)/message_threads/search", ["q": query])
      }
      return (.GET, "/v1/message_threads/search", ["q": query])

    case let .sendMessage(body, messageThread):
      return (.POST, "/v1/message_threads/\(messageThread.id)/messages", ["body": body])

    case let .signup(name, email, password, passwordConfirmation, sendNewsletters):
      let params: [String:AnyObject] = ["name": name,
                                        "email": email,
                                        "newsletter_opt_in": sendNewsletters,
                                        "password": password,
                                        "password_confirmation": passwordConfirmation,
                                        "send_newsletters": sendNewsletters]
      return (.POST, "/v1/users", params)

    case let .star(p):
      return (.PUT, "/v1/projects/\(p.id)/star", [:])

    case let .toggleStar(p):
      return (.POST, "/v1/projects/\(p.id)/star/toggle", [:])

    case let .unfollowFriend(userId):
      return (.DELETE, "v1/users/self/friends/\(userId)", [:])

    case let .updateComments(u):
      return (.GET, "/v1/projects/\(u.projectId)/updates/\(u.id)/comments", [:])

    case .userSelf:
      return (.GET, "/v1/users/self", [:])

    case let .user(user):
      return (.GET, "/v1/users/\(user.id)", [:])

    case let .updateProjectNotification(notification):
      let params = ["email": notification.email, "mobile": notification.mobile]
      return (.PUT, "/v1/users/self/notifications/\(notification.id)", params)

    case let .updateUserSelf(user):
      let params = user.notifications.encode().withAllValuesFrom(user.newsletters.encode())
      return (.PUT, "v1/users/self", params)
    }
  }
}
