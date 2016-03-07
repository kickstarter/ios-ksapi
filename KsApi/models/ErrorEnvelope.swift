import protocol Argo.Decodable
import enum Argo.Decoded
import enum Argo.JSON
import func Argo.pure
import enum Argo.DecodeError
import func Argo.<||
import func Argo.<||?
import func Argo.<|
import func Argo.<|?
import func Argo.<^>
import func Argo.<*>
import func Curry.curry

public struct ErrorEnvelope {
  public let errorMessages: [String]
  public let ksrCode: KsrCode?
  public let httpCode: Int
  public let exception: Exception?

  public enum KsrCode : String {
    // Codes defined by the server
    case AccessTokenInvalid = "access_token_invalid"
    case InvalidXauthLogin = "invalid_xauth_login"
    case TfaRequired = "tfa_required"
    case TfaFailed = "tfa_failed"

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

  internal init(error_messages: [String], ksr_code: KsrCode? = nil, http_code: Int, exception: Exception? = nil) {
    self.errorMessages = error_messages
    self.ksrCode = ksr_code
    self.httpCode = http_code
    self.exception = exception
  }

  /**
   A general error that JSON could not be parsed.
  */
  internal static var couldNotParseJSON: ErrorEnvelope {
    return ErrorEnvelope(error_messages: [], ksr_code: .JSONParsingFailed, http_code: 400)
  }

  /**
   A general error that the error envelope JSON could not be parsed.
  */
  internal static var couldNotParseErrorEnvelopeJSON: ErrorEnvelope {
    return ErrorEnvelope(error_messages: [], ksr_code: .ErrorEnvelopeJSONParsingFailed, http_code: 400)
  }

  /**
   A general error that some JSON could not be decoded into a model.
  */
  internal static func couldNotDecodeJSON(decodeError: DecodeError) -> ErrorEnvelope {
    return ErrorEnvelope(
      error_messages: [decodeError.description],
      ksr_code: .DecodingJSONFailed,
      http_code: 400
    )
  }
}

extension ErrorEnvelope : ErrorType {
}

extension ErrorEnvelope : Decodable {
  public static func decode(json: JSON) -> Decoded<ErrorEnvelope> {
    return curry(ErrorEnvelope.init)
      <^> json <|| "error_messages"
      <*> json <|? "ksr_code"
      <*> json <| "http_code"
      <*> json <|? "exception"
  }
}

extension ErrorEnvelope.Exception : Decodable {
  public static func decode(json: JSON) -> Decoded<ErrorEnvelope.Exception> {
    return curry(ErrorEnvelope.Exception.init)
      <^> json <||? "backtrace"
      <*> json <|? "message"
  }
}

extension ErrorEnvelope.KsrCode : Decodable {
  public static func decode(j: JSON) -> Decoded<ErrorEnvelope.KsrCode> {
    switch j {
    case let .String(s):
      return pure(ErrorEnvelope.KsrCode(rawValue: s) ?? ErrorEnvelope.KsrCode.UnknownCode)
    default:
      return .typeMismatch("ErrorEnvelope.KsrCode", actual: j)
    }
  }
}
