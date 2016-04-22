import Foundation
import Alamofire
import Models
import ReactiveCocoa

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
    self.buildVersion = buildVersion
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

  public func fetchActivities() -> SignalProducer<ActivityEnvelope, ErrorEnvelope> {
    let categories: [Activity.Category] = [
      .Backing,
      .Cancellation,
      .Failure,
      .Follow,
      .Launch,
      .Success,
      .Update,
    ]
    return request(.Activities(categories: categories))
      .decodeModel(ActivityEnvelope.self)
  }

  public func fetchActivities(paginationUrl paginationUrl: String)
    -> SignalProducer<ActivityEnvelope, ErrorEnvelope> {
      return requestPagination(paginationUrl)
        .decodeModel(ActivityEnvelope.self)
  }

  public func fetchComments(project project: Project) -> SignalProducer<CommentsEnvelope, ErrorEnvelope> {
    return request(.ProjectComments(project))
      .decodeModel(CommentsEnvelope.self)
  }

  public func fetchConfig() -> SignalProducer<Config, ErrorEnvelope> {
    return request(.Config)
      .decodeModel(Config.self)
  }

  public func fetchDiscovery(paginationUrl paginationUrl: String)
    -> SignalProducer<DiscoveryEnvelope, ErrorEnvelope> {

    return requestPagination(paginationUrl)
      .decodeModel(DiscoveryEnvelope.self)
  }

  public func fetchDiscovery(params params: DiscoveryParams)
    -> SignalProducer<DiscoveryEnvelope, ErrorEnvelope> {

    return request(.Discover(params))
      .decodeModel(DiscoveryEnvelope.self)
  }

  public func fetchProjects(params: DiscoveryParams) -> SignalProducer<[Project], ErrorEnvelope> {
    return fetchDiscovery(params: params)
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

  private func requestPagination(paginationUrl: String) -> Alamofire.Request {
    return Alamofire.request(self.paginationRequest(paginationUrl))
      .validate(statusCode: 200..<300)
      .validate(contentType: ["application/json"])
  }

  private func request(route: Route) -> Alamofire.Request {
    return Alamofire.request(self.urlRequest(route))
      .validate(statusCode: 200..<300)
      .validate(contentType: ["application/json"])
  }

  private func paginationRequest(paginationUrl: String) -> URLRequestConvertible {

    // swiftlint:disable force_cast
    // NB: instead of force cast we could bubble up a custom ErrorEnvelope error.
    return NSURL(string: paginationUrl)
      .flatMap(NSMutableURLRequest.init(URL:))
      .flatMap { preparedRequest($0) } as! NSURLRequest
    // swiftlint:enable force_cast
  }

  // Converts a `Route` into a URL request that can be used with Alamofire.
  private func urlRequest(route: Route) -> URLRequestConvertible {
    let properties = route.requestProperties

    let URL = self.serverConfig.apiBaseUrl.URLByAppendingPathComponent(properties.path)
    let request = NSMutableURLRequest(URL: URL)
    request.HTTPMethod = properties.method.rawValue

    return preparedRequest(request, query: properties.query)
  }

  private func preparedRequest(request: NSURLRequest, query: [String:AnyObject] = [:])
    -> URLRequestConvertible {
    guard let requestCopy = request.mutableCopy() as? NSMutableURLRequest else {
      // NB: instead of fatal error we could bubble up a custom ErrorEnvelope error.
      fatalError()
    }

    // Add some query params for authentication et al
    var query = query
    query["client_id"] = self.serverConfig.apiClientAuth.clientId
    query["oauth_token"] = self.oauthToken?.token

    // Add some headers
    var headers = request.URLRequest.allHTTPHeaderFields ?? [:]
    headers["Authorization"] = self.serverConfig.basicHTTPAuth?.authorizationHeader
    headers["Accept-Language"] = self.language
    headers["Kickstarter-iOS-App"] = self.buildVersion
    requestCopy.allHTTPHeaderFields = headers

    let (retRequest, _) = Alamofire.ParameterEncoding.URL.encode(requestCopy, parameters: query)

    return retRequest
  }
}
