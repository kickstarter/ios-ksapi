/**
 A type that knows the location of a Kickstarter API and web server.
*/
public protocol ServerConfigType {
  var apiBaseUrl: NSURL { get }
  var webBaseUrl: NSURL { get }
  var apiClientAuth: ClientAuthType { get }
  var basicHTTPAuth: BasicHTTPAuthType? { get }
}

public func == (lhs: ServerConfigType, rhs: ServerConfigType) -> Bool {
  return
    lhs.dynamicType == rhs.dynamicType &&
    lhs.apiBaseUrl == rhs.apiBaseUrl &&
    lhs.webBaseUrl == rhs.webBaseUrl &&
    lhs.apiClientAuth == rhs.apiClientAuth &&
    lhs.basicHTTPAuth == rhs.basicHTTPAuth
}

public struct ServerConfig: ServerConfigType {
  public let apiBaseUrl: NSURL
  public let webBaseUrl: NSURL
  public let apiClientAuth: ClientAuthType
  public let basicHTTPAuth: BasicHTTPAuthType?

  public static let production: ServerConfigType = ServerConfig(
    apiBaseUrl: NSURL(string: "https://***REMOVED***")!,
    webBaseUrl: NSURL(string: "https://www.kickstarter.com")!,
    apiClientAuth: ClientAuth.production,
    basicHTTPAuth: nil
  )

  public static let staging: ServerConfigType = ServerConfig(
    apiBaseUrl: NSURL(string: "https://***REMOVED***")!,
    webBaseUrl: NSURL(string: "https://***REMOVED***")!,
    apiClientAuth: ClientAuth.development,
    basicHTTPAuth: BasicHTTPAuth.development
  )

  public static let local: ServerConfigType = ServerConfig(
    apiBaseUrl: NSURL(string: "http://api.ksr.dev")!,
    webBaseUrl: NSURL(string: "http://ksr.dev")!,
    apiClientAuth: ClientAuth.development,
    basicHTTPAuth: BasicHTTPAuth.development
  )

  public init(apiBaseUrl: NSURL,
              webBaseUrl: NSURL,
              apiClientAuth: ClientAuthType,
              basicHTTPAuth: BasicHTTPAuthType?) {

    self.apiBaseUrl = apiBaseUrl
    self.webBaseUrl = webBaseUrl
    self.apiClientAuth = apiClientAuth
    self.basicHTTPAuth = basicHTTPAuth
  }
}
