@testable import KsApi
@testable import Models
@testable import Models_TestHelpers
import ReactiveCocoa

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
                postCommentResponse: Comment? = nil,
                postCommentError: ErrorEnvelope? = nil,
                loginResponse: AccessTokenEnvelope? = nil,
                loginError: ErrorEnvelope? = nil,
                resendCodeResponse: ErrorEnvelope? = nil,
                resendCodeError: ErrorEnvelope? = nil,
                resetPasswordResponse: User? = nil,
                resetPasswordError: ErrorEnvelope? = nil,
                signupResponse: AccessTokenEnvelope? = nil,
                signupError: ErrorEnvelope? = nil) {

    self.serverConfig = serverConfig
    self.oauthToken = oauthToken
    self.language = language
    self.buildVersion = buildVersion

    self.fetchActivitiesResponse = fetchActivitiesResponse ?? [
      ActivityFactory.updateActivity,
      ActivityFactory.backingActivity,
      ActivityFactory.successActivity
    ]

    self.fetchActivitiesError = fetchActivitiesError

    self.fetchCommentsResponse = fetchCommentsResponse ?? [
      CommentFactory.comment(id: 2),
      CommentFactory.comment(id: 1)
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

    self.postCommentResponse = postCommentResponse ?? CommentFactory.comment()

    self.postCommentError = postCommentError

    self.loginResponse = loginResponse

    self.loginError = loginError

    self.resendCodeResponse = resendCodeResponse

    self.resendCodeError = resendCodeError

    self.resetPasswordResponse = resetPasswordResponse

    self.resetPasswordError = resetPasswordError

    self.signupResponse = signupResponse

    self.signupError = signupError
  }

  internal func fetchComments(project project: Project) -> SignalProducer<CommentsEnvelope, ErrorEnvelope> {

    if let error = fetchCommentsError {
      return SignalProducer(error: error)
    } else if let comments = fetchCommentsResponse {
      return SignalProducer(value: CommentsEnvelope(comments: comments))
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
      postCommentResponse: self.postCommentResponse,
      postCommentError: self.postCommentError,
      loginResponse: self.loginResponse,
      loginError: self.loginError,
      resendCodeResponse: self.resendCodeResponse,
      resendCodeError: self.resendCodeError,
      resetPasswordResponse: self.resetPasswordResponse,
      resetPasswordError: self.resetPasswordError,
      signupResponse: self.signupResponse,
      signupError: self.signupError
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
      postCommentResponse: self.postCommentResponse,
      postCommentError: self.postCommentError,
      loginResponse: self.loginResponse,
      loginError: self.loginError,
      resendCodeResponse: self.resendCodeResponse,
      resendCodeError: self.resendCodeError,
      resetPasswordResponse: self.resetPasswordResponse,
      resetPasswordError: self.resetPasswordError,
      signupResponse: self.signupResponse,
      signupError: self.signupError
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

  internal func fetchDiscovery(paginationUrl paginationUrl: String)
    -> SignalProducer<DiscoveryEnvelope, ErrorEnvelope> {

    let projects = (1...4).map { ProjectFactory.live(id: $0 + paginationUrl.hashValue) }

    return SignalProducer(value:
      DiscoveryEnvelope(
        projects: projects,
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

    let projects = (1...4).map { ProjectFactory.live(id: $0 + params.hashValue) }

    return SignalProducer(value:
      DiscoveryEnvelope(
        projects: projects,
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

  internal func fetchProjects(params: DiscoveryParams) -> SignalProducer<[Project], ErrorEnvelope> {
    return fetchDiscovery(params: params)
      .map { $0.projects }
  }

  internal func fetchProject(params: DiscoveryParams) -> SignalProducer<Project, ErrorEnvelope> {
    return fetchDiscovery(params: params)
      .map { $0.projects.first }
      .ignoreNil()
  }

  internal func fetchProject(project: Project) -> SignalProducer<Project, ErrorEnvelope> {
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

    return SignalProducer(value: UserFactory.user())
  }

  internal func fetchUser(user: User) -> SignalProducer<User, ErrorEnvelope> {
    return SignalProducer(value: user)
  }

  internal func fetchCategories() -> SignalProducer<[Models.Category], ErrorEnvelope> {

    return SignalProducer(value: [
      CategoryFactory.art,
      CategoryFactory.filmAndVideo,
      CategoryFactory.illustration,
      CategoryFactory.documentary
      ]
    )
  }

  internal func fetchCategory(category: Models.Category) -> SignalProducer<Models.Category, ErrorEnvelope> {
    return SignalProducer(value: category)
  }

  internal func toggleStar(project: Project) -> SignalProducer<Project, ErrorEnvelope> {
    return .init(
      value: project.personalization.isStarred == true ?
        ProjectFactory.notStarred :
        ProjectFactory.starred
    )
  }

  internal func star(project: Project) -> SignalProducer<Project, ErrorEnvelope> {
    return .init(value: ProjectFactory.starred)
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

    return SignalProducer(value:
      AccessTokenEnvelope(
        accessToken: "deadbeef",
        user: UserFactory.user()
      )
    )
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

    return SignalProducer(value:
      AccessTokenEnvelope(
        accessToken: "deadbeef",
        user: UserFactory.user()
      )
    )
  }

  internal func postComment(body: String, toProject project: Project) ->
    SignalProducer<Comment, ErrorEnvelope> {

    if let error = postCommentError {
      return SignalProducer(error: error)
    } else if let comment = postCommentResponse {
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
    return SignalProducer(value: UserFactory.user())
  }

  func signup(facebookAccessToken facebookAccessToken: String, sendNewsletters: Bool) ->
    SignalProducer<AccessTokenEnvelope, ErrorEnvelope> {

    if let error = signupError {
      return SignalProducer(error: error)
    } else if let accessTokenEnvelope = signupResponse {
      return SignalProducer(value: accessTokenEnvelope)
    }
    return SignalProducer(value:
      AccessTokenEnvelope(
        accessToken: "deadbeef",
        user: UserFactory.user()
      )
    )
  }
}
