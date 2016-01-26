/**
 A type that understands basic HTTP authentication: username and password.
*/
public protocol BasicHTTPAuthType {
  var username: String { get }
  var password: String { get }
}

extension BasicHTTPAuthType {
  /**
   Contents of the `Authorization` header needed to perform basic HTTP auth.
  */
  var authorizationHeader: String? {
    let string = "\(username):\(password)"
    if let data = string.dataUsingEncoding(NSUTF8StringEncoding) {
      let base64 = data.base64EncodedStringWithOptions(.Encoding64CharacterLineLength)
      return "Basic \(base64)"
    }
    return nil
  }
}

public struct BasicHTTPAuth : BasicHTTPAuthType {
  public let username: String
  public let password: String

  public static let development: BasicHTTPAuthType = BasicHTTPAuth(
    username: "***REMOVED***",
    password: "***REMOVED***"
  )

  public init(username: String, password: String) {
    self.username = username
    self.password = password
  }
}
