import XCTest
@testable import KsApi

final class UserAvatarTests: XCTestCase {

  func testJsonEncoding() {
    let json: [String:AnyObject] = [
      "medium": "http://www.kickstarter.com/medium.jpg" as AnyObject,
      "small": "http://www.kickstarter.com/small.jpg" as AnyObject
    ]
    let avatar = User.Avatar.decodeJSONDictionary(json)

    XCTAssertEqual(avatar.value?.encode().description, json.description)
  }
}
