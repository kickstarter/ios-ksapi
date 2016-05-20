// swiftlint:disable file_length
// swiftlint:disable type_body_length
// swiftlint:disable function_body_length

@testable import KsApi
@testable import Models
@testable import Models_TestHelpers
import ReactiveCocoa
import Prelude

internal struct MockService: ServiceType {
  internal let serverConfig: ServerConfigType
  internal let oauthToken: OauthTokenAuthType?
  internal let language: String
  internal let buildVersion: String

  private let fetchActivitiesResponse: [Activity]?
  private let fetchActivitiesError: ErrorEnvelope?

  private let fetchCommentsResponse: [Comment]?
  private let fetchCommentsError: ErrorEnvelope?

  private let fetchConfigResponse: Config?

  private let fetchDiscoveryResponse: [Project]?
  private let fetchDiscoveryError: ErrorEnvelope?

  private let fetchMessageThreadResponse: MessageThread
  private let fetchMessageThreadsResponse: [MessageThread]

  private let fetchProjectResponse: Project?

  private let fetchUserSelfResponse: User

  private let postCommentResponse: Comment?
  private let postCommentError: ErrorEnvelope?

  private let loginResponse: AccessTokenEnvelope?
  private let loginError: ErrorEnvelope?
  private let resendCodeResponse: ErrorEnvelope?
  private let resendCodeError: ErrorEnvelope?

  private let resetPasswordResponse: User?
  private let resetPasswordError: ErrorEnvelope?

  private let signupResponse: AccessTokenEnvelope?
  private let signupError: ErrorEnvelope?

  private let updateNewslettersResponse: User?
  private let updateNewslettersError: ErrorEnvelope?

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
                fetchActivitiesResponse: [Activity]? = nil,
                fetchActivitiesError: ErrorEnvelope? = nil,
                fetchCommentsResponse: [Comment]? = nil,
                fetchCommentsError: ErrorEnvelope? = nil,
                fetchConfigResponse: Config? = nil,
                fetchDiscoveryResponse: [Project]? = nil,
                fetchDiscoveryError: ErrorEnvelope? = nil,
                fetchMessageThreadResponse: MessageThread? = nil,
                fetchMessageThreadsResponse: [MessageThread]? = nil,
                fetchProjectResponse: Project? = nil,
                fetchUserSelfResponse: User? = nil,
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
                updateNewslettersResponse: User? = nil,
                updateNewslettersError: ErrorEnvelope? = nil) {

    self.serverConfig = serverConfig
    self.oauthToken = oauthToken
    self.language = language
    self.buildVersion = buildVersion

    self.fetchActivitiesResponse = fetchActivitiesResponse ?? [
      Activity.template,
      Activity.template |> Activity.lens.category *~ .Backing,
      Activity.template |> Activity.lens.category *~ .Success
    ]

    self.fetchActivitiesError = fetchActivitiesError

    self.fetchCommentsResponse = fetchCommentsResponse ?? [
      Comment.template |> Comment.lens.id *~ 2,
      Comment.template |> Comment.lens.id *~ 1
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

    self.fetchMessageThreadResponse = fetchMessageThreadResponse ??  MessageThread.template

    self.fetchMessageThreadsResponse = fetchMessageThreadsResponse ?? [
      MessageThread.template |> MessageThread.lens.id *~ 1,
      MessageThread.template |> MessageThread.lens.id *~ 2,
      MessageThread.template |> MessageThread.lens.id *~ 3
    ]

    self.fetchProjectResponse = fetchProjectResponse

    self.fetchUserSelfResponse = fetchUserSelfResponse ?? User.template

    self.postCommentResponse = postCommentResponse ?? Comment.template

    self.postCommentError = postCommentError

    self.loginResponse = loginResponse

    self.loginError = loginError

    self.resendCodeResponse = resendCodeResponse

    self.resendCodeError = resendCodeError

    self.resetPasswordResponse = resetPasswordResponse

    self.resetPasswordError = resetPasswordError

    self.signupResponse = signupResponse

    self.signupError = signupError

    self.updateNewslettersResponse = updateNewslettersResponse

    self.updateNewslettersError = updateNewslettersError
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

  internal func login(oauthToken: OauthTokenAuthType) -> MockService {
    return MockService(
      serverConfig: self.serverConfig,
      oauthToken: oauthToken,
      language: self.language,
      buildVersion: self.buildVersion,
      fetchActivitiesResponse: self.fetchActivitiesResponse,
      fetchActivitiesError: self.fetchActivitiesError,
      fetchCommentsResponse: self.fetchCommentsResponse,
      fetchCommentsError: self.fetchCommentsError,
      fetchDiscoveryResponse: self.fetchDiscoveryResponse,
      fetchDiscoveryError: self.fetchDiscoveryError,
      fetchMessageThreadsResponse: self.fetchMessageThreadsResponse,
      fetchProjectResponse: self.fetchProjectResponse,
      fetchUserSelfResponse: self.fetchUserSelfResponse,
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
      updateNewslettersResponse: self.updateNewslettersResponse,
      updateNewslettersError: self.updateNewslettersError
    )
  }

  internal func logout() -> MockService {
    return MockService(
      serverConfig: self.serverConfig,
      oauthToken: nil,
      language: self.language,
      buildVersion: self.buildVersion,
      fetchActivitiesResponse: self.fetchActivitiesResponse,
      fetchActivitiesError: self.fetchActivitiesError,
      fetchCommentsResponse: self.fetchCommentsResponse,
      fetchCommentsError: self.fetchCommentsError,
      fetchDiscoveryResponse: self.fetchDiscoveryResponse,
      fetchDiscoveryError: self.fetchDiscoveryError,
      fetchMessageThreadsResponse: self.fetchMessageThreadsResponse,
      fetchProjectResponse: self.fetchProjectResponse,
      fetchUserSelfResponse: self.fetchUserSelfResponse,
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
      updateNewslettersResponse: self.updateNewslettersResponse,
      updateNewslettersError: self.updateNewslettersError
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
        reward: Reward.template,
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

      let projectsDefault = self.fetchDiscoveryResponse ?? (1...4).map {
        Project.template |> Project.lens.id %~ const($0 + paginationUrl.hashValue)
      }

      return SignalProducer(value:
        DiscoveryEnvelope(
          projects: projectsDefault,
          urls: DiscoveryEnvelope.UrlsEnvelope(
            api: DiscoveryEnvelope.UrlsEnvelope.ApiEnvelope(
              more_projects: paginationUrl + "+1"
            )
          ),
          stats: DiscoveryEnvelope.StatsEnvelope(
            count: 200
          )
        )
      )
  }

  internal func fetchDiscovery(params params: DiscoveryParams)
    -> SignalProducer<DiscoveryEnvelope, ErrorEnvelope> {

      if let error = fetchDiscoveryError {
        return SignalProducer(error: error)
      }

      let projectsDefault = self.fetchDiscoveryResponse ?? (1...4).map {
        Project.template |> Project.lens.id %~ const($0 + params.hashValue)
      }

      return SignalProducer(value:
        DiscoveryEnvelope(
          projects: projectsDefault,
          urls: DiscoveryEnvelope.UrlsEnvelope(
            api: DiscoveryEnvelope.UrlsEnvelope.ApiEnvelope(
              more_projects: "http://***REMOVED***/gimme/more"
            )
          ),
          stats: DiscoveryEnvelope.StatsEnvelope(
            count: 200
          )
        )
      )
  }

  internal func fetchMessageThread(messageThread messageThread: MessageThread)
    -> SignalProducer<MessageThreadEnvelope, ErrorEnvelope> {

      return SignalProducer(
        value: MessageThreadEnvelope(
          participants: [User.template, User.template |> User.lens.id *~ 2],
          messages: [
            Message.template |> Message.lens.id *~ 1,
            Message.template |> Message.lens.id *~ 2,
            Message.template |> Message.lens.id *~ 3
          ],
          messageThread: self.fetchMessageThreadResponse
        )
      )
  }

  internal func fetchMessageThread(backing backing: Backing)
    -> SignalProducer<MessageThreadEnvelope, ErrorEnvelope> {

      return SignalProducer(
        value: MessageThreadEnvelope(
          participants: [User.template, User.template |> User.lens.id *~ 2],
          messages: [
            Message.template |> Message.lens.id *~ 1,
            Message.template |> Message.lens.id *~ 2,
            Message.template |> Message.lens.id *~ 3
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

  internal func fetchProjects(params: DiscoveryParams) -> SignalProducer<[Project], ErrorEnvelope> {
    return fetchDiscovery(params: params)
      .map { $0.projects }
  }

  internal func fetchProject(id id: Int) -> SignalProducer<Project, ErrorEnvelope> {
    if let project = self.fetchProjectResponse {
      return SignalProducer(value: project)
    }
    return SignalProducer(value: Project.template |> Project.lens.id *~ id)
  }

  internal func fetchProject(params: DiscoveryParams) -> SignalProducer<Project, ErrorEnvelope> {
    if let project = self.fetchProjectResponse {
      return SignalProducer(value: project)
    }
    return SignalProducer(value: Project.template |> Project.lens.id *~ params.hashValue)
  }

  internal func fetchProject(project project: Project) -> SignalProducer<Project, ErrorEnvelope> {
    if let project = self.fetchProjectResponse {
      return SignalProducer(value: project)
    }
    return SignalProducer(value: project)
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

    return SignalProducer(value: fetchUserSelfResponse)
  }

  internal func fetchUser(user: User) -> SignalProducer<User, ErrorEnvelope> {
    return SignalProducer(value: user)
  }

  internal func fetchCategories() -> SignalProducer<[Models.Category], ErrorEnvelope> {

    return SignalProducer(value: [
      Category.art,
      Category.filmAndVideo,
      Category.illustration,
      Category.documentary
      ]
    )
  }

  internal func fetchCategory(id id: Int) -> SignalProducer<Models.Category, ErrorEnvelope> {
    return SignalProducer(value: Category.template |> Category.lens.id *~ id)
  }

  internal func toggleStar(project: Project) -> SignalProducer<Project, ErrorEnvelope> {
    return .init(
      value: project |> Project.lens.personalization.isStarred %~ { !($0 ?? false) }
    )
  }

  internal func star(project: Project) -> SignalProducer<Project, ErrorEnvelope> {
    return .init(value: project |> Project.lens.personalization.isStarred *~ true)
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

    return SignalProducer(value: AccessTokenEnvelope(accessToken: "deadbeef", user: User.template))
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

    return SignalProducer(value: AccessTokenEnvelope(accessToken: "deadbeef", user: User.template))
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
    return SignalProducer(value: User.template)
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

      return SignalProducer(value: Message.template |> Message.lens.id *~ body.hashValue)
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
        user: User.template
      )
    )
  }

  func updateNewsletters(games games: Bool?,
                               happening: Bool?,
                               promo: Bool?,
                               weekly: Bool?) -> SignalProducer<User, ErrorEnvelope> {

    if let response = updateNewslettersResponse {
      return SignalProducer(value: response)
    } else if let error = updateNewslettersError {
      return SignalProducer(error: error)
    }

    let newsletters = User.NewsletterSubscriptions.template
      |> User.NewsletterSubscriptions.lens.games *~ games ?? false
      <> User.NewsletterSubscriptions.lens.happening *~ happening ?? false
      <> User.NewsletterSubscriptions.lens.promo *~ promo ?? false
      <> User.NewsletterSubscriptions.lens.weekly *~ weekly ?? false

    return SignalProducer(value: User.template |> User.lens.newsletters *~ newsletters)
  }
}
