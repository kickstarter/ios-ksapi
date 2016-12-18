import XCTest
@testable import KsApi

final class ProjectPhotoTests: XCTestCase {

  func testJSONParsing_WithPartialData() {
    let photo = Project.Photo.decodeJSONDictionary([
      "full": "http://www.kickstarter.com/full.jpg" as AnyObject,
      "med": "http://www.kickstarter.com/med.jpg" as AnyObject,
      ])

    XCTAssertNotNil(photo.error)
  }

  func testJSONParsing_WithMissing1024() {
    let photo = Project.Photo.decodeJSONDictionary([
      "full": "http://www.kickstarter.com/full.jpg" as AnyObject,
      "med": "http://www.kickstarter.com/med.jpg" as AnyObject,
      "small": "http://www.kickstarter.com/small.jpg" as AnyObject,
      ])

    XCTAssertNil(photo.error)
    XCTAssertEqual(photo.value?.full, "http://www.kickstarter.com/full.jpg")
    XCTAssertEqual(photo.value?.med, "http://www.kickstarter.com/med.jpg")
    XCTAssertEqual(photo.value?.small, "http://www.kickstarter.com/small.jpg")
    XCTAssertNil(photo.value?.size1024x768)
  }

  func testJSONParsing_WithFullData() {
    let photo = Project.Photo.decodeJSONDictionary([
      "full": "http://www.kickstarter.com/full.jpg" as AnyObject,
      "med": "http://www.kickstarter.com/med.jpg" as AnyObject,
      "small": "http://www.kickstarter.com/small.jpg" as AnyObject,
      "1024x768": "http://www.kickstarter.com/1024x768.jpg",
      ])

    XCTAssertNil(photo.error)
    XCTAssertEqual(photo.value?.full, "http://www.kickstarter.com/full.jpg")
    XCTAssertEqual(photo.value?.med, "http://www.kickstarter.com/med.jpg")
    XCTAssertEqual(photo.value?.small, "http://www.kickstarter.com/small.jpg")
    XCTAssertEqual(photo.value?.size1024x768, "http://www.kickstarter.com/1024x768.jpg")
  }
}
