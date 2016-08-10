// swiftlint:disable file_length

import Argo
import Foundation
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
    self.buildVersion = (NSBundle.mainBundle().infoDictionary?["CFBundleVersion"] as? String) ?? "1"
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

  public func facebookConnect(facebookAccessToken token: String) -> SignalProducer<User, ErrorEnvelope> {
    return request(.facebookConnect(facebookAccessToken: token))
  }

  public func addImage(file fileURL: NSURL, toDraft draft: UpdateDraft)
    -> SignalProducer<UpdateDraft.Image, ErrorEnvelope> {

      return request(Route.addImage(fileUrl: fileURL, toDraft: draft))
  }

  public func addVideo(file fileURL: NSURL, toDraft draft: UpdateDraft)
    -> SignalProducer<UpdateDraft.Video, ErrorEnvelope> {

      return request(Route.addVideo(fileUrl: fileURL, toDraft: draft))
  }

  public func delete(image image: UpdateDraft.Image, fromDraft draft: UpdateDraft)
    -> SignalProducer<UpdateDraft.Image, ErrorEnvelope> {

      return request(.deleteImage(image, fromDraft: draft))
  }

  public func delete(video video: UpdateDraft.Video, fromDraft draft: UpdateDraft)
    -> SignalProducer<UpdateDraft.Video, ErrorEnvelope> {

      return request(.deleteVideo(video, fromDraft: draft))
  }

  public func previewUrl(forDraft draft: UpdateDraft) -> NSURL {
    return self.serverConfig.apiBaseUrl
      .URLByAppendingPathComponent("/v1/projects/\(draft.update.projectId)/updates/draft/preview")
  }

  public func fetchActivities(count count: Int?) -> SignalProducer<ActivityEnvelope, ErrorEnvelope> {
    let categories: [Activity.Category] = [
      .backing,
      .cancellation,
      .failure,
      .follow,
      .launch,
      .success,
      .update,
    ]
    return request(.activities(categories: categories, count: count))
  }

  public func fetchActivities(paginationUrl paginationUrl: String)
    -> SignalProducer<ActivityEnvelope, ErrorEnvelope> {
      return requestPagination(paginationUrl)
  }

  public func fetchBacking(forProject project: Project, forUser user: User)
    -> SignalProducer<Backing, ErrorEnvelope> {
      return request(.backing(projectId: project.id, backerId: user.id))
  }

  public func fetchCategories() -> SignalProducer<CategoriesEnvelope, ErrorEnvelope> {
    return request(.categories)
  }

  public func fetchCategory(id id: Int) -> SignalProducer<Category, ErrorEnvelope> {
    return request(.category(id))
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

  public func fetchProject(param param: Param) -> SignalProducer<Project, ErrorEnvelope> {
    return request(.project(param))
  }

  public func fetchProject(params: DiscoveryParams) -> SignalProducer<DiscoveryEnvelope, ErrorEnvelope> {
    return request(.discover(params |> DiscoveryParams.lens.perPage .~ 1))
  }

  public func fetchProject(project project: Project) -> SignalProducer<Project, ErrorEnvelope> {
    return request(.project(.id(project.id)))
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

  public func fetchProjectStats(projectId projectId: Int) ->
    SignalProducer<ProjectStatsEnvelope, ErrorEnvelope> {
      return request(.projectStats(projectId: projectId))
  }

  public func fetchUserSelf() -> SignalProducer<User, ErrorEnvelope> {
    return request(.userSelf)
  }

  public func fetchUser(userId userId: Int) -> SignalProducer<User, ErrorEnvelope> {
    return request(.user(userId: userId))
  }

  public func fetchUser(user: User) -> SignalProducer<User, ErrorEnvelope> {
    return fetchUser(userId: user.id)
  }

  public func fetchUpdate(updateId updateId: Int, projectParam: Param)
    -> SignalProducer<Update, ErrorEnvelope> {

      return request(.update(updateId: updateId, projectParam: projectParam))
  }

  public func fetchUpdateDraft(forProject project: Project) -> SignalProducer<UpdateDraft, ErrorEnvelope> {
    return request(.fetchUpdateDraft(forProject: project))
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

  public func incrementVideoCompletion(forProject project: Project) ->
    SignalProducer<VoidEnvelope, ErrorEnvelope> {

      let producer = request(.incrementVideoCompletion(project: project))
        as SignalProducer<VoidEnvelope, ErrorEnvelope>

      return producer
        .flatMapError { env -> SignalProducer<VoidEnvelope, ErrorEnvelope> in
          if env.ksrCode == .ErrorEnvelopeJSONParsingFailed {
            return .init(value: VoidEnvelope())
          }
          return .init(error: env)
      }
  }

  public func incrementVideoStart(forProject project: Project) ->
    SignalProducer<VoidEnvelope, ErrorEnvelope> {

      let producer = request(.incrementVideoStart(project: project))
        as SignalProducer<VoidEnvelope, ErrorEnvelope>

      return producer
        .flatMapError { env -> SignalProducer<VoidEnvelope, ErrorEnvelope> in
          if env.ksrCode == .ErrorEnvelopeJSONParsingFailed {
            return .init(value: VoidEnvelope())
          }
          return .init(error: env)
      }
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

  public func publish(draft draft: UpdateDraft) -> SignalProducer<Update, ErrorEnvelope> {
    return request(.publishUpdateDraft(draft))
  }

  public func resetPassword(email email: String) -> SignalProducer<User, ErrorEnvelope> {
    return request(.resetPassword(email: email))
  }

  public func searchMessages(query query: String, project: Project?)
    -> SignalProducer<MessageThreadsEnvelope, ErrorEnvelope> {

      return request(.searchMessages(query: query, project: project))
  }

  public func sendMessage(body body: String, toSubject subject: MessageSubject)
    -> SignalProducer<Message, ErrorEnvelope> {


      return request(.sendMessage(body: body, messageSubject: subject))
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

  public func star(project: Project) -> SignalProducer<StarEnvelope, ErrorEnvelope> {
    return request(.star(project))
  }

  public func toggleStar(project: Project) -> SignalProducer<StarEnvelope, ErrorEnvelope> {
    return request(.toggleStar(project))
  }

  public func unfollowFriend(userId id: Int) -> SignalProducer<VoidEnvelope, ErrorEnvelope> {
    return request(.unfollowFriend(userId: id))
  }

  public func update(draft draft: UpdateDraft, title: String, body: String, isPublic: Bool)
    -> SignalProducer<UpdateDraft, ErrorEnvelope> {

      return request(.updateUpdateDraft(draft, title: title, body: body, isPublic: isPublic))
  }

  public func updateProjectNotification(notification: ProjectNotification)
    -> SignalProducer<ProjectNotification, ErrorEnvelope> {

    return request(.updateProjectNotification(notification: notification))
  }

  public func updateUserSelf(user: User) -> SignalProducer<User, ErrorEnvelope> {
    return request(.updateUserSelf(user))
  }

  // MARK: -

  private func decodeModel<M: Decodable where M == M.DecodedType>(json: AnyObject) ->
    SignalProducer<M, ErrorEnvelope> {

      return SignalProducer(value: json)
        .map { json in decode(json) as Decoded<M> }
        .flatMap(.Concat) { (decoded: Decoded<M>) -> SignalProducer<M, ErrorEnvelope> in
          switch decoded {
          case let .Success(value):
            return .init(value: value)
          case let .Failure(error):
            print("Argo decoding model \(M.self) error: \(error)")
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

      return Service.session.rac_JSONResponse(preparedRequest(forURL: paginationUrl))
        .flatMap(decodeModel)
  }

  private func request<M: Decodable where M == M.DecodedType>(route: Route)
    -> SignalProducer<M, ErrorEnvelope> {

      let properties = route.requestProperties

      let URL = NSURL(string: properties.path, relativeToURL: self.serverConfig.apiBaseUrl)!

      return Service.session.rac_JSONResponse(
        preparedRequest(forURL: URL, method: properties.method, query: properties.query),
        uploading: properties.file.map { ($1, $0.rawValue) }
        )
        .flatMap(decodeModel)
  }

  private func request<M: Decodable where M == M.DecodedType>(route: Route)
    -> SignalProducer<[M], ErrorEnvelope> {

      let properties = route.requestProperties

      let URL = self.serverConfig.apiBaseUrl.URLByAppendingPathComponent(properties.path)

      return Service.session.rac_JSONResponse(
        preparedRequest(forURL: URL, method: properties.method, query: properties.query),
        uploading: properties.file.map { ($1, $0.rawValue) }
        )
        .flatMap(decodeModels)
  }
}
