import struct Models.Activity
import struct Models.Category
import struct Models.Project
import struct Models.User
import struct ReactiveCocoa.SignalProducer

/**
 A type that knows how to perform requests for Kickstarter data.
*/
public protocol ServiceType {
  var serverConfig: ServerConfigType { get }
  var oauthToken: OauthTokenAuthType? { get }
  var language: String { get }

  /**
   Fetch a page of activities.

   - returns: A product of an activity envelope.
   */
  func fetchActivities() -> SignalProducer<ActivityEnvelope, ErrorEnvelope>

  /// Fetch the full discovery envelope with specified discovery params.
  func fetchDiscovery(params: DiscoveryParams) -> SignalProducer<DiscoveryEnvelope, ErrorEnvelope>

  /// Fetch a batch of projects with the specified discovery params.
  func fetchProjects(params: DiscoveryParams) -> SignalProducer<[Project], ErrorEnvelope>

  /// Fetch a single project with the specified discovery params.
  func fetchProject(params: DiscoveryParams) -> SignalProducer<Project, ErrorEnvelope>

  /// Fetch the newest data for a particular project.
  func fetchProject(project: Project) -> SignalProducer<Project, ErrorEnvelope>

  /// Fetch the logged-in user's data.
  func fetchUserSelf() -> SignalProducer<User, ErrorEnvelope>

  /// Fetch the newest data for a particular user.
  func fetchUser(user: User) -> SignalProducer<User, ErrorEnvelope>

  /// Fetch all categories.
  func fetchCategories() -> SignalProducer<[Models.Category], ErrorEnvelope>

  /// Fetch the newest data for a particular category.
  func fetchCategory(category: Models.Category) -> SignalProducer<Models.Category, ErrorEnvelope>

  /// Toggle the starred state on a project.
  func toggleStar(project: Project) -> SignalProducer<Project, ErrorEnvelope>

  /// Star a project.
  func star(project: Project) -> SignalProducer<Project, ErrorEnvelope>

  /// Attempt a login with an email and password and optional code.
  func login(email email: String, password: String, code: String?) -> SignalProducer<AccessTokenEnvelope, ErrorEnvelope>

  /// Attempt a login with Facebook access token and optional code.
  func login(facebookAccessToken facebookAccessToken: String, code: String?) -> SignalProducer<AccessTokenEnvelope, ErrorEnvelope>

  /// Reset user password with email address.
  func resetPassword(email email: String) -> SignalProducer<User, ErrorEnvelope>

  /// Signup with Facebook access token and newsletters bool.
  func signup(facebookAccessToken facebookAccessToken: String, sendNewsletters: Bool) -> SignalProducer<AccessTokenEnvelope, ErrorEnvelope>
}
