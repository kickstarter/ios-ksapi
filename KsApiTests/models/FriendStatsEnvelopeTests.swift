import XCTest
@testable import KsApi
@testable import Argo

final class FriendStatsEnvelopeTests: XCTestCase {
  func testJsonDecoding() {
    let json: [String: AnyObject] = [
      "stats": [
        "remote_friends_count": 202,
        "friend_projects_count": 1132
      ] as AnyObject
    ]

    let stats = FriendStatsEnvelope.decodeJSONDictionary(json)

    XCTAssertEqual(202, stats.value?.stats.remoteFriendsCount)
    XCTAssertEqual(1132, stats.value?.stats.friendProjectsCount)
  }
}
