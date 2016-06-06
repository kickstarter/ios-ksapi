import XCTest
@testable import KsApi
@testable import KsApi_TestHelpers
import Prelude

final class LocationTests: XCTestCase {

  func testEquatable() {
    XCTAssertEqual(Location.template, Location.template)
    XCTAssertNotEqual(Location.template, Location.template |> Location.lens.id %~ { $0 + 1 })
  }

  func testJSONParsing_WithPartialData() {

    let location = Location.decodeJSONDictionary([
      "id": 1
    ])

    XCTAssertNotNil(location.error)
  }

  func testJSONParsing_WithFullData() {

    let location = Location.decodeJSONDictionary([
      "id": 1,
      "displayable_name": "Brooklyn, NY",
      "name": "Brooklyn"
    ])

    XCTAssertNil(location.error)
    XCTAssertEqual(location.value?.id, 1)
    XCTAssertEqual(location.value?.displayableName, "Brooklyn, NY")
    XCTAssertEqual(location.value?.name, "Brooklyn")
  }
}
