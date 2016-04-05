import XCTest
@testable import KsApi
@testable import Models
import Argo

class ErrorEnvelopeTests: XCTestCase {

  func testJsonDecodingWithFullData() {
    let env = ErrorEnvelope.decodeJSONDictionary([
      "error_messages": ["hello"],
      "ksr_code": "access_token_invalid",
      "http_code": 401,
      "exception": [
        "backtrace": ["hello"],
        "message": "hello"
      ]
      ])
    XCTAssertNotNil(env)
  }

  func testJsonDecodingWithBadKsrCode() {
    let env = ErrorEnvelope.decodeJSONDictionary([
      "error_messages": ["hello"],
      "ksr_code": "doesnt_exist",
      "http_code": 401,
      "exception": [
        "backtrace": ["hello"],
        "message": "hello"
      ]
      ])
    XCTAssertNil(env.error)
    XCTAssertEqual(ErrorEnvelope.KsrCode.UnknownCode, env.value?.ksrCode)
  }
}
