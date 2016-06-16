// swiftlint:disable file_length
// swiftlint:disable type_body_length
// swiftlint:disable function_body_length

@testable import KsApi
import ReactiveCocoa
import Prelude

internal struct MockService: ServiceType {
  internal let serverConfig: ServerConfigType
  internal let oauthToken: OauthTokenAuthType?
  internal let language: String
  internal let buildVersion: String

  private let facebookConnectResponse: User?
  private let facebookConnectError: ErrorEnvelope?

  private let fetchActivitiesResponse: [Activity]?
  private let fetchActivitiesError: ErrorEnvelope?

  private let fetchCategoriesResponse: CategoriesEnvelope?

  private let fetchCommentsResponse: [Comment]?
  private let fetchCommentsError: ErrorEnvelope?

  private let fetchConfigResponse: Config?

  private let fetchDiscoveryResponse: DiscoveryEnvelope?
  private let fetchDiscoveryError: ErrorEnvelope?

  private let fetchFriendsResponse: FindFriendsEnvelope?
  private let fetchFriendsError: ErrorEnvelope?

  private let fetchFriendStatsResponse: FriendStatsEnvelope?
  private let fetchFriendStatsError: ErrorEnvelope?

  private let fetchMessageThreadResponse: MessageThread
  private let fetchMessageThreadsResponse: [MessageThread]

  private let fetchProjectResponse: Project?

  private let fetchProjectNotificationsResponse: [ProjectNotification]

  private let fetchProjectsResponse: [Project]?
  private let fetchProjectsError: ErrorEnvelope?

  private let fetchUserSelfResponse: User?
  private let fetchUserSelfError: ErrorEnvelope?

  private let followFriendError: ErrorEnvelope?

  private let postCommentResponse: Comment?
  private let postCommentError: ErrorEnvelope?

  private let fetchProjectActivitiesResponse: [Activity]?
  private let fetchProjectActivitiesError: ErrorEnvelope?

  private let loginResponse: AccessTokenEnvelope?
  private let loginError: ErrorEnvelope?
  private let resendCodeResponse: ErrorEnvelope?
  private let resendCodeError: ErrorEnvelope?

  private let resetPasswordResponse: User?
  private let resetPasswordError: ErrorEnvelope?

  private let signupResponse: AccessTokenEnvelope?
  private let signupError: ErrorEnvelope?

  private let unfollowFriendError: ErrorEnvelope?

  private let updateProjectNotificationResponse: ProjectNotification?
  private let updateProjectNotificationError: ErrorEnvelope?

  private let updateUserSelfError: ErrorEnvelope?

  internal init(serverConfig: ServerConfigType,
                oauthToken: OauthTokenAuthType?,
                language: String,
                buildVersion: String = "1") {

    self.init(
      serverConfig: serverConfig,
      oauthToken: oauthToken,
      language: language,
      buildVersion: buildVersion,
      fetchActivitiesResponse: nil
    )
  }

  internal init(serverConfig: ServerConfigType = ServerConfig.production,
                oauthToken: OauthTokenAuthType? = nil,
                language: String = "en",
                buildVersion: String = "1",
                facebookConnectResponse: User? = nil,
                facebookConnectError: ErrorEnvelope? = nil,
                fetchActivitiesResponse: [Activity]? = nil,
                fetchActivitiesError: ErrorEnvelope? = nil,
                fetchCategoriesResponse: CategoriesEnvelope? = nil,
                fetchCommentsResponse: [Comment]? = nil,
                fetchCommentsError: ErrorEnvelope? = nil,
                fetchConfigResponse: Config? = nil,
                fetchDiscoveryResponse: DiscoveryEnvelope? = nil,
                fetchDiscoveryError: ErrorEnvelope? = nil,
                fetchFriendsResponse: FindFriendsEnvelope? = nil,
                fetchFriendsError: ErrorEnvelope? = nil,
                fetchFriendStatsResponse: FriendStatsEnvelope? = nil,
                fetchFriendStatsError: ErrorEnvelope? = nil,
                fetchMessageThreadResponse: MessageThread? = nil,
                fetchMessageThreadsResponse: [MessageThread]? = nil,
                fetchProjectActivitiesResponse: [Activity]? = nil,
                fetchProjectActivitiesError: ErrorEnvelope? = nil,
                fetchProjectResponse: Project? = nil,
                fetchProjectNotificationsResponse: [ProjectNotification]? = nil,
                fetchProjectsResponse: [Project]? = nil,
                fetchProjectsError: ErrorEnvelope? = nil,
                fetchUserSelfResponse: User? = nil,
                followFriendError: ErrorEnvelope? = nil,
                fetchUserSelfError: ErrorEnvelope? = nil,
                postCommentResponse: Comment? = nil,
                postCommentError: ErrorEnvelope? = nil,
                loginResponse: AccessTokenEnvelope? = nil,
                loginError: ErrorEnvelope? = nil,
                resendCodeResponse: ErrorEnvelope? = nil,
                resendCodeError: ErrorEnvelope? = nil,
                resetPasswordResponse: User? = nil,
                resetPasswordError: ErrorEnvelope? = nil,
                signupResponse: AccessTokenEnvelope? = nil,
                signupError: ErrorEnvelope? = nil,
                unfollowFriendError: ErrorEnvelope? = nil,
                updateProjectNotificationResponse: ProjectNotification? = nil,
                updateProjectNotificationError: ErrorEnvelope? = nil,
                updateUserSelfError: ErrorEnvelope? = nil) {

    self.serverConfig = serverConfig
    self.oauthToken = oauthToken
    self.language = language
    self.buildVersion = buildVersion

    self.facebookConnectResponse = facebookConnectResponse
    self.facebookConnectError = facebookConnectError

    self.fetchActivitiesResponse = fetchActivitiesResponse ?? [
      .template,
      .template |> Activity.lens.category .~ .backing,
      .template |> Activity.lens.category .~ .success
    ]

    self.fetchActivitiesError = fetchActivitiesError

    self.fetchCategoriesResponse = fetchCategoriesResponse ?? (.template
      |> CategoriesEnvelope.lens.categories .~ [
        .art,
        .filmAndVideo,
        .illustration,
        .documentary
      ]
    )

    self.fetchCommentsResponse = fetchCommentsResponse ?? [
      .template |> Comment.lens.id .~ 2,
      .template |> Comment.lens.id .~ 1
    ]

    self.fetchCommentsError = fetchCommentsError

    self.fetchConfigResponse = fetchConfigResponse ?? Config(
      abExperiments: [:],
      appId: 123456789,
      countryCode: "US",
      features: [:],
      iTunesLink: "http://www.itunes.com",
      launchedCountries: [.US],
      locale: "en",
      stripePublishableKey: "pk"
    )

    self.fetchDiscoveryResponse = fetchDiscoveryResponse
    self.fetchDiscoveryError = fetchDiscoveryError

    self.fetchFriendsResponse = fetchFriendsResponse
    self.fetchFriendsError = fetchFriendsError

    self.fetchFriendStatsResponse = fetchFriendStatsResponse
    self.fetchFriendStatsError = fetchFriendStatsError

    self.fetchMessageThreadResponse = fetchMessageThreadResponse ??  .template

    self.fetchMessageThreadsResponse = fetchMessageThreadsResponse ?? [
      .template |> MessageThread.lens.id .~ 1,
      .template |> MessageThread.lens.id .~ 2,
      .template |> MessageThread.lens.id .~ 3
    ]

    self.fetchProjectActivitiesResponse = fetchProjectActivitiesResponse ?? [
      .template,
      .template |> Activity.lens.category .~ .backing,
      .template |> Activity.lens.category .~ .commentProject
      ]
      .enumerate()
      .map(Activity.lens.id.set)

    self.fetchProjectActivitiesError = fetchProjectActivitiesError

    self.fetchProjectResponse = fetchProjectResponse

    self.fetchProjectNotificationsResponse = fetchProjectNotificationsResponse ?? [
      .template |> ProjectNotification.lens.id .~ 1,
      .template |> ProjectNotification.lens.id .~ 2,
      .template |> ProjectNotification.lens.id .~ 3
    ]

    self.fetchProjectsResponse = fetchProjectsResponse ?? [
      .template |> Project.lens.state .~ .successful,
      .template |> Project.lens.state .~ .live,
      .template |> Project.lens.state .~ .live
      ]
      .enumerate()
      .map(Project.lens.id.set)

    self.fetchProjectsError = fetchProjectsError

    self.fetchUserSelfResponse = fetchUserSelfResponse ?? .template
    self.fetchUserSelfError = fetchUserSelfError

    self.followFriendError = followFriendError

    self.postCommentResponse = postCommentResponse ?? .template

    self.postCommentError = postCommentError

    self.loginResponse = loginResponse

    self.loginError = loginError

    self.resendCodeResponse = resendCodeResponse

    self.resendCodeError = resendCodeError

    self.resetPasswordResponse = resetPasswordResponse

    self.resetPasswordError = resetPasswordError

    self.signupResponse = signupResponse

    self.signupError = signupError

    self.unfollowFriendError = unfollowFriendError

    self.updateProjectNotificationResponse = updateProjectNotificationResponse

    self.updateProjectNotificationError = updateProjectNotificationError

    self.updateUserSelfError = updateUserSelfError
  }

  internal func facebookConnect(facebookAccessToken token: String)
    -> SignalProducer<User, ErrorEnvelope> {

      if let response = facebookConnectResponse {
        return SignalProducer(value: response)
      } else if let error = facebookConnectError {
        return SignalProducer(error: error)
      }

      return SignalProducer(value:
        .template
          |> User.lens.id .~ 1
          |> User.lens.facebookConnected .~ true
      )
  }

  internal func fetchComments(project project: Project) -> SignalProducer<CommentsEnvelope, ErrorEnvelope> {

    if let error = fetchCommentsError {
      return SignalProducer(error: error)
    } else if let comments = fetchCommentsResponse {
      return SignalProducer(
        value: CommentsEnvelope(
          comments: comments,
          urls: CommentsEnvelope.UrlsEnvelope(
            api: CommentsEnvelope.UrlsEnvelope.ApiEnvelope(
              moreComments: ""
            )
          )
        )
      )
    }
    return .empty
  }

  internal func fetchComments(paginationUrl url: String) -> SignalProducer<CommentsEnvelope, ErrorEnvelope> {
    if let error = fetchCommentsError {
      return SignalProducer(error: error)
    } else if let comments = fetchCommentsResponse {
      return SignalProducer(
        value: CommentsEnvelope(
          comments: comments,
          urls: CommentsEnvelope.UrlsEnvelope(
            api: CommentsEnvelope.UrlsEnvelope.ApiEnvelope(
              moreComments: ""
            )
          )
        )
      )
    }
    return .empty
  }

  internal func fetchComments(update update: Update) -> SignalProducer<CommentsEnvelope, ErrorEnvelope> {

    if let error = fetchCommentsError {
      return SignalProducer(error: error)
    } else if let comments = fetchCommentsResponse {
      return SignalProducer(
        value: CommentsEnvelope(
          comments: comments,
          urls: CommentsEnvelope.UrlsEnvelope(
            api: CommentsEnvelope.UrlsEnvelope.ApiEnvelope(
              moreComments: ""
            )
          )
        )
      )
    }
    return .empty
  }

  internal func fetchConfig() -> SignalProducer<Config, ErrorEnvelope> {
    guard let config = self.fetchConfigResponse else { return .empty }
    return SignalProducer(value: config)
  }

  internal func fetchFriends() -> SignalProducer<FindFriendsEnvelope, ErrorEnvelope> {
    if let response = fetchFriendsResponse {
      return SignalProducer(value: response)
    } else if let error = fetchFriendsError {
      return SignalProducer(error: error)
    }

    return SignalProducer(value: .template)
  }

  internal func fetchFriends(paginationUrl paginationUrl: String)
    -> SignalProducer<FindFriendsEnvelope, ErrorEnvelope> {
    return self.fetchFriends()
  }

  internal func fetchFriendStats() -> SignalProducer<FriendStatsEnvelope, ErrorEnvelope> {
    if let response = fetchFriendStatsResponse {
      return SignalProducer(value: response)
    } else if let error = fetchFriendStatsError {
      return SignalProducer(error: error)
    }
    return SignalProducer(value: .template)
  }

  internal func followAllFriends() -> SignalProducer<VoidEnvelope, ErrorEnvelope> {
    return SignalProducer(value: VoidEnvelope())
  }

  internal func followFriend(userId id: Int) -> SignalProducer<User, ErrorEnvelope> {
    if let error = followFriendError {
      return SignalProducer(error: error)
    }

    return SignalProducer(value:
      .template
        |> User.lens.id .~ id
        |> User.lens.isFriend .~ true
    )
  }

  internal func unfollowFriend(userId id: Int) -> SignalProducer<VoidEnvelope, ErrorEnvelope> {
    if let error = unfollowFriendError {
      return SignalProducer(error: error)
    }

    return SignalProducer(value: VoidEnvelope())
  }

  internal func login(oauthToken: OauthTokenAuthType) -> MockService {
    return MockService(
      serverConfig: self.serverConfig,
      oauthToken: oauthToken,
      language: self.language,
      buildVersion: self.buildVersion,
      facebookConnectResponse: self.facebookConnectResponse,
      facebookConnectError: self.facebookConnectError,
      fetchActivitiesResponse: self.fetchActivitiesResponse,
      fetchActivitiesError: self.fetchActivitiesError,
      fetchCommentsResponse: self.fetchCommentsResponse,
      fetchCommentsError: self.fetchCommentsError,
      fetchDiscoveryResponse: self.fetchDiscoveryResponse,
      fetchDiscoveryError: self.fetchDiscoveryError,
      fetchFriendsResponse: self.fetchFriendsResponse,
      fetchFriendsError: self.fetchFriendsError,
      fetchFriendStatsResponse: self.fetchFriendStatsResponse,
      fetchFriendStatsError: self.fetchFriendStatsError,
      fetchMessageThreadsResponse: self.fetchMessageThreadsResponse,
      fetchProjectActivitiesResponse: self.fetchProjectActivitiesResponse,
      fetchProjectActivitiesError: self.fetchProjectActivitiesError,
      fetchProjectResponse: self.fetchProjectResponse,
      fetchProjectNotificationsResponse: self.fetchProjectNotificationsResponse,
      fetchProjectsResponse: self.fetchProjectsResponse,
      fetchProjectsError: self.fetchProjectsError,
      fetchUserSelfResponse: self.fetchUserSelfResponse,
      followFriendError: self.followFriendError,
      fetchUserSelfError: self.fetchUserSelfError,
      postCommentResponse: self.postCommentResponse,
      postCommentError: self.postCommentError,
      loginResponse: self.loginResponse,
      loginError: self.loginError,
      resendCodeResponse: self.resendCodeResponse,
      resendCodeError: self.resendCodeError,
      resetPasswordResponse: self.resetPasswordResponse,
      resetPasswordError: self.resetPasswordError,
      signupResponse: self.signupResponse,
      signupError: self.signupError,
      unfollowFriendError: self.unfollowFriendError,
      updateProjectNotificationResponse: self.updateProjectNotificationResponse,
      updateProjectNotificationError: self.updateProjectNotificationError,
      updateUserSelfError: self.updateUserSelfError
    )
  }

  internal func logout() -> MockService {
    return MockService(
      serverConfig: self.serverConfig,
      oauthToken: nil,
      language: self.language,
      buildVersion: self.buildVersion,
      facebookConnectResponse: self.facebookConnectResponse,
      facebookConnectError: self.facebookConnectError,
      fetchActivitiesResponse: self.fetchActivitiesResponse,
      fetchActivitiesError: self.fetchActivitiesError,
      fetchCommentsResponse: self.fetchCommentsResponse,
      fetchCommentsError: self.fetchCommentsError,
      fetchDiscoveryResponse: self.fetchDiscoveryResponse,
      fetchDiscoveryError: self.fetchDiscoveryError,
      fetchFriendsResponse: self.fetchFriendsResponse,
      fetchFriendsError: self.fetchFriendsError,
      fetchFriendStatsResponse: self.fetchFriendStatsResponse,
      fetchFriendStatsError: self.fetchFriendStatsError,
      fetchMessageThreadsResponse: self.fetchMessageThreadsResponse,
      fetchProjectActivitiesResponse: self.fetchProjectActivitiesResponse,
      fetchProjectActivitiesError: self.fetchProjectActivitiesError,
      fetchProjectResponse: self.fetchProjectResponse,
      fetchProjectNotificationsResponse: self.fetchProjectNotificationsResponse,
      fetchProjectsResponse: self.fetchProjectsResponse,
      fetchProjectsError: self.fetchProjectsError,
      fetchUserSelfResponse: self.fetchUserSelfResponse,
      followFriendError: self.followFriendError,
      fetchUserSelfError: self.fetchUserSelfError,
      postCommentResponse: self.postCommentResponse,
      postCommentError: self.postCommentError,
      loginResponse: self.loginResponse,
      loginError: self.loginError,
      resendCodeResponse: self.resendCodeResponse,
      resendCodeError: self.resendCodeError,
      resetPasswordResponse: self.resetPasswordResponse,
      resetPasswordError: self.resetPasswordError,
      signupResponse: self.signupResponse,
      signupError: self.signupError,
      unfollowFriendError: self.unfollowFriendError,
      updateProjectNotificationResponse: self.updateProjectNotificationResponse,
      updateProjectNotificationError: self.updateProjectNotificationError,
      updateUserSelfError: self.updateUserSelfError
    )
  }

  internal func fetchActivities() -> SignalProducer<ActivityEnvelope, ErrorEnvelope> {

    if let error = fetchActivitiesError {
      return SignalProducer(error: error)
    } else if let activities = fetchActivitiesResponse {
      return SignalProducer(
        value: ActivityEnvelope(
          activities: activities,
          urls: ActivityEnvelope.UrlsEnvelope(
            api: ActivityEnvelope.UrlsEnvelope.ApiEnvelope(
              moreActivities: "http://***REMOVED***/gimme/more"
            )
          )
        )
      )
    }
    return .empty
  }

  internal func fetchActivities(paginationUrl paginationUrl: String)
    -> SignalProducer<ActivityEnvelope, ErrorEnvelope> {
      return self.fetchActivities()
  }

  func fetchBacking(forProject project: Project, forUser user: User)
    -> SignalProducer<Backing, ErrorEnvelope> {

    return SignalProducer(
      value: Backing(
        amount: 10,
        backerId: 1,
        id: 1,
        locationId: 1,
        pledgedAt: 123456789.0,
        projectCountry: "US",
        projectId: 1,
        reward: .template,
        rewardId: 1,
        sequence: 10,
        shippingAmount: 2,
        status: .pledged
      )
    )
  }

  internal func fetchDiscovery(paginationUrl paginationUrl: String)
    -> SignalProducer<DiscoveryEnvelope, ErrorEnvelope> {

      if let error = fetchDiscoveryError {
        return SignalProducer(error: error)
      }

      let project: Int -> Project = {
        .template |> Project.lens.id .~ ($0 + paginationUrl.hashValue)
      }
      let envelope = self.fetchDiscoveryResponse ?? (.template
        |> DiscoveryEnvelope.lens.projects .~ (1...4).map(project)
        |> DiscoveryEnvelope.lens.urls.api.moreProjects .~ paginationUrl + "+1"
      )

      return SignalProducer(value: envelope)
  }

  internal func fetchDiscovery(params params: DiscoveryParams)
    -> SignalProducer<DiscoveryEnvelope, ErrorEnvelope> {

      if let error = fetchDiscoveryError {
        return SignalProducer(error: error)
      }

      let project: Int -> Project = {
        .template |> Project.lens.id %~ const($0 + params.hashValue)
      }
      let envelope = self.fetchDiscoveryResponse ?? (.template
        |> DiscoveryEnvelope.lens.projects .~ (1...4).map(project)
      )

      return SignalProducer(value: envelope)
  }

  internal func fetchMessageThread(messageThread messageThread: MessageThread)
    -> SignalProducer<MessageThreadEnvelope, ErrorEnvelope> {

      return SignalProducer(
        value: MessageThreadEnvelope(
          participants: [.template, .template |> User.lens.id .~ 2],
          messages: [
            .template |> Message.lens.id .~ 1,
            .template |> Message.lens.id .~ 2,
            .template |> Message.lens.id .~ 3
          ],
          messageThread: self.fetchMessageThreadResponse
        )
      )
  }

  internal func fetchMessageThread(backing backing: Backing)
    -> SignalProducer<MessageThreadEnvelope, ErrorEnvelope> {

      return SignalProducer(
        value: MessageThreadEnvelope(
          participants: [.template, .template |> User.lens.id .~ 2],
          messages: [
            .template |> Message.lens.id .~ 1,
            .template |> Message.lens.id .~ 2,
            .template |> Message.lens.id .~ 3
          ],
          messageThread: self.fetchMessageThreadResponse
        )
      )
  }

  internal func fetchMessageThreads(mailbox mailbox: Mailbox, project: Project?)
    -> SignalProducer<MessageThreadsEnvelope, ErrorEnvelope> {

      return SignalProducer(value:
        MessageThreadsEnvelope(
          messageThreads: self.fetchMessageThreadsResponse,
          urls: MessageThreadsEnvelope.UrlsEnvelope(
            api: MessageThreadsEnvelope.UrlsEnvelope.ApiEnvelope(
              moreMessageThreads: ""
            )
          )
        )
      )
  }

  internal func fetchMessageThreads(paginationUrl paginationUrl: String)
    -> SignalProducer<MessageThreadsEnvelope, ErrorEnvelope> {

      return SignalProducer(value:
        MessageThreadsEnvelope(
          messageThreads: self.fetchMessageThreadsResponse,
          urls: MessageThreadsEnvelope.UrlsEnvelope(
            api: MessageThreadsEnvelope.UrlsEnvelope.ApiEnvelope(
              moreMessageThreads: ""
            )
          )
        )
      )
  }

  internal func fetchProjectNotifications() -> SignalProducer<[ProjectNotification], ErrorEnvelope> {
    return SignalProducer(value: self.fetchProjectNotificationsResponse)
  }

  internal func fetchProject(id id: Int) -> SignalProducer<Project, ErrorEnvelope> {
    if let project = self.fetchProjectResponse {
      return SignalProducer(value: project)
    }
    return SignalProducer(value: .template |> Project.lens.id .~ id)
  }

  internal func fetchProject(params: DiscoveryParams) -> SignalProducer<DiscoveryEnvelope, ErrorEnvelope> {
    if let envelope = self.fetchDiscoveryResponse {
      return SignalProducer(value: envelope)
    }
    let envelope = .template
      |> DiscoveryEnvelope.lens.projects .~ [
        .template |> Project.lens.id .~ params.hashValue
    ]
    return SignalProducer(value: envelope)
  }

  internal func fetchProject(project project: Project) -> SignalProducer<Project, ErrorEnvelope> {
    if let project = self.fetchProjectResponse {
      return SignalProducer(value: project)
    }
    return SignalProducer(value: project)
  }

  internal func fetchProjectActivities(forProject project: Project) ->
    SignalProducer<ProjectActivityEnvelope, ErrorEnvelope> {

    if let error = fetchProjectActivitiesError {
      return SignalProducer(error: error)
    } else if let activities = fetchProjectActivitiesResponse {
      return SignalProducer(
        value: ProjectActivityEnvelope(
          activities: activities,
          urls: ProjectActivityEnvelope.UrlsEnvelope(
            api: ProjectActivityEnvelope.UrlsEnvelope.ApiEnvelope(
              moreActivities: "http://***REMOVED***/gimme/more"
            )
          )
        )
      )
    }
    return .empty
  }

  internal func fetchProjectActivities(paginationUrl paginationUrl: String)
    -> SignalProducer<ProjectActivityEnvelope, ErrorEnvelope> {

    if let error = fetchProjectActivitiesError {
      return SignalProducer(error: error)
    } else if let activities = fetchProjectActivitiesResponse {
      return SignalProducer(
        value: ProjectActivityEnvelope(
          activities: activities,
          urls: ProjectActivityEnvelope.UrlsEnvelope(
            api: ProjectActivityEnvelope.UrlsEnvelope.ApiEnvelope(
              moreActivities: ""
            )
          )
        )
      )
    }
    return .empty
  }

  internal func fetchProjects(member member: Bool) -> SignalProducer<ProjectsEnvelope, ErrorEnvelope> {

    if let error = fetchProjectsError {
      return SignalProducer(error: error)
    } else if let projects = fetchProjectsResponse {
      return SignalProducer(
        value: ProjectsEnvelope(
          projects: projects,
          urls: ProjectsEnvelope.UrlsEnvelope(
            api: ProjectsEnvelope.UrlsEnvelope.ApiEnvelope(
              moreProjects: ""
            )
          )
        )
      )
    }
    return .empty
  }

  internal func fetchProjects(paginationUrl paginationUrl: String) ->
    SignalProducer<ProjectsEnvelope, ErrorEnvelope> {
      return fetchProjects(member: true)
  }

  internal func fetchUserSelf() -> SignalProducer<User, ErrorEnvelope> {
    if self.oauthToken == nil {
      return SignalProducer(
        error: ErrorEnvelope(
          errorMessages: ["Something went wrong"],
          ksrCode: .AccessTokenInvalid,
          httpCode: 401,
          exception: nil
        )
      )
    }

    return SignalProducer(value: self.fetchUserSelfResponse ?? .template)
  }

  internal func fetchUser(user: User) -> SignalProducer<User, ErrorEnvelope> {
    return SignalProducer(value: user)
  }

  internal func fetchCategories() -> SignalProducer<CategoriesEnvelope, ErrorEnvelope> {

    return SignalProducer(value: self.fetchCategoriesResponse ?? .template)
  }

  internal func fetchCategory(id id: Int) -> SignalProducer<KsApi.Category, ErrorEnvelope> {
    return SignalProducer(value: .template |> Category.lens.id .~ id)
  }

  internal func toggleStar(project: Project) -> SignalProducer<StarEnvelope, ErrorEnvelope> {
    let project = project |> Project.lens.personalization.isStarred %~ { !($0 ?? false) }
    return .init(
      value: .template |> StarEnvelope.lens.project .~ project
    )
  }

  internal func star(project: Project) -> SignalProducer<StarEnvelope, ErrorEnvelope> {
    let project = project |> Project.lens.personalization.isStarred .~ true
    return .init(value: .template |> StarEnvelope.lens.project .~ project)
  }

  internal func login(email email: String, password: String, code: String?) ->
    SignalProducer<AccessTokenEnvelope, ErrorEnvelope> {

    if let error = loginError {
      return SignalProducer(error: error)
    } else if let accessTokenEnvelope = loginResponse {
      return SignalProducer(value: accessTokenEnvelope)
    } else if let resendCodeResponse = resendCodeResponse {
      return SignalProducer(error: resendCodeResponse)
    } else if let resendCodeError = resendCodeError {
      return SignalProducer(error: resendCodeError)
    }

    return SignalProducer(value: AccessTokenEnvelope(accessToken: "deadbeef", user: .template))
  }

  internal func login(facebookAccessToken facebookAccessToken: String, code: String?) ->
    SignalProducer<AccessTokenEnvelope, ErrorEnvelope> {

    if let error = loginError {
      return SignalProducer(error: error)
    } else if let accessTokenEnvelope = loginResponse {
      return SignalProducer(value: accessTokenEnvelope)
    } else if let resendCodeResponse = resendCodeResponse {
      return SignalProducer(error: resendCodeResponse)
    } else if let resendCodeError = resendCodeError {
      return SignalProducer(error: resendCodeError)
    }

    return SignalProducer(value: AccessTokenEnvelope(accessToken: "deadbeef", user: .template))
  }

  internal func markAsRead(messageThread messageThread: MessageThread)
    -> SignalProducer<MessageThread, ErrorEnvelope> {
      return SignalProducer(value: messageThread)
  }

  internal func postComment(body: String, toProject project: Project) ->
    SignalProducer<Comment, ErrorEnvelope> {

    if let error = self.postCommentError {
      return SignalProducer(error: error)
    } else if let comment = self.postCommentResponse {
      return SignalProducer(value: comment)
    }
    return .empty
  }

  func postComment(body: String, toUpdate update: Update) -> SignalProducer<Comment, ErrorEnvelope> {

    if let error = self.postCommentError {
      return SignalProducer(error: error)
    } else if let comment = self.postCommentResponse {
      return SignalProducer(value: comment)
    }
    return .empty
  }

  func resetPassword(email email: String) -> SignalProducer<User, ErrorEnvelope> {
    if let response = resetPasswordResponse {
      return SignalProducer(value: response)
    } else if let error = resetPasswordError {
      return SignalProducer(error: error)
    }
    return SignalProducer(value: .template)
  }

  internal func searchMessages(query query: String, project: Project?)
    -> SignalProducer<MessageThreadsEnvelope, ErrorEnvelope> {
      return SignalProducer(value:
        MessageThreadsEnvelope(
          messageThreads: self.fetchMessageThreadsResponse,
          urls: MessageThreadsEnvelope.UrlsEnvelope(
            api: MessageThreadsEnvelope.UrlsEnvelope.ApiEnvelope(
              moreMessageThreads: ""
            )
          )
        )
      )
  }

  internal func sendMessage(body body: String, toThread messageThread: MessageThread)
    -> SignalProducer<Message, ErrorEnvelope> {

      return SignalProducer(value: .template |> Message.lens.id .~ body.hashValue)
  }

  internal func signup(name name: String,
                          email: String,
                          password: String,
                          passwordConfirmation: String,
                          sendNewsletters: Bool) -> SignalProducer<AccessTokenEnvelope, ErrorEnvelope> {
    if let error = signupError {
      return SignalProducer(error: error)
    } else if let accessTokenEnvelope = signupResponse {
      return SignalProducer(value: accessTokenEnvelope)
    }
    return SignalProducer(value:
      AccessTokenEnvelope(
        accessToken: "deadbeef",
        user: .template
          |> User.lens.name .~ name
          |> User.lens.newsletters.weekly .~ sendNewsletters
      )
    )
  }

  internal func signup(facebookAccessToken facebookAccessToken: String, sendNewsletters: Bool) ->
    SignalProducer<AccessTokenEnvelope, ErrorEnvelope> {

    if let error = signupError {
      return SignalProducer(error: error)
    } else if let accessTokenEnvelope = signupResponse {
      return SignalProducer(value: accessTokenEnvelope)
    }
    return SignalProducer(value:
      AccessTokenEnvelope(
        accessToken: "deadbeef",
        user: .template
      )
    )
  }

  internal func updateProjectNotification(notification: ProjectNotification)
    -> SignalProducer<ProjectNotification, ErrorEnvelope> {
      if let error = updateProjectNotificationError {
        return SignalProducer(error: error)
      }
      return SignalProducer(value: notification)
  }

  internal func updateUserSelf(user: User) -> SignalProducer<User, ErrorEnvelope> {
    if let error = updateUserSelfError {
      return SignalProducer(error: error)
    }
    return SignalProducer(value: user)
  }
}
