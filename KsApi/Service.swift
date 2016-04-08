import Alamofire
import Models
import ReactiveCocoa

/**
 A `ServerType` that requests data from an API webservice.
*/
public struct Service: ServiceType {
  public static let shared = Service()

  public let serverConfig: ServerConfigType
  public let oauthToken: OauthTokenAuthType?
  public let language: String

  public init(serverConfig: ServerConfigType = ServerConfig.production,
              oauthToken: OauthTokenAuthType? = nil,
              language: String = "en") {

    self.serverConfig = serverConfig
    self.oauthToken = oauthToken
    self.language = language
  }

  public func login(oauthToken: OauthTokenAuthType) -> Service {
    return Service(serverConfig: self.serverConfig, oauthToken: oauthToken, language: self.language)
  }

  public func logout() -> Service {
    return Service(serverConfig: self.serverConfig, oauthToken: nil, language: self.language)
  }

  public func fetchActivities() -> SignalProducer<ActivityEnvelope, ErrorEnvelope> {
    let categories = [
      Activity.Category.Backing,
      Activity.Category.Cancellation,
      Activity.Category.Failure,
      Activity.Category.Follow,
      Activity.Category.Launch,
      Activity.Category.Success,
      Activity.Category.Update,
    ]
    return request(.Activities(categories: categories))
      .decodeModel(ActivityEnvelope.self)
  }

  public func fetchComments(project project: Project) -> SignalProducer<CommentsEnvelope, ErrorEnvelope> {
    return request(.ProjectComments(project))
      .decodeModel(CommentsEnvelope.self)
  }

  public func fetchDiscovery(params: DiscoveryParams) -> SignalProducer<DiscoveryEnvelope, ErrorEnvelope> {
    return request(.Discover(params))
      .decodeModel(DiscoveryEnvelope.self)
  }

  public func fetchProjects(params: DiscoveryParams) -> SignalProducer<[Project], ErrorEnvelope> {
    return fetchDiscovery(params)
      .map { env in env.projects }
  }

  public func fetchProject(params: DiscoveryParams) -> SignalProducer<Project, ErrorEnvelope> {
    return request(.Discover(params.with(perPage: 1)))
      .decodeModel(DiscoveryEnvelope.self)
      .map { envelope in envelope.projects.first }
      .ignoreNil()
  }

  public func fetchProject(project: Project) -> SignalProducer<Project, ErrorEnvelope> {
    return request(.Project(project))
      .decodeModel(Project.self)
  }

  public func fetchUserSelf() -> SignalProducer<User, ErrorEnvelope> {
    return request(.UserSelf)
      .decodeModel(User.self)
  }

  public func fetchUser(user: User) -> SignalProducer<User, ErrorEnvelope> {
    return request(.User(user))
      .decodeModel(User.self)
  }

  public func fetchCategories() -> SignalProducer<[Models.Category], ErrorEnvelope> {
    return request(.Categories)
      .decodeModel(CategoriesEnvelope.self)
      .map { envelope in envelope.categories }
  }

  public func fetchCategory(category: Models.Category) -> SignalProducer<Models.Category, ErrorEnvelope> {
    return request(.Category(category))
      .decodeModel(Models.Category.self)
  }

  public func toggleStar(project: Project) -> SignalProducer<Project, ErrorEnvelope> {
    return request(.ToggleStar(project))
      .decodeModel(StarEnvelope.self)
      .map { envelope in envelope.project }
  }

  public func star(project: Project) -> SignalProducer<Project, ErrorEnvelope> {
    return request(.Star(project))
      .decodeModel(StarEnvelope.self)
      .map { envelope in envelope.project }
  }

  public func login(email email: String, password: String, code: String?) ->
    SignalProducer<AccessTokenEnvelope, ErrorEnvelope> {

    return request(.Login(email: email, password: password, code: code))
      .decodeModel(AccessTokenEnvelope.self)
  }

  public func login(facebookAccessToken facebookAccessToken: String, code: String?) ->
    SignalProducer<AccessTokenEnvelope, ErrorEnvelope> {

    return request(.FacebookLogin(facebookAccessToken: facebookAccessToken, code: code))
      .decodeModel(AccessTokenEnvelope.self)
  }

  public func postComment(body: String, toProject project: Project) ->
    SignalProducer<Comment, ErrorEnvelope> {

    return request(.PostProjectComment(project, body: body))
      .decodeModel(Comment.self)
  }

  public func resetPassword(email email: String) -> SignalProducer<User, ErrorEnvelope> {
    return request(.ResetPassword(email: email))
      .decodeModel(User.self)
  }

  public func signup(facebookAccessToken token: String, sendNewsletters: Bool) ->
    SignalProducer<AccessTokenEnvelope, ErrorEnvelope> {

    return request(.FacebookSignup(facebookAccessToken: token, sendNewsletters: sendNewsletters))
      .decodeModel(AccessTokenEnvelope.self)
  }

  // MARK: Private methods

  private func request(route: Route) -> Alamofire.Request {
    return Alamofire.request(self.requestFromRoute(route))
      .validate(statusCode: 200..<300)
      .validate(contentType: ["application/json"])
  }

  // Converts a `Route` into a URL request that can be used with Alamofire.
  private func requestFromRoute(route: Route) -> URLRequestConvertible {
    let properties = route.requestProperties

    let URL = self.serverConfig.apiBaseUrl.URLByAppendingPathComponent(properties.path)
    let request = NSMutableURLRequest(URL: URL)
    request.HTTPMethod = properties.method.rawValue

    // Add some query params for authentication et al
    var query = properties.query
    query["client_id"] = self.serverConfig.apiClientAuth.clientId
    if let token = self.oauthToken?.token {
      query["oauth_token"] = token
    }

    // Add some headers
    var headers = request.allHTTPHeaderFields ?? [:]
    headers["Authorization"] = self.serverConfig.basicHTTPAuth?.authorizationHeader
    headers["Accept-Language"] = self.language
    headers["Kickstarter-iOS-App"] = "9999" // TODO: make this a dependency
    request.allHTTPHeaderFields = headers

    let (retRequest, _) = Alamofire.ParameterEncoding.URL.encode(request, parameters: query)

    return retRequest
  }
}
