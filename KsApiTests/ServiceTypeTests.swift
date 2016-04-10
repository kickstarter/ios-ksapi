import XCTest
@testable import KsApi
@testable import KsApi_TestHelpers

final class ServiceTypeTests: XCTestCase {

  func testEquals() {
    XCTAssertTrue(Service() != MockService())
  }
}
