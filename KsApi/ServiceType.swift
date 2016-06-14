import ReactiveCocoa

public enum Mailbox: String {
  case inbox
  case sent
}

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

  /// Fetches the current user's backing for the project, if it exists.
  func fetchBacking(forProject project: Project, forUser user: User)
    -> SignalProducer<Backing, ErrorEnvelope>

  /// Fetch all categories.
  func fetchCategories() -> SignalProducer<CategoriesEnvelope, ErrorEnvelope>

  /// Fetch the newest data for a particular category.
  func fetchCategory(id id: Int) -> SignalProducer<Category, ErrorEnvelope>

  /// Fetch comments from a pagination url.
  func fetchComments(paginationUrl url: String) -> SignalProducer<CommentsEnvelope, ErrorEnvelope>

  /// Fetch comments for a project.
  func fetchComments(project project: Project) -> SignalProducer<CommentsEnvelope, ErrorEnvelope>

  /// Fetch comments for an update.
  func fetchComments(update update: Update) -> SignalProducer<CommentsEnvelope, ErrorEnvelope>

  /// Fetch the config.
  func fetchConfig() -> SignalProducer<Config, ErrorEnvelope>

  /// Fetch discovery envelope with a pagination url.
  func fetchDiscovery(paginationUrl paginationUrl: String) -> SignalProducer<DiscoveryEnvelope, ErrorEnvelope>

  /// Fetch the full discovery envelope with specified discovery params.
  func fetchDiscovery(params params: DiscoveryParams) -> SignalProducer<DiscoveryEnvelope, ErrorEnvelope>

  /// Fetches all of the messages in a particular message thread.
  func fetchMessageThread(messageThread messageThread: MessageThread)
    -> SignalProducer<MessageThreadEnvelope, ErrorEnvelope>

  /// Fetches all of the messages related to a particular backing.
  func fetchMessageThread(backing backing: Backing) -> SignalProducer<MessageThreadEnvelope, ErrorEnvelope>

  /// Fetches all of the messages in a particular mailbox and specific to a particular project.
  func fetchMessageThreads(mailbox mailbox: Mailbox, project: Project?)
    -> SignalProducer<MessageThreadsEnvelope, ErrorEnvelope>

  /// Fetches more messages threads from a pagination URL.
  func fetchMessageThreads(paginationUrl paginationUrl: String)
    -> SignalProducer<MessageThreadsEnvelope, ErrorEnvelope>

  /// Fetch the newest data for a particular project from its id.
  func fetchProject(id id: Int) -> SignalProducer<Project, ErrorEnvelope>

  /// Fetch a single project with the specified discovery params.
  func fetchProject(params: DiscoveryParams) -> SignalProducer<DiscoveryEnvelope, ErrorEnvelope>

  /// Fetch the newest data for a particular project from its project value.
  func fetchProject(project project: Project) -> SignalProducer<Project, ErrorEnvelope>

  /// Fetch the user's project notifications.
  func fetchProjectNotifications() -> SignalProducer<[ProjectNotification], ErrorEnvelope>

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

  /// Marks all the messages in a particular thread as read.
  func markAsRead(messageThread messageThread: MessageThread) -> SignalProducer<MessageThread, ErrorEnvelope>

  /// Posts a comment to a project.
  func postComment(body: String, toProject project: Project) -> SignalProducer<Comment, ErrorEnvelope>

  /// Posts a comment to an update.
  func postComment(body: String, toUpdate update: Update) -> SignalProducer<Comment, ErrorEnvelope>

  /// Reset user password with email address.
  func resetPassword(email email: String) -> SignalProducer<User, ErrorEnvelope>

  /// Searches all of the messages, (optionally) bucketed to a specific project.
  func searchMessages(query query: String, project: Project?)
    -> SignalProducer<MessageThreadsEnvelope, ErrorEnvelope>

  /// Sends a message to a particular thread.
  func sendMessage(body body: String, toThread messageThread: MessageThread)
    -> SignalProducer<Message, ErrorEnvelope>

  /// Signup with email.
  func signup(name name: String, email: String, password: String, passwordConfirmation: String,
                   sendNewsletters: Bool) -> SignalProducer<AccessTokenEnvelope, ErrorEnvelope>

  /// Signup with Facebook access token and newsletter bool.
  func signup(facebookAccessToken facebookAccessToken: String, sendNewsletters: Bool) ->
    SignalProducer<AccessTokenEnvelope, ErrorEnvelope>

  /// Star a project.
  func star(project: Project) -> SignalProducer<StarEnvelope, ErrorEnvelope>

  /// Toggle the starred state on a project.
  func toggleStar(project: Project) -> SignalProducer<StarEnvelope, ErrorEnvelope>

  /// Update the project notification setting.
  func updateProjectNotification(notification: ProjectNotification) ->
    SignalProducer<ProjectNotification, ErrorEnvelope>

  /// Update the current user with settings attributes.
  func updateUserSelf(user: User) -> SignalProducer<User, ErrorEnvelope>
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
      lhs.language == rhs.language &&
      lhs.buildVersion == rhs.buildVersion
}

public func != (lhs: ServiceType, rhs: ServiceType) -> Bool {
  return !(lhs == rhs)
}
