import XCTest
@testable import KsApi
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

  func testPOTD() {
    let p1 = DiscoveryParams.defaults
      |> DiscoveryParams.lens.includePOTD .~ true
    XCTAssertEqual([:], p1.queryParams,
                   "POTD flag is not included when not staff picks + default sort.")

    let p2 = DiscoveryParams.defaults
      |> DiscoveryParams.lens.includePOTD .~ true
      |> DiscoveryParams.lens.staffPicks .~ true
    XCTAssertEqual(["staff_picks": "true", "include_potd": "true"],
                   p2.queryParams,
                   "POTD flag is included when staff picks + default sort.")

    let p3 = DiscoveryParams.defaults
      |> DiscoveryParams.lens.includePOTD .~ true
      |> DiscoveryParams.lens.staffPicks .~ true
      |> DiscoveryParams.lens.sort .~ .Magic
    XCTAssertEqual(["staff_picks": "true", "include_potd": "true", "sort": "magic"],
                   p3.queryParams,
                   "POTD flag is included when staff picks + magic sort.")
  }
}
