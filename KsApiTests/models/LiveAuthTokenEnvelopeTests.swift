import XCTest
@testable import KsApi
@testable import Argo

final class LiveAuthTokenEnvelopeTests: XCTestCase {
  func testJsonDecoding() {
    let json: [String:Any] = [
      "ksr_live_token": "19b703c03de8efdf628694ce4c91a7bf8a6c98cfcbb7a089abbd488fdd166c4b"
    ]

    let envelope = LiveAuthTokenEnvelope.decodeJSONDictionary(json)

    XCTAssertNil(envelope.error)
    XCTAssertEqual("19b703c03de8efdf628694ce4c91a7bf8a6c98cfcbb7a089abbd488fdd166c4b", envelope.value?.token)
  }
}
