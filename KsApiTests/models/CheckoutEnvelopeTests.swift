import XCTest
@testable import KsApi
@testable import Argo

final class CheckoutEnvelopeTests: XCTestCase {
  func testJsonDecoding() {
    let json: [String: AnyObject] = [
      "state": "failed" as AnyObject,
      "state_reason": "Oof!" as AnyObject
    ]

    let envelope = CheckoutEnvelope.decodeJSONDictionary(json)

    XCTAssertEqual(CheckoutEnvelope.State.failed, envelope.value?.state)
    XCTAssertEqual("Oof!", envelope.value?.stateReason)
  }
}
