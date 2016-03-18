import struct Models.Category
import struct Models.Project
import struct Models.User
import struct ReactiveCocoa.SignalProducer
import func Darwin.srand48
import func Darwin.rand

private func fileContentsAtPath(path: String) -> NSString? {
  return try? NSString(contentsOfFile: path, encoding: NSUTF8StringEncoding)
}

/**
 A `ServerType` that gets data from locally stored JSON files.
*/
internal struct MockService : ServiceType {
  internal let serverConfig: ServerConfigType = ServerConfig(devEnv: "test")
  internal let oauthToken: OauthTokenAuthType? = nil
  internal let language = "en"

  internal init() {
  }

  private func loadJSON(fileName: String) -> [String:AnyObject] {
    return NSBundle.mainBundle().pathForResource(fileName, ofType: "json")
      .flatMap(fileContentsAtPath)
      .flatMap { $0.dataUsingEncoding(NSUTF8StringEncoding) }
      .flatMap(parseJSONData)
      .flatMap { $0 as? [String:AnyObject] }
      ?? [:]
  }

  internal func fetchActivities() -> SignalProducer<ActivityEnvelope, ErrorEnvelope> {
    return .empty
  }

  internal func fetchDiscovery(params: DiscoveryParams) -> SignalProducer<DiscoveryEnvelope, ErrorEnvelope> {

    let json = loadJSON("discover")
    let env = DiscoveryEnvelope.decodeJSONDictionary(json)!
    return SignalProducer(value: env)
  }

  internal func fetchProjects(params: DiscoveryParams) -> SignalProducer<[Project], ErrorEnvelope> {

    srand48(params.hashValue)
    return fetchDiscovery(params)
      .map { $0.projects }
      .map { $0.sort { _, _ in rand() % 2 == 0 } }
  }

  internal func fetchProject(params: DiscoveryParams) -> SignalProducer<Project, ErrorEnvelope> {
    return fetchDiscovery(params)
      .map { $0.projects.first }
      .ignoreNil()
  }

  internal func fetchProject(project: Project) -> SignalProducer<Project, ErrorEnvelope> {
    return SignalProducer(value: project)
  }

  internal func fetchUserSelf() -> SignalProducer<User, ErrorEnvelope> {
    return .empty
  }

  internal func fetchUser(user: User) -> SignalProducer<User, ErrorEnvelope> {
    return .empty
  }

  internal func fetchCategories() -> SignalProducer<[Models.Category], ErrorEnvelope> {

    let json = loadJSON("categories")
    let env = CategoriesEnvelope.decodeJSONDictionary(json)!
    return SignalProducer(value: env.categories)
  }

  internal func fetchCategory(category: Models.Category) -> SignalProducer<Models.Category, ErrorEnvelope> {
    return .empty
  }

  internal func toggleStar(project: Project) -> SignalProducer<Project, ErrorEnvelope> {
    return .empty
  }

  internal func star(project: Project) -> SignalProducer<Project, ErrorEnvelope> {
    return .empty
  }

  internal func login(email email: String, password: String) -> SignalProducer<AccessTokenEnvelope, ErrorEnvelope> {
    return .empty
  }
}
