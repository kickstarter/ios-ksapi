@testable import KsApi
@testable import Models
@testable import Models_TestHelpers
import ReactiveCocoa

internal struct MockService : ServiceType {

  internal let serverConfig: ServerConfigType
  internal let oauthToken: OauthTokenAuthType?
  internal let language: String

  private let activities: [Activity]

  internal init(serverConfig: ServerConfigType = ServerConfig.production,
                oauthToken: OauthTokenAuthType? = nil,
                language: String = "en") {

    self.init(
      serverConfig: serverConfig,
      oauthToken: oauthToken,
      language: language,
      activities: [
        ActivityFactory.updateActivity,
        ActivityFactory.backingActivity,
        ActivityFactory.successActivity
      ]
    )
  }

  internal init(serverConfig: ServerConfigType = ServerConfig.production,
                oauthToken: OauthTokenAuthType? = nil,
                language: String = "en",
                activities: [Activity]) {

    self.serverConfig = serverConfig
    self.oauthToken = oauthToken
    self.language = language

    self.activities = activities
  }

  internal func login(oauthToken: OauthTokenAuthType) -> MockService {
    return MockService(
      serverConfig: self.serverConfig,
      oauthToken: oauthToken,
      language: self.language,
      activities: self.activities
    )
  }

  internal func logout() -> MockService {
    return MockService(
      serverConfig: self.serverConfig,
      oauthToken: nil,
      language: self.language,
      activities: self.activities
    )
  }

  internal func fetchActivities() -> SignalProducer<ActivityEnvelope, ErrorEnvelope> {
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

    return SignalProducer(value:
      ActivityEnvelope(
        activities: self.activities,
        urls: ActivityEnvelope.UrlsEnvelope(
          api: ActivityEnvelope.UrlsEnvelope.ApiEnvelope(
            moreActivities: ""
          )
        )
      )
    )
  }

  internal func fetchDiscovery(params: DiscoveryParams) -> SignalProducer<DiscoveryEnvelope, ErrorEnvelope> {

    let projects = (1...10).map { ProjectFactory.live(id: $0 + params.hashValue) }

    return SignalProducer(value:
      DiscoveryEnvelope(
        projects: projects,
        urls: DiscoveryEnvelope.UrlsEnvelope(
          api: DiscoveryEnvelope.UrlsEnvelope.ApiEnvelope(
            more_projects: ""
          )
        ),
        stats: DiscoveryEnvelope.StatsEnvelope(
          count: 200
        )
      )
    )
  }

  internal func fetchProjects(params: DiscoveryParams) -> SignalProducer<[Project], ErrorEnvelope> {
    return fetchDiscovery(params)
      .map { $0.projects }
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

    return SignalProducer(value: UserFactory.user)
  }

  internal func fetchUser(user: User) -> SignalProducer<User, ErrorEnvelope> {
    return SignalProducer(value: user)
  }

  internal func fetchCategories() -> SignalProducer<[Models.Category], ErrorEnvelope> {

    return SignalProducer(value: [
      CategoryFactor.art,
      CategoryFactor.comics,
      CategoryFactor.illustration,
      ]
    )
  }

  internal func fetchCategory(category: Models.Category) -> SignalProducer<Models.Category, ErrorEnvelope> {
    return SignalProducer(value: category)
  }

  internal func toggleStar(project: Project) -> SignalProducer<Project, ErrorEnvelope> {
    return .init(value: project.isStarred == true ? ProjectFactory.notStarred : ProjectFactory.starred)
  }

  internal func star(project: Project) -> SignalProducer<Project, ErrorEnvelope> {
    return .init(value: ProjectFactory.starred)
  }

  internal func login(email email: String, password: String, code: String?) -> SignalProducer<AccessTokenEnvelope, ErrorEnvelope> {

    return SignalProducer(value:
      AccessTokenEnvelope(
        access_token: "deadbeef",
        user: UserFactory.user
      )
    )
  }

  internal func login(facebookAccessToken facebookAccessToken: String, code: String?) -> SignalProducer<AccessTokenEnvelope, ErrorEnvelope> {

    return SignalProducer(value:
      AccessTokenEnvelope(
        access_token: "deadbeef",
        user: UserFactory.user
      )
    )
  }

  func resetPassword(email email: String) -> SignalProducer<User, ErrorEnvelope> {
    return SignalProducer(value: UserFactory.user)
  }

  func signup(facebookAccessToken facebookAccessToken: String, sendNewsletters: Bool) -> SignalProducer<AccessTokenEnvelope, ErrorEnvelope> {

    return SignalProducer(value:
      AccessTokenEnvelope(
        access_token: "deadbeef",
        user: UserFactory.user
      )
    )
  }

}
