import Argo
import Curry
import Runes

public enum ApiError: Error {
  case argoError(jsonString: String?, DecodeError)
  case gqlError(GQLError)
  case invalidJson(responseString: String?)
  case requestError(Error)
}

public struct GQLError: Error, Decodable {
  let errors: [Error]
  
  public static func decode(_ json: JSON) -> Decoded<GQLError> {
    return pure(GQLError.init)
      <*> json <|| "errors"
  }
  
  public struct Error: Decodable {
    let message: String
    let locations: [Location]
    let fields: [String]
    let path: [String]
    
    public static func decode(_ json: JSON) -> Decoded<GQLError.Error> {
      return pure(curry(Error.init))
        <*> json <| "message"
        <*> json <|| "locations"
        <*> (json <|| "fields" <|> .success([]))
        <*> (json <|| "path" <|> .success([]))
    }
    
    public struct Location: Decodable {
      let column: Int
      let line: Int
      
      public static func decode(_ json: JSON) -> Decoded<GQLError.Error.Location> {
        return pure(curry(Location.init))
          <*> json <| "column"
          <*> json <| "line"
      }
    }
  }
}
