import Models
import ReactiveCocoa

/**
 A type that knows how to perform requests for Kickstarter data.
 */
public protocol ServiceType {
  var serverConfig: ServerConfigType { get }
  var oauthToken: OauthTokenAuthType? { get }
  var language: String { get }
  var buildVersion: String { get }

  init(serverConfig: ServerConfigType,
       oauthToken: OauthTokenAuthType?,
       language: String,
       buildVersion: String)

  /// Returns a new service with the oauth token replaced.
  func login(oauthToken: OauthTokenAuthType) -> Self

  /// Returns a new service with the oauth token set to `nil`.
  func logout() -> Self

  /// Fetch a page of activities.
  func fetchActivities() -> SignalProducer<ActivityEnvelope, ErrorEnvelope>

  /// Fetch activities from a pagination URL
  func fetchActivities(paginationUrl paginationUrl: String) -> SignalProducer<ActivityEnvelope, ErrorEnvelope>

  /// Fetch all categories.
  func fetchCategories() -> SignalProducer<[Models.Category], ErrorEnvelope>

  /// Fetch the newest data for a particular category.
  func fetchCategory(category: Models.Category) -> SignalProducer<Models.Category, ErrorEnvelope>

  /// Fetch comments for a project.
  func fetchComments(project project: Project) -> SignalProducer<CommentsEnvelope, ErrorEnvelope>

  /// Fetch the config.
  func fetchConfig() -> SignalProducer<Config, ErrorEnvelope>

  /// Fetch discovery envelope with a pagination url.
  func fetchDiscovery(paginationUrl paginationUrl: String) -> SignalProducer<DiscoveryEnvelope, ErrorEnvelope>

  /// Fetch the full discovery envelope with specified discovery params.
  func fetchDiscovery(params params: DiscoveryParams) -> SignalProducer<DiscoveryEnvelope, ErrorEnvelope>

  /// Fetch a single project with the specified discovery params.
  func fetchProject(params: DiscoveryParams) -> SignalProducer<Project, ErrorEnvelope>

  /// Fetch the newest data for a particular project.
  func fetchProject(project: Project) -> SignalProducer<Project, ErrorEnvelope>

  /// Fetch a batch of projects with the specified discovery params.
  func fetchProjects(params: DiscoveryParams) -> SignalProducer<[Project], ErrorEnvelope>

  /// Fetch the newest data for a particular user.
  func fetchUser(user: User) -> SignalProducer<User, ErrorEnvelope>

  /// Fetch the logged-in user's data.
  func fetchUserSelf() -> SignalProducer<User, ErrorEnvelope>

  /// Attempt a login with an email, password and optional code.
  func login(email email: String, password: String, code: String?) ->
    SignalProducer<AccessTokenEnvelope, ErrorEnvelope>

  /// Attempt a login with Facebook access token and optional code.
  func login(facebookAccessToken facebookAccessToken: String, code: String?) ->
    SignalProducer<AccessTokenEnvelope, ErrorEnvelope>

  func postComment(body: String, toProject project: Project) -> SignalProducer<Comment, ErrorEnvelope>

  /// Reset user password with email address.
  func resetPassword(email email: String) -> SignalProducer<User, ErrorEnvelope>

  /// Signup with Facebook access token and newsletter bool.
  func signup(facebookAccessToken facebookAccessToken: String, sendNewsletters: Bool) ->
    SignalProducer<AccessTokenEnvelope, ErrorEnvelope>

  /// Star a project.
  func star(project: Project) -> SignalProducer<Project, ErrorEnvelope>

  /// Toggle the starred state on a project.
  func toggleStar(project: Project) -> SignalProducer<Project, ErrorEnvelope>
}

extension ServiceType {
  /// Returns `true` if an oauth token is present, and `false` otherwise.
  public var isAuthenticated: Bool {
    return self.oauthToken != nil
  }
}

public func == (lhs: ServiceType, rhs: ServiceType) -> Bool {
  return
    lhs.dynamicType == rhs.dynamicType &&
      lhs.serverConfig == rhs.serverConfig &&
      lhs.oauthToken == rhs.oauthToken &&
      lhs.language == rhs.language
}

public func != (lhs: ServiceType, rhs: ServiceType) -> Bool {
  return !(lhs == rhs)
}
