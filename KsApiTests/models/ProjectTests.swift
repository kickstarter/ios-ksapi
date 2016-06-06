import XCTest
@testable import KsApi
@testable import KsApi_TestHelpers
import Prelude

// swiftlint:disable function_body_length
final class ProjectTests: XCTestCase {

  func testFundingProgress() {
    let halfFunded = Project.template
      |> Project.lens.stats.fundingProgress .~ 0.5

    XCTAssertEqual(0.5, halfFunded.stats.fundingProgress)
    XCTAssertEqual(50, halfFunded.stats.percentFunded)

    let badGoalData = Project.template
      |> Project.lens.stats.pledged .~ 0
      <> Project.lens.stats.goal .~ 0

    XCTAssertEqual(0.0, badGoalData.stats.fundingProgress)
    XCTAssertEqual(0, badGoalData.stats.percentFunded)
  }

  func testEndsIn48Hours_WithJustLaunchedProject() {

    let justLaunched = Project.template
      |> Project.lens.dates.launchedAt .~ NSDate().timeIntervalSince1970

    XCTAssertEqual(false, justLaunched.endsIn48Hours)
  }

  func testEndsIn48Hours_WithEndingSoonProject() {
    let endingSoon = Project.template
      |> Project.lens.dates.deadline .~ (NSDate().timeIntervalSince1970 - 60.0 * 60.0)

    XCTAssertEqual(true, endingSoon.endsIn48Hours)
  }

  func testEndsIn48Hours_WithTimeZoneEdgeCaseProject() {
    let edgeCase = Project.template
      |> Project.lens.dates.deadline .~ (NSDate().timeIntervalSince1970 - 60.0 * 60.0 * 47.0)

    XCTAssertEqual(true, edgeCase.endsIn48Hours)
  }

  func testIsPotdToday_OnPotd() {
    let potdAt = NSCalendar.currentCalendar().startOfDayForDate(NSDate()).timeIntervalSince1970
    let potd = Project.template
      |> Project.lens.dates.potdAt .~ potdAt

    XCTAssertEqual(true, potd.isPotdToday())
    XCTAssertEqual(true, potd.isPotdToday(today: NSDate()))
    XCTAssertEqual(false, potd.isPotdToday(today: NSDate(timeIntervalSinceNow: 60.0 * 60.0 * 24)))
    XCTAssertEqual(false, potd.isPotdToday(today: NSDate(timeIntervalSinceNow: -60.0 * 60.0 * 24)))
  }

  func testIsPotdToday_WhenUnspecified() {
    let potd = Project.template |> Project.lens.dates.potdAt .~ nil
    XCTAssertEqual(potd.isPotdToday(), false)
  }

  func testEquatable() {
    XCTAssertEqual(Project.template, Project.template)
    XCTAssertNotEqual(Project.template, Project.template |> Project.lens.id %~ { $0 + 1 })
  }

  func testDescription() {
    XCTAssertNotEqual("", Project.template.debugDescription)
  }

  func testJSONParsing_WithCompleteData() {
    let project = Project.decodeJSONDictionary([
      "id": 1,
      "name": "Project",
      "blurb": "The project blurb",
      "pledged": 1_000,
      "goal": 2_000,
      "category": [
        "id": 1,
        "name": "Art",
        "slug": "art",
        "position": 1
      ],
      "creator": [
        "id": 1,
        "name": "Blob",
        "avatar": [
          "medium": "http://www.kickstarter.com/medium.jpg",
          "small": "http://www.kickstarter.com/small.jpg"
        ]
      ],
      "photo": [
        "full": "http://www.kickstarter.com/full.jpg",
        "med": "http://www.kickstarter.com/med.jpg",
        "small": "http://www.kickstarter.com/small.jpg",
        "1024x768": "http://www.kickstarter.com/1024x768.jpg",
      ],
      "location": [
        "id": 1,
        "displayable_name": "Brooklyn, NY",
        "name": "Brooklyn"
      ],
      "video": [
        "id": 1,
        "high": "kickstarter.com/video.mp4"
      ],
      "backers_count": 10,
      "currency_symbol": "$",
      "currency": "USD",
      "currency_trailing_code": false,
      "country": "US",
      "launched_at": 1000,
      "deadline": 1000,
      "state_changed_at": 1000,
      "urls": [
        "web": [
          "project": "https://www.kickstarter.com/projects/my-cool-projects"
        ]
      ],
      "state": "live"
      ])

    XCTAssertNil(project.error)
    XCTAssertEqual("US", project.value?.country.countryCode)
  }

  func testJSONParsing_WithPesonalizationData() {
    let project = Project.decodeJSONDictionary([
      "id": 1,
      "name": "Project",
      "blurb": "The project blurb",
      "pledged": 1_000,
      "goal": 2_000,
      "category": [
        "id": 1,
        "name": "Art",
        "slug": "art",
        "position": 1
      ],
      "creator": [
        "id": 1,
        "name": "Blob",
        "avatar": [
          "medium": "http://www.kickstarter.com/medium.jpg",
          "small": "http://www.kickstarter.com/small.jpg"
        ]
      ],
      "photo": [
        "full": "http://www.kickstarter.com/full.jpg",
        "med": "http://www.kickstarter.com/med.jpg",
        "small": "http://www.kickstarter.com/small.jpg",
        "1024x768": "http://www.kickstarter.com/1024x768.jpg",
      ],
      "location": [
        "id": 1,
        "displayable_name": "Brooklyn, NY",
        "name": "Brooklyn"
      ],
      "video": [
        "id": 1,
        "high": "kickstarter.com/video.mp4"
      ],
      "backers_count": 10,
      "currency_symbol": "$",
      "currency": "USD",
      "currency_trailing_code": false,
      "country": "US",
      "launched_at": 1000,
      "deadline": 1000,
      "state_changed_at": 1000,
      "urls": [
        "web": [
          "project": "https://www.kickstarter.com/projects/my-cool-projects"
        ]
      ],
      "state": "live",
      "is_backing": true,
      "is_starred": true
    ])

    XCTAssertNil(project.error)
    XCTAssertEqual("US", project.value?.country.countryCode)
    XCTAssertEqual(true, project.value?.personalization.isBacking)
  }
}
