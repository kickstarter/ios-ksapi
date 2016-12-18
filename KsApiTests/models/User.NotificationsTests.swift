import XCTest
@testable import KsApi

final class NotificationsTests: XCTestCase {
  func testJsonEncoding() {
    let json: [String: AnyObject] = [
      "notify_of_backings": false as AnyObject,
      "notify_of_comments": false as AnyObject,
      "notify_of_follower": false as AnyObject,
      "notify_of_friend_activity": false as AnyObject,
      "notify_of_post_likes": false as AnyObject,
      "notify_of_updates": false as AnyObject,
      "notify_mobile_of_backings": false as AnyObject,
      "notify_mobile_of_comments": false,
      "notify_mobile_of_follower": false,
      "notify_mobile_of_friend_activity": false,
      "notify_mobile_of_post_likes": false,
      "notify_mobile_of_updates": false
    ]

    let notification = User.Notifications.decodeJSONDictionary(json)

    XCTAssertNil(notification.error)
    XCTAssertEqual(notification.value?.encode(), json as NSDictionary)

    XCTAssertEqual(false, notification.value?.backings)
    XCTAssertEqual(false, notification.value?.comments)
    XCTAssertEqual(false, notification.value?.follower)
    XCTAssertEqual(false, notification.value?.friendActivity)
    XCTAssertEqual(false, notification.value?.postLikes)
    XCTAssertEqual(false, notification.value?.updates)
    XCTAssertEqual(false, notification.value?.mobileBackings)
    XCTAssertEqual(false, notification.value?.mobileComments)
    XCTAssertEqual(false, notification.value?.mobileFollower)
    XCTAssertEqual(false, notification.value?.mobileFriendActivity)
    XCTAssertEqual(false, notification.value?.mobilePostLikes)
    XCTAssertEqual(false, notification.value?.mobileUpdates)
  }

  func testJsonEncoding_TrueValues() {
    let json: [String: AnyObject] = [
      "notify_of_backings": true as AnyObject,
      "notify_of_comments": true as AnyObject,
      "notify_of_follower": true as AnyObject,
      "notify_of_friend_activity": true as AnyObject,
      "notify_of_post_likes": true as AnyObject,
      "notify_of_updates": true as AnyObject,
      "notify_mobile_of_backings": true as AnyObject,
      "notify_mobile_of_comments": true,
      "notify_mobile_of_follower": true,
      "notify_mobile_of_friend_activity": true,
      "notify_mobile_of_post_likes": true,
      "notify_mobile_of_updates": true
    ]

    let notification = User.Notifications.decodeJSONDictionary(json)

    XCTAssertNil(notification.error)
    XCTAssertEqual(notification.value?.encode(), json as NSDictionary)

    XCTAssertEqual(true, notification.value?.backings)
    XCTAssertEqual(true, notification.value?.comments)
    XCTAssertEqual(true, notification.value?.follower)
    XCTAssertEqual(true, notification.value?.friendActivity)
    XCTAssertEqual(true, notification.value?.postLikes)
    XCTAssertEqual(true, notification.value?.updates)
    XCTAssertEqual(true, notification.value?.mobileBackings)
    XCTAssertEqual(true, notification.value?.mobileComments)
    XCTAssertEqual(true, notification.value?.mobileFollower)
    XCTAssertEqual(true, notification.value?.mobileFriendActivity)
    XCTAssertEqual(true, notification.value?.mobilePostLikes)
    XCTAssertEqual(true, notification.value?.mobileUpdates)
  }

  func testJsonDecoding() {
    let json = User.Notifications.decodeJSONDictionary([
      "notify_of_backings": true,
      "notify_of_comments": false,
      "notify_of_follower": true,
      "notify_of_friend_activity": false,
      "notify_of_post_likes": true,
      "notify_of_updates": false,
      "notify_mobile_of_backings": true,
      "notify_mobile_of_comments": false,
      "notify_mobile_of_follower": true,
      "notify_mobile_of_friend_activity": false,
      "notify_mobile_of_post_likes": true,
      "notify_mobile_of_updates": false
    ])

    let notifications = json.value

    XCTAssertEqual(notifications,
                   User.Notifications.decodeJSONDictionary(notifications?.encode() ?? [:]).value)
  }
}
