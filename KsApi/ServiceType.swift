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

  /// Attempt a login with an email and password.
  func login(email email: String, password: String) -> SignalProducer<AccessTokenEnvelope, ErrorEnvelope>
}
