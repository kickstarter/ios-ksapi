import XCTest
@testable import KsApi
@testable import Models

class DiscoveryParamsTests: XCTestCase {

  func testInit() {
    let params = DiscoveryParams(
      staffPicks: true,
      hasVideo: true,
      starred: false,
      backed: false,
      social: nil,
      recommended: nil,
      similarTo: nil,
      category: nil,
      query: "wallet",
      state: .Live,
      sort: .Magic,
      page: 1,
      perPage: 20,
      includePOTD: nil,
      seed: nil
    )

    XCTAssertEqual(params.staffPicks, true)
  }

  func testWith() {
    let params = DiscoveryParams()
    let newParams = params.with(state: .Live, sort: .Popular)

    XCTAssertEqual(newParams.state, .Live)
    XCTAssertEqual(newParams.sort, .Popular)
  }

  func testNextPage() {
    let params = DiscoveryParams()
    let nextPage = params.nextPage()

    XCTAssertEqual(params.page, 1)
    XCTAssertEqual(nextPage.page, 2)
  }

  func testNextPageWithUnspecifiedPage() {
    let params = DiscoveryParams(page: nil)
    let nextPage = params.nextPage()

    XCTAssertEqual(params.page, nil)
    XCTAssertEqual(nextPage.page, 2)
  }

  func testQueryParams() {
    let defaultParams = DiscoveryParams()
    XCTAssertEqual(defaultParams.queryParams, [
      "page": DiscoveryParams.defaultPage.description,
      "per_page": DiscoveryParams.defaultPerPage.description
    ])

    let params = DiscoveryParams(
      staffPicks: true,
      hasVideo: true,
      starred: false,
      backed: false,
      social: true,
      recommended: true,
      similarTo: nil,
      category: Models.Category(id: 1, name: "Art", slug: "art", position: 1, parentId: nil, _parent: {nil}, color: nil),
      query: "wallet",
      state: .Live,
      sort: .Popular,
      page: 1,
      perPage: 20,
      includePOTD: true,
      seed: 123
    )

    XCTAssertEqual(params.queryParams, [
      "staff_picks": "true",
      "has_video": "true",
      "starred": "false",
      "backed" : "false",
      "social": "true",
      "recommended": "true",
      "category_id": "1",
      "term": "wallet",
      "state": "live",
      "sort": "popularity",
      "page": "1",
      "per_page": "20",
      "include_potd": "true",
      "seed": "123",
    ])
  }

  func testEquatable() {
    let params = DiscoveryParams()

    XCTAssertEqual(params, params)
    XCTAssertNotEqual(params.with(staffPicks: false), params)
    XCTAssertNotEqual(params.with(hasVideo: true), params)
    XCTAssertNotEqual(params.with(starred: true), params)
    XCTAssertNotEqual(params.with(backed: true), params)
    XCTAssertNotEqual(params.with(social: true), params)
    XCTAssertNotEqual(params.with(recommended: true), params)
    XCTAssertNotEqual(params.with(query: "wallet"), params)
    XCTAssertNotEqual(params.with(state: .Live), params)
    XCTAssertNotEqual(params.with(sort: .Popular), params)
    XCTAssertNotEqual(params.with(page: 2), params)
    XCTAssertNotEqual(params.with(perPage: 2), params)
    XCTAssertNotEqual(params.with(includePOTD: true), params)
    XCTAssertNotEqual(params.with(seed: 123), params)
  }

  func testStringConvertible() {
    let params = DiscoveryParams()
    XCTAssertNotEqual(params.description, nil)
    XCTAssertNotEqual(params.debugDescription, nil)
  }
}
