/**
 A type that can provide oauth token authentication, i.e. a user's personal token.
*/
public protocol OauthTokenAuthType {
  var token: String { get }
}

public func == (lhs: OauthTokenAuthType, rhs: OauthTokenAuthType) -> Bool {
  return lhs.dynamicType == rhs.dynamicType &&
    lhs.token == rhs.token
}

public func == (lhs: OauthTokenAuthType?, rhs: OauthTokenAuthType?) -> Bool {
  return lhs?.dynamicType == rhs?.dynamicType &&
    lhs?.token == rhs?.token
}

public struct OauthToken: OauthTokenAuthType {
  public let token: String

  public init(token: String) {
    self.token = token
  }
}
