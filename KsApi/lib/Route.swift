import Prelude

/**
 A list of possible requests that can be made for Kickstarter data.
 */
internal enum Route {
  case activities(categories: [Activity.Category], count: Int?)
  case addImage(fileUrl: NSURL, toDraft: UpdateDraft)
  case addVideo(fileUrl: NSURL, toDraft: UpdateDraft)
  case backing(projectId: Int, backerId: Int)
  case categories
  case category(Param)
  case checkout(String)
  case config
  case deleteImage(UpdateDraft.Image, fromDraft: UpdateDraft)
  case deleteVideo(UpdateDraft.Video, fromDraft: UpdateDraft)
  case discover(DiscoveryParams)
  case facebookConnect(facebookAccessToken: String)
  case facebookLogin(facebookAccessToken: String, code: String?)
  case facebookSignup(facebookAccessToken: String, sendNewsletters: Bool)
  case fetchUpdateDraft(forProject: Project)
  case friends
  case friendStats
  case followAllFriends
  case followFriend(userId: Int)
  case incrementVideoCompletion(project: Project)
  case incrementVideoStart(project: Project)
  case login(email: String, password: String, code: String?)
  case markAsRead(MessageThread)
  case messagesForThread(MessageThread)
  case messagesForBacking(Backing)
  case messageThreads(mailbox: Mailbox, project: Project?)
  case postProjectComment(Project, body: String)
  case postUpdateComment(Update, body: String)
  case project(Param)
  case projectActivities(Project)
  case projectComments(Project)
  case projectNotifications
  case projects(member: Bool)
  case projectStats(projectId: Int)
  case publishUpdateDraft(UpdateDraft)
  case registerPushToken(String)
  case resetPassword(email: String)
  case searchMessages(query: String, project: Project?)
  case sendMessage(body: String, messageSubject: MessageSubject)
  case signup(name: String, email: String, password: String, passwordConfirmation: String,
    sendNewsletters: Bool)
  case star(Project)
  case toggleStar(Project)
  case unansweredSurveyResponses
  case unfollowFriend(userId: Int)
  case update(updateId: Int, projectParam: Param)
  case updateComments(Update)
  case updateProjectNotification(notification: ProjectNotification)
  case updateUpdateDraft(UpdateDraft, title: String, body: String, isPublic: Bool)
  case updateUserSelf(User)
  case userSelf
  case user(userId: Int)

  enum UploadParam: String {
    case image
    case video
  }

  internal var requestProperties:
    (method: Method, path: String, query: [String:AnyObject], file: (name: UploadParam, url: NSURL)?) {

    switch self {
    case let .activities(categories, count):
      var params: [String:AnyObject] = ["categories": categories.map { $0.rawValue }]
      params["count"] = count
      return (.GET, "/v1/activities", params, nil)

    case let .addImage(file, draft):
      return (.POST, "/v1/projects/\(draft.update.projectId)/updates/draft/images", [:], (.image, file))

    case let .addVideo(file, draft):
      return (.POST, "/v1/projects/\(draft.update.projectId)/updates/draft/video", [:], (.video, file))

    case let .backing(projectId, backerId):
      return (.GET, "/v1/projects/\(projectId)/backers/\(backerId)", [:], nil)

    case .categories:
      return (.GET, "/v1/categories", [:], nil)

    case let .category(param):
      return (.GET, "/v1/categories/\(param.urlComponent)", [:], nil)

    case let .checkout(url):
      return (.GET, url, [:], nil)

    case .config:
      return (.GET, "/v1/app/ios/config", [:], nil)

    case let .deleteImage(i, draft):
      return (.DELETE, "/v1/projects/\(draft.update.projectId)/updates/draft/images/\(i.id)", [:], nil)

    case let .deleteVideo(v, draft):
      return (.DELETE, "/v1/projects/\(draft.update.projectId)/updates/draft/video/\(v.id)", [:], nil)

    case let .discover(params):
      return (.GET, "/v1/discover", params.queryParams, nil)

    case let .facebookConnect(token):
      return (.PUT, "v1/facebook/connect", ["access_token": token], nil)

    case let .facebookLogin(facebookAccessToken, code):
      var params = ["access_token": facebookAccessToken, "intent": "login"]
      params["code"] = code
      return (.PUT, "/v1/facebook/access_token", params, nil)

    case let .facebookSignup(facebookAccessToken, sendNewsletters):
      let params: [String:AnyObject] = ["access_token": facebookAccessToken,
                                        "intent": "register",
                                        "send_newsletters": sendNewsletters,
                                        "newsletter_opt_in": sendNewsletters]
      return (.PUT, "/v1/facebook/access_token", params, nil)

    case let .fetchUpdateDraft(project):
      return (.GET, "/v1/projects/\(project.id)/updates/draft", [:], nil)

    case .friends:
      return (.GET, "v1/users/self/friends/find", [:], nil)

    case .friendStats:
      return (.GET, "v1/users/self/friends/find", ["count": 0], nil)

    case .followAllFriends:
      return (.PUT, "v1/users/self/friends/follow_all", [:], nil)

    case let .followFriend(userId):
      return (.POST, "v1/users/self/friends", ["followed_id": userId], nil)

    case let .incrementVideoCompletion(project):
      let statsURL = NSURL(string: project.urls.web.project)?
        .URLByAppendingPathComponent("video/plays")
        .absoluteString
      return (.POST, statsURL ?? "", ["event_type": "complete", "location": "internal"], nil)

    case let .incrementVideoStart(project):
      let statsURL = NSURL(string: project.urls.web.project)?
        .URLByAppendingPathComponent("video/plays")
        .absoluteString
      return (.POST, statsURL ?? "", ["event_type": "start", "location": "internal"], nil)

    case let .login(email, password, code):
      var params = ["email": email, "password": password]
      params["code"] = code
      return (.POST, "/xauth/access_token", params, nil)

    case let .markAsRead(messageThread):
      return (.PUT, "/v1/message_threads/\(messageThread.id)/read", [:], nil)

    case let .messagesForThread(messageThread):
      return (.GET, "/v1/message_threads/\(messageThread.id)/messages", [:], nil)

    case let .messagesForBacking(backing):
      return (.GET, "/v1/projects/\(backing.projectId)/backers/\(backing.backerId)/messages", [:], nil)

    case let .messageThreads(mailbox, project):
      if let project = project {
        return (.GET, "/v1/projects/\(project.id)/message_threads/\(mailbox.rawValue)", [:], nil)
      }
      return (.GET, "/v1/message_threads/\(mailbox.rawValue)", [:], nil)

    case let .postProjectComment(p, body):
      return (.POST, "/v1/projects/\(p.id)/comments", ["body": body], nil)

    case let .postUpdateComment(u, body):
      return (.POST, "/v1/projects/\(u.projectId)/updates/\(u.id)/comments", ["body": body], nil)

    case let .project(param):
      return (.GET, "/v1/projects/\(param.urlComponent)", [:], nil)

    case let .projectActivities(project):
      return (.GET, "/v1/projects/\(project.id)/activities", [:], nil)

    case let .projectComments(p):
      return (.GET, "/v1/projects/\(p.id)/comments", [:], nil)

    case .projectNotifications:
      return (.GET, "/v1/users/self/notifications", [:], nil)

    case let .projects(member):
      return (.GET, "/v1/users/self/projects", ["member": member], nil)

    case let .projectStats(projectId):
      return (.GET, "/v1/projects/\(projectId)/stats", [:], nil)

    case let .publishUpdateDraft(d):
      return (.POST, "/v1/projects/\(d.update.projectId)/updates/draft/publish", [:], nil)

    case let .registerPushToken(token):
      return (.POST, "v1/users/self/ios/push_tokens", ["token": token], nil)

    case let .resetPassword(email):
      return (.POST, "/v1/users/reset", ["email": email], nil)

    case let .searchMessages(query, project):
      if let project = project {
        return (.GET, "/v1/projects/\(project.id)/message_threads/search", ["q": query], nil)
      }
      return (.GET, "/v1/message_threads/search", ["q": query], nil)

    case let .sendMessage(body, messageSubject):
      switch messageSubject {
      case let .backing(backing):
        return (.POST,
                "v1/projects/\(backing.projectId)/backers/\(backing.backerId)/messages",
                ["body": body],
                nil)

      case let .messageThread(messageThread):
        return (.POST, "/v1/message_threads/\(messageThread.id)/messages", ["body": body], nil)

      case let .project(project):
        return (.POST, "v1/projects/\(project.id)/messages", ["body": body], nil)
      }

    case let .signup(name, email, password, passwordConfirmation, sendNewsletters):
      let params: [String:AnyObject] = ["name": name,
                                        "email": email,
                                        "newsletter_opt_in": sendNewsletters,
                                        "password": password,
                                        "password_confirmation": passwordConfirmation,
                                        "send_newsletters": sendNewsletters]
      return (.POST, "/v1/users", params, nil)

    case let .star(p):
      return (.PUT, "/v1/projects/\(p.id)/star", [:], nil)

    case let .toggleStar(p):
      return (.POST, "/v1/projects/\(p.id)/star/toggle", [:], nil)

    case .unansweredSurveyResponses:
      return (.GET, "/v1/users/self/surveys/unanswered", [:], nil)

    case let .unfollowFriend(userId):
      return (.DELETE, "v1/users/self/friends/\(userId)", [:], nil)

    case let .update(id, projectParam):
      return (.GET, "v1/projects/\(projectParam.urlComponent)/updates/\(id)", [:], nil)

    case let .updateComments(u):
      return (.GET, "/v1/projects/\(u.projectId)/updates/\(u.id)/comments", [:], nil)

    case let .updateUpdateDraft(d, title, body, isPublic):
      let params: [String:AnyObject] = ["title": title, "body": body, "public": isPublic]
      return (.PUT, "/v1/projects/\(d.update.projectId)/updates/draft", params, nil)

    case let .updateProjectNotification(notification):
      let params = ["email": notification.email, "mobile": notification.mobile]
      return (.PUT, "/v1/users/self/notifications/\(notification.id)", params, nil)

    case let .updateUserSelf(user):
      let params = user.notifications.encode().withAllValuesFrom(user.newsletters.encode())
      return (.PUT, "/v1/users/self", params, nil)

    case .userSelf:
      return (.GET, "/v1/users/self", [:], nil)

    case let .user(userId):
      return (.GET, "/v1/users/\(userId)", [:], nil)

    }
  }
}
