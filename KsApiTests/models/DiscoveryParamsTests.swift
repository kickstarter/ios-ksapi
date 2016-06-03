import XCTest
@testable import KsApi
@testable import Models
@testable import Models_TestHelpers
import Prelude

class DiscoveryParamsTests: XCTestCase {

  func testDefault() {
    let params = DiscoveryParams.defaults
    XCTAssertNil(params.staffPicks)
  }

  func testQueryParams() {
    XCTAssertEqual([:], DiscoveryParams.defaults.queryParams)

    let params = DiscoveryParams.defaults
      |> DiscoveryParams.lens.staffPicks .~ true
      <> DiscoveryParams.lens.hasVideo .~ true
      <> DiscoveryParams.lens.starred .~ true
      <> DiscoveryParams.lens.backed .~ false
      <> DiscoveryParams.lens.social .~ true
      <> DiscoveryParams.lens.recommended .~ true
      <> DiscoveryParams.lens.similarTo .~ Project.template
      <> DiscoveryParams.lens.category .~ Category.art
      <> DiscoveryParams.lens.query .~ "wallet"
      <> DiscoveryParams.lens.state .~ .Live
      <> DiscoveryParams.lens.sort .~ .Popular
      <> DiscoveryParams.lens.page .~ 1
      <> DiscoveryParams.lens.perPage .~ 20
      <> DiscoveryParams.lens.includePOTD .~ true
      <> DiscoveryParams.lens.seed .~ 123

    XCTAssertEqual([
      "staff_picks": "true",
      "has_video": "true",
      "backed": "-1",
      "social": "1",
      "recommended": "true",
      "category_id": "1",
      "term": "wallet",
      "state": "live",
      "starred": "1",
      "sort": "popularity",
      "page": "1",
      "per_page": "20",
      "include_potd": "true",
      "seed": "123",
      "similar_to": Project.template.id.description
    ], params.queryParams)
  }

  func testEquatable() {
    let params = DiscoveryParams.defaults
    XCTAssertEqual(params, params)
  }

  func testStringConvertible() {
    let params = DiscoveryParams.defaults
    XCTAssertNotNil(params.description)
    XCTAssertNotNil(params.debugDescription)
  }
}
