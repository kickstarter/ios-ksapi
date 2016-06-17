import XCTest
@testable import KsApi

final class ServiceTypeTests: XCTestCase {

  func testEquals() {
    XCTAssertTrue(Service() != MockService())
  }
}
