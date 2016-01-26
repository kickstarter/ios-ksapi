import XCTest
@testable import KsApi

final class ServiceTests : XCTestCase {

  func testInit() {
    XCTAssertEqual(Service.shared.language, "en")

    let service = Service(serverConfig: ServerConfig.production, oauthToken: nil, language: "en")
    XCTAssertEqual(service.language, "en")
  }
}
