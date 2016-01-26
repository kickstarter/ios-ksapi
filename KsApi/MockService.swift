import ReactiveCocoa
import Models

/**
 A `ServerType` that gets data from locally stored JSON files.
*/
public struct MockService : ServiceType {
  public let serverConfig: ServerConfigType = ServerConfig(devEnv: "test")
  public let oauthToken: OauthTokenAuthType? = nil
  public let language = "en"

  public init() {
  }

  public func loadJSON(fileName: String) -> [String:AnyObject] {
    return NSBundle.mainBundle().pathForResource(fileName, ofType: "json")
      .flatMap { path -> NSString? in
        do {
          let string = try NSString(contentsOfFile: path, encoding: NSUTF8StringEncoding)
          return string
        } catch {
          return nil
        }
      }
      .flatMap { $0.dataUsingEncoding(NSUTF8StringEncoding) }
      .flatMap { data -> [String:AnyObject]? in
        do {
          let json = try NSJSONSerialization.JSONObjectWithData(data, options: [])
          return json as? [String:AnyObject]
        } catch {
          return nil
        }
      }!
  }

  public func fetchDiscovery(params: DiscoveryParams) -> SignalProducer<DiscoveryEnvelope, ErrorEnvelope> {

    let json = loadJSON("discover")
    let env = DiscoveryEnvelope.decodeJSONDictionary(json)!
    return SignalProducer(value: env)
  }

  public func fetchProjects(params: DiscoveryParams) -> SignalProducer<[Project], ErrorEnvelope> {
    return fetchDiscovery(params).map { $0.projects }
  }

  public func fetchProject(params: DiscoveryParams) -> SignalProducer<Project, ErrorEnvelope> {
    return fetchDiscovery(params).flatMap { $0.projects.first }
  }

  public func fetchProject(project: Project) -> SignalProducer<Project, ErrorEnvelope> {
    return SignalProducer(value: project)
  }

  public func fetchUserSelf() -> SignalProducer<User, ErrorEnvelope> {
    return .empty
  }

  public func fetchUser(user: User) -> SignalProducer<User, ErrorEnvelope> {
    return .empty
  }

  public func fetchCategories() -> SignalProducer<[Models.Category], ErrorEnvelope> {

    let json = loadJSON("categories")
    let env = CategoriesEnvelope.decodeJSONDictionary(json)!
    return SignalProducer(value: env.categories)
  }

  public func fetchCategory(category: Models.Category) -> SignalProducer<Models.Category, ErrorEnvelope> {
    return .empty
  }

  public func toggleStar(project: Project) -> SignalProducer<Project, ErrorEnvelope> {
    return .empty
  }

  public func star(project: Project) -> SignalProducer<Project, ErrorEnvelope> {
    return .empty
  }

  public func login(email email: String, password: String) -> SignalProducer<AccessTokenEnvelope, ErrorEnvelope> {
    return .empty
  }
}
