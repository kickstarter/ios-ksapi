import Prelude
import XCTest
@testable import KsApi

final class ItemTests: XCTestCase {

  func testDecoding() {
    let decoded = Item.decodeJSONDictionary([
      "amount": 10.0 as AnyObject,
      "description": "Hello" as AnyObject,
      "id": 1 as AnyObject,
      "name": "The thing" as AnyObject,
      "project_id": 1 as AnyObject
    ])

    XCTAssertNil(decoded.error)
    XCTAssertEqual(10.0, decoded.value?.amount)
    XCTAssertEqual("Hello", decoded.value?.description)
    XCTAssertEqual(1, decoded.value?.id)
    XCTAssertEqual("The thing", decoded.value?.name)
    XCTAssertEqual(1, decoded.value?.projectId)
  }
}
