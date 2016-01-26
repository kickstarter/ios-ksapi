import XCTest
@testable import KsApi
import Models

class KsApiTests: XCTestCase {

  func testSometing() {

    let error = ErrorEnvelope(error_messages: ["hello"], http_code: 400)
    XCTAssertEqual(error.httpCode, 400)
  }
}
