/**
 A type that holds an API client id, which provides anonymous authentication to the API.
*/
public protocol ClientAuthType {
  var clientId: String { get }
}

public struct ClientAuth : ClientAuthType {
  public let clientId: String

  public static let production: ClientAuthType = ClientAuth(
    clientId: "***REMOVED***"
  )

  public static let development: ClientAuthType = ClientAuth(
    clientId: "***REMOVED***"
  )
}
