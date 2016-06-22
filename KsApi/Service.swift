// swiftlint:disable file_length

import Argo
import Prelude
import ReactiveCocoa
import ReactiveExtensions

/**
 A `ServerType` that requests data from an API webservice.
*/
public struct Service: ServiceType {
  public let serverConfig: ServerConfigType
  public let oauthToken: OauthTokenAuthType?
  public let language: String
  public let buildVersion: String

  public init(serverConfig: ServerConfigType = ServerConfig.production,
              oauthToken: OauthTokenAuthType? = nil,
              language: String = "en",
              buildVersion: String = "1") {

    self.serverConfig = serverConfig
    self.oauthToken = oauthToken
    self.language = language
    self.buildVersion = buildVersion
  }

  public func login(oauthToken: OauthTokenAuthType) -> Service {
    return Service(serverConfig: self.serverConfig,
                   oauthToken: oauthToken,
                   language: self.language,
                   buildVersion: self.buildVersion)
  }

  public func logout() -> Service {
    return Service(serverConfig: self.serverConfig,
                   oauthToken: nil,
                   language: self.language,
                   buildVersion: self.buildVersion)
  }

  public func facebookConnect(facebookAccessToken token: String)
    -> SignalProducer<User, ErrorEnvelope> {
      return request(.facebookConnect(facebookAccessToken: token))
  }

  public func fetchActivities() -> SignalProducer<ActivityEnvelope, ErrorEnvelope> {
    let categories: [Activity.Category] = [
      .backing,
      .cancellation,
      .failure,
      .follow,
      .launch,
      .success,
      .update,
    ]
    return request(.activities(categories: categories))
  }

  public func fetchActivities(paginationUrl paginationUrl: String)
    -> SignalProducer<ActivityEnvelope, ErrorEnvelope> {
      return requestPagination(paginationUrl)
  }

  public func fetchBacking(forProject project: Project, forUser user: User)
    -> SignalProducer<Backing, ErrorEnvelope> {
      return request(.backing(projectId: project.id, backerId: user.id))
  }

  public func fetchComments(paginationUrl url: String) -> SignalProducer<CommentsEnvelope, ErrorEnvelope> {
    return requestPagination(url)
  }

  public func fetchComments(project project: Project) -> SignalProducer<CommentsEnvelope, ErrorEnvelope> {
    return request(.projectComments(project))
  }

  public func fetchComments(update update: Update) -> SignalProducer<CommentsEnvelope, ErrorEnvelope> {
    return request(.updateComments(update))
  }

  public func fetchConfig() -> SignalProducer<Config, ErrorEnvelope> {
    return request(.config)
  }

  public func fetchDiscovery(paginationUrl paginationUrl: String)
    -> SignalProducer<DiscoveryEnvelope, ErrorEnvelope> {

    return requestPagination(paginationUrl)
  }

  public func fetchDiscovery(params params: DiscoveryParams)
    -> SignalProducer<DiscoveryEnvelope, ErrorEnvelope> {

    return request(.discover(params))
  }

  public func fetchMessageThread(messageThread messageThread: MessageThread)
    -> SignalProducer<MessageThreadEnvelope, ErrorEnvelope> {

      return request(.messagesForThread(messageThread))
  }

  public func fetchMessageThread(backing backing: Backing)
    -> SignalProducer<MessageThreadEnvelope, ErrorEnvelope> {
    return request(.messagesForBacking(backing))
  }

  public func fetchMessageThreads(mailbox mailbox: Mailbox, project: Project?)
    -> SignalProducer<MessageThreadsEnvelope, ErrorEnvelope> {

      return request(.messageThreads(mailbox: mailbox, project: project))
  }

  public func fetchMessageThreads(paginationUrl paginationUrl: String)
    -> SignalProducer<MessageThreadsEnvelope, ErrorEnvelope> {

      return requestPagination(paginationUrl)
  }

  public func fetchProject(id id: Int) -> SignalProducer<Project, ErrorEnvelope> {
    return request(.project(id))
  }

  public func fetchProject(params: DiscoveryParams) -> SignalProducer<DiscoveryEnvelope, ErrorEnvelope> {
    return request(.discover(params |> DiscoveryParams.lens.perPage .~ 1))
  }

  public func fetchProject(project project: Project) -> SignalProducer<Project, ErrorEnvelope> {
    return request(.project(project.id))
  }

  public func fetchProjectNotifications() -> SignalProducer<[ProjectNotification], ErrorEnvelope> {
    return request(.projectNotifications)
  }

  public func fetchProjectActivities(forProject project: Project) ->
    SignalProducer<ProjectActivityEnvelope, ErrorEnvelope> {
      return request(.projectActivities(project))
  }

  public func fetchProjectActivities(paginationUrl paginationUrl: String)
    -> SignalProducer<ProjectActivityEnvelope, ErrorEnvelope> {
      return requestPagination(paginationUrl)
  }

  public func fetchProjects(member member: Bool) -> SignalProducer<ProjectsEnvelope, ErrorEnvelope> {
    return request(.projects(member: member))
  }

  public func fetchProjects(paginationUrl url: String) -> SignalProducer<ProjectsEnvelope, ErrorEnvelope> {
    return requestPagination(url)
  }

  public func fetchUserSelf() -> SignalProducer<User, ErrorEnvelope> {
    return request(.userSelf)
  }

  public func fetchUser(user: User) -> SignalProducer<User, ErrorEnvelope> {
    return request(.user(user))
  }

  public func fetchCategories() -> SignalProducer<CategoriesEnvelope, ErrorEnvelope> {
    return request(.categories)
  }

  public func fetchCategory(id id: Int) -> SignalProducer<Category, ErrorEnvelope> {
    return request(.category(id))
  }

  public func fetchFriends() -> SignalProducer<FindFriendsEnvelope, ErrorEnvelope> {
    return request(.friends)
  }

  public func fetchFriends(paginationUrl paginationUrl: String)
    -> SignalProducer<FindFriendsEnvelope, ErrorEnvelope> {
    return requestPagination(paginationUrl)
  }

  public func fetchFriendStats() -> SignalProducer<FriendStatsEnvelope, ErrorEnvelope> {
    return request(.friendStats)
  }

  public func fetchUnansweredSurveyResponses() -> SignalProducer<[SurveyResponse], ErrorEnvelope> {
    return request(.unansweredSurveyResponses)
  }

  public func followAllFriends() -> SignalProducer<VoidEnvelope, ErrorEnvelope> {
    return request(.followAllFriends)
  }

  public func followFriend(userId id: Int) -> SignalProducer<User, ErrorEnvelope> {
    return request(.followFriend(userId: id))
  }

  public func toggleStar(project: Project) -> SignalProducer<StarEnvelope, ErrorEnvelope> {
    return request(.toggleStar(project))
  }

  public func star(project: Project) -> SignalProducer<StarEnvelope, ErrorEnvelope> {
    return request(.star(project))
  }

  public func login(email email: String, password: String, code: String?) ->
    SignalProducer<AccessTokenEnvelope, ErrorEnvelope> {

    return request(.login(email: email, password: password, code: code))
  }

  public func login(facebookAccessToken facebookAccessToken: String, code: String?) ->
    SignalProducer<AccessTokenEnvelope, ErrorEnvelope> {

    return request(.facebookLogin(facebookAccessToken: facebookAccessToken, code: code))
  }

  public func markAsRead(messageThread messageThread: MessageThread)
    -> SignalProducer<MessageThread, ErrorEnvelope> {

      return request(.markAsRead(messageThread))
  }

  public func postComment(body: String, toProject project: Project) ->
    SignalProducer<Comment, ErrorEnvelope> {

      return request(.postProjectComment(project, body: body))
  }

  public func postComment(body: String, toUpdate update: Update) -> SignalProducer<Comment, ErrorEnvelope> {

      return request(.postUpdateComment(update, body: body))
  }

  public func resetPassword(email email: String) -> SignalProducer<User, ErrorEnvelope> {
    return request(.resetPassword(email: email))
  }

  public func searchMessages(query query: String, project: Project?)
    -> SignalProducer<MessageThreadsEnvelope, ErrorEnvelope> {

      return request(.searchMessages(query: query, project: project))
  }

  public func sendMessage(body body: String, toThread messageThread: MessageThread)
    -> SignalProducer<Message, ErrorEnvelope> {

      return request(.sendMessage(body: body, messageThread: messageThread))
  }

  public func signup(name name: String,
                          email: String,
                          password: String,
                          passwordConfirmation: String,
                          sendNewsletters: Bool) -> SignalProducer<AccessTokenEnvelope, ErrorEnvelope> {
    return request(.signup(name: name,
                           email: email,
                           password: password,
                           passwordConfirmation: passwordConfirmation,
                           sendNewsletters: sendNewsletters))
  }

  public func signup(facebookAccessToken token: String, sendNewsletters: Bool) ->
    SignalProducer<AccessTokenEnvelope, ErrorEnvelope> {

    return request(.facebookSignup(facebookAccessToken: token, sendNewsletters: sendNewsletters))
  }

  public func unfollowFriend(userId id: Int) -> SignalProducer<VoidEnvelope, ErrorEnvelope> {
    return request(.unfollowFriend(userId: id))
  }

  public func updateProjectNotification(notification: ProjectNotification)
    -> SignalProducer<ProjectNotification, ErrorEnvelope> {

    return request(.updateProjectNotification(notification: notification))
  }

  public func updateUserSelf(user: User) -> SignalProducer<User, ErrorEnvelope> {
    return request(.updateUserSelf(user))
  }

  private func decodeModel<M: Decodable where M == M.DecodedType>(json: AnyObject) ->
    SignalProducer<M, ErrorEnvelope> {

      return SignalProducer(value: json)
        .map { json in decode(json) as Decoded<M> }
        .flatMap(.Concat) { (decoded: Decoded<M>) -> SignalProducer<M, ErrorEnvelope> in
          switch decoded {
          case let .Success(value):
            return .init(value: value)
          case let .Failure(error):
            print("Argo decoding model error: \(error)")
            return .init(error: .couldNotDecodeJSON(error))
          }
      }
  }

  private func decodeModels<M: Decodable where M == M.DecodedType>(json: AnyObject) ->
    SignalProducer<[M], ErrorEnvelope> {

      return SignalProducer(value: json)
        .map { json in decode(json) as Decoded<[M]> }
        .flatMap(.Concat) { (decoded: Decoded<[M]>) -> SignalProducer<[M], ErrorEnvelope> in
          switch decoded {
          case let .Success(value):
            return .init(value: value)
          case let .Failure(error):
            print("Argo decoding model error: \(error)")
            return .init(error: .couldNotDecodeJSON(error))
          }
      }
  }

  private static let session = NSURLSession(configuration: .defaultSessionConfiguration())

  private func requestPagination<M: Decodable where M == M.DecodedType>(paginationUrl: String)
    -> SignalProducer<M, ErrorEnvelope> {

      guard let paginationUrl = NSURL(string: paginationUrl) else {
        return .init(error: .invalidPaginationUrl)
      }
      return self.preparedRequest(paginationUrl)
        .flatMap(decodeModel)
  }

  private func request<M: Decodable where M == M.DecodedType>(route: Route)
    -> SignalProducer<M, ErrorEnvelope> {

      let properties = route.requestProperties

      let URL = self.serverConfig.apiBaseUrl.URLByAppendingPathComponent(properties.path)

      return preparedRequest(URL, method: properties.method, query: properties.query)
        .flatMap(decodeModel)
  }

  private func request<M: Decodable where M == M.DecodedType>(route: Route)
    -> SignalProducer<[M], ErrorEnvelope> {

      let properties = route.requestProperties

      let URL = self.serverConfig.apiBaseUrl.URLByAppendingPathComponent(properties.path)

      return preparedRequest(URL, method: properties.method, query: properties.query)
        .flatMap(decodeModels)
  }

  private func preparedRequest(URL: NSURL, method: Method = .GET, query: [String:AnyObject] = [:])
    -> SignalProducer<AnyObject, ErrorEnvelope> {
    let request = NSMutableURLRequest(URL: URL)

    request.HTTPMethod = method.rawValue

    // Add some headers
    var headers = [
      "Accept-Language": self.language,
      "Kickstarter-iOS-App": self.buildVersion
      ]
    headers["Authorization"] = self.serverConfig.basicHTTPAuth?.authorizationHeader

    // Add some query params for authentication et al
    var query = query
    query["client_id"] = self.serverConfig.apiClientAuth.clientId
    query["oauth_token"] = self.oauthToken?.token

    // swiftlint:disable force_cast
    // NB: instead of force cast we could bubble up a custom ErrorEnvelope error.
    let components = NSURLComponents(URL: URL, resolvingAgainstBaseURL: false)!
    // swiftlint:enable force_cast

    components.queryItems =
      (
        components.queryItems ?? [] + query
          .flatMap(queryComponents)
          .map(NSURLQueryItem.init(name:value:))
      )
      .sort { $0.name < $1.name && $0.value < $0.value }

    if method == .GET || method == .DELETE {
      request.URL = components.URL
    } else if let query = components.query {
      headers["Content-Type"] = "application/x-www-form-urlencoded; charset=utf-8"
      request.HTTPBody = query.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)
    }

    request.allHTTPHeaderFields = headers

    return Service.session.rac_JSONResponse(request)
  }

  private func queryComponents(key: String, _ value: AnyObject) -> [(String, String)] {
    var components: [(String, String)] = []

    if let dictionary = value as? [String: AnyObject] {
      for (nestedKey, value) in dictionary {
        components += queryComponents("\(key)[\(nestedKey)]", value)
      }
    } else if let array = value as? [AnyObject] {
      for value in array {
        components += queryComponents("\(key)[]", value)
      }
    } else {
      components.append((key, String(value)))
    }

    return components
  }
}
