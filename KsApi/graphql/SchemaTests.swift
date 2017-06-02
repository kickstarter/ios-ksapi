import XCTest
@testable import KsApi

final class SchemaTests: XCTestCase {

  func testMeQuery() {
    let query = Query.me([.id])

    XCTAssertEqual("me { id }", query.description)
  }
}
