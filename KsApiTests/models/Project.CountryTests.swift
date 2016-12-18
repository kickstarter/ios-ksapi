import XCTest
@testable import KsApi

final class ProjectCountryTests: XCTestCase {

  func testEquatable() {
    XCTAssertEqual(Project.Country.US, Project.Country.US)
    XCTAssertNotEqual(Project.Country.US, Project.Country.CA)
    XCTAssertNotEqual(Project.Country.US, Project.Country.AU)
    XCTAssertNotEqual(Project.Country.DE, Project.Country.ES)
  }

  func testDescription() {
    XCTAssertNotEqual(Project.Country.US.description, "")
  }

  func testJsonDecoding_StandardJSON() {
    let decodedCountry = Project.Country.decodeJSONDictionary([
      "country": "US" as AnyObject,
      "currency": "USD" as AnyObject,
      "currency_symbol": "$" as AnyObject,
      "currency_trailing_code": true as AnyObject
      ])

    XCTAssertEqual(.US, decodedCountry.value)

    let country = decodedCountry.value!
    XCTAssertEqual(country, Project.Country.decodeJSONDictionary(country.encode()).value)
  }

  func testJsonDecoding_ConfigJSON() {
    let decodedCountry = Project.Country.decodeJSONDictionary([
      "name": "US" as AnyObject,
      "currency_code": "USD" as AnyObject,
      "currency_symbol": "$" as AnyObject,
      "trailing_code": true as AnyObject
      ])

    XCTAssertEqual(.US, decodedCountry.value)

    let country = decodedCountry.value!
    XCTAssertEqual(country, Project.Country.decodeJSONDictionary(country.encode()).value)
  }
}
