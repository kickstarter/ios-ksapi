import Argo
import func Curry.curry

public struct ErrorEnvelope {
  public let errorMessages: [String]
  public let ksrCode: KsrCode?
  public let httpCode: Int
  public let exception: Exception?
  public let facebookUser: FacebookUser?

  public init(errorMessages: [String], ksrCode: KsrCode?, httpCode: Int, exception: Exception?,
              facebookUser: FacebookUser? = nil) {
    self.errorMessages = errorMessages
    self.ksrCode = ksrCode
    self.httpCode = httpCode
    self.exception = exception
    self.facebookUser = facebookUser
  }

  public enum KsrCode: String {
    // Codes defined by the server
    case AccessTokenInvalid = "access_token_invalid"
    case ConfirmFacebookSignup = "confirm_facebook_signup"
    case FacebookInvalidAccessToken = "facebook_invalid_access_token"
    case InvalidXauthLogin = "invalid_xauth_login"
    case MissingFacebookEmail = "missing_facebook_email"
    case TfaFailed = "tfa_failed"
    case TfaRequired = "tfa_required"

    // Catch all code for when server sends code we don't know about yet
    case UnknownCode = "__internal_unknown_code"

    // Codes defined by the client
    case JSONParsingFailed = "json_parsing_failed"
    case ErrorEnvelopeJSONParsingFailed = "error_json_parsing_failed"
    case DecodingJSONFailed = "decoding_json_failed"
  }

  public struct Exception {
    public let backtrace: [String]?
    public let message: String?
  }

  public struct FacebookUser {
    public let id: Int64
    public let name: String
    public let email: String
  }

  /**
   A general error that JSON could not be parsed.
  */
  internal static var couldNotParseJSON: ErrorEnvelope {
    return ErrorEnvelope(
      errorMessages: [],
      ksrCode: .JSONParsingFailed,
      httpCode: 400,
      exception: nil,
      facebookUser: nil
    )
  }

  /**
   A general error that the error envelope JSON could not be parsed.
  */
  internal static var couldNotParseErrorEnvelopeJSON: ErrorEnvelope {
    return ErrorEnvelope(
      errorMessages: [],
      ksrCode: .ErrorEnvelopeJSONParsingFailed,
      httpCode: 400,
      exception: nil,
      facebookUser: nil
    )
  }

  /**
   A general error that some JSON could not be decoded.

   - parameter decodeError: The Argo decoding error.

   - returns: An error envelope that describes why decoding failed.
   */
  internal static func couldNotDecodeJSON(decodeError: DecodeError) -> ErrorEnvelope {
    return ErrorEnvelope(
      errorMessages: ["Argo decoding error: \(decodeError.description)"],
      ksrCode: .DecodingJSONFailed,
      httpCode: 400,
      exception: nil,
      facebookUser: nil
    )
  }
}

extension ErrorEnvelope: ErrorType {
}

extension ErrorEnvelope: Decodable {
  public static func decode(json: JSON) -> Decoded<ErrorEnvelope> {
    return curry(ErrorEnvelope.init)
      <^> json <|| "error_messages"
      <*> json <|? "ksr_code"
      <*> json <| "http_code"
      <*> json <|? "exception"
      <*> json <|? "facebook_user"
  }
}

extension ErrorEnvelope.Exception: Decodable {
  public static func decode(json: JSON) -> Decoded<ErrorEnvelope.Exception> {
    return curry(ErrorEnvelope.Exception.init)
      <^> json <||? "backtrace"
      <*> json <|? "message"
  }
}

extension ErrorEnvelope.KsrCode: Decodable {
  public static func decode(j: JSON) -> Decoded<ErrorEnvelope.KsrCode> {
    switch j {
    case let .String(s):
      return pure(ErrorEnvelope.KsrCode(rawValue: s) ?? ErrorEnvelope.KsrCode.UnknownCode)
    default:
      return .typeMismatch("ErrorEnvelope.KsrCode", actual: j)
    }
  }
}

extension ErrorEnvelope.FacebookUser: Decodable {
  public static func decode(json: JSON) -> Decoded<ErrorEnvelope.FacebookUser> {
    return curry(ErrorEnvelope.FacebookUser.init)
      <^> json <| "id"
      <*> json <| "name"
      <*> json <| "email"
  }
}
