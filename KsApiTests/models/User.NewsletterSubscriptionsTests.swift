import XCTest
@testable import KsApi

final class NewsletterSubscriptionsTests: XCTestCase {

  func testJsonEncoding() {
    let json: [String: Any] = [
      "games_newsletter": false,
      "promo_newsletter": false,
      "happening_newsletter": false,
      "weekly_newsletter": false
    ]

    let newsletter = User.NewsletterSubscriptions.decodeJSONDictionary(json)

    XCTAssertEqual(newsletter.value?.encode().description, json.description)

    XCTAssertEqual(false, newsletter.value?.weekly)
    XCTAssertEqual(false, newsletter.value?.promo)
    XCTAssertEqual(false, newsletter.value?.happening)
    XCTAssertEqual(false, newsletter.value?.games)
  }

  func testJsonEncoding_TrueValues() {
    let json: [String: AnyObject] = [
      "games_newsletter": true as AnyObject,
      "promo_newsletter": true as AnyObject,
      "happening_newsletter": true as AnyObject,
      "weekly_newsletter": true as AnyObject
    ]

    let newsletter = User.NewsletterSubscriptions.decodeJSONDictionary(json)

    XCTAssertEqual(newsletter.value?.encode().description, json.description)

    XCTAssertEqual(true, newsletter.value?.weekly)
    XCTAssertEqual(true, newsletter.value?.promo)
    XCTAssertEqual(true, newsletter.value?.happening)
    XCTAssertEqual(true, newsletter.value?.games)
  }

  func testJsonDecoding() {
    let json = User.NewsletterSubscriptions.decodeJSONDictionary([
      "games_newsletter": true as AnyObject,
      "happening_newsletter": false as AnyObject,
      "promo_newsletter": true as AnyObject,
      "weekly_newsletter": false
    ])

    let newsletters = json.value

    XCTAssertEqual(newsletters,
                   User.NewsletterSubscriptions.decodeJSONDictionary(newsletters?.encode() ?? [:]).value)
  }
}
