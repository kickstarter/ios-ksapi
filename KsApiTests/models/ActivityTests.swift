import XCTest
@testable import KsApi
@testable import KsApi_TestHelpers
import Argo

final internal class ActivityTests: XCTestCase {

  func testEquatable() {
    XCTAssertEqual(Activity.template, Activity.template)
  }

  func testJSONDecoding_WithBadData() {
    let activity = Activity.decodeJSONDictionary([
      "category": "update"
    ])

    XCTAssertNotNil(activity.error)
  }

  func testJSONDecoding_WithGoodData() {
    let activity = Activity.decodeJSONDictionary([
      "category": "update",
      "created_at": 123123123,
      "id": 1,
      ])

    XCTAssertNil(activity.error)
    XCTAssertEqual(activity.value?.id, 1)
  }

  func testJSONDecoding_WithNestedGoodData() {
    let activity = Activity.decodeJSONDictionary([
      "category": "update",
      "created_at": 123123123,
      "id": 1,
      "user": [
        "id": 2,
        "name": "User",
        "avatar": [
          "medium": "img.jpg",
          "small": "img.jpg",
          "large": "img.jpg",
        ]
      ]
      ])

    XCTAssertNil(activity.error)
    XCTAssertEqual(activity.value?.id, 1)
    XCTAssertEqual(activity.value?.user?.id, 2)
  }

  func testJSONDecoding_WithIncorrectCategory() {
    let activity = Activity.decodeJSONDictionary([
      "category": "incorrect_category",
      "created_at": 123123123,
      "id": 1,
      ])

    XCTAssertNotNil(activity.error)
  }
}
