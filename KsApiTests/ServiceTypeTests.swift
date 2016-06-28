import XCTest
@testable import KsApi

final class ServiceTypeTests: XCTestCase {
  private let service = Service(
    serverConfig: ServerConfig(
      apiBaseUrl: NSURL(string: "http://api.ksr.com")!,
      webBaseUrl: NSURL(string: "http://www.ksr.com")!,
      apiClientAuth: ClientAuth(
        clientId: "deadbeef"
      ),
      basicHTTPAuth: BasicHTTPAuth(
        username: "username",
        password: "password"
      )
    ),
    oauthToken: OauthToken(
      token: "cafebeef"
    ),
    language: "ksr",
    buildVersion: "1234567890"
  )

  func testEquals() {
    XCTAssertTrue(Service() != MockService())
  }

  func testPreparedRequest() {
    let URL = NSURL(string: "http://api.ksr.com/v1/test?key=value") ?? NSURL()
    let request = self.service.preparedRequest(forRequest: .init(URL: URL))

    XCTAssertEqual("http://api.ksr.com/v1/test?client_id=deadbeef&key=value&oauth_token=cafebeef",
                   request.URL?.absoluteString)
    XCTAssertEqual(
      ["Kickstarter-iOS-App": "1234567890", "Authorization": "token cafebeef", "Accept-Language": "ksr"],
      request.allHTTPHeaderFields!
    )
  }

  func testPreparedURL() {
    let URL = NSURL(string: "http://api.ksr.com/v1/test?key=value") ?? NSURL()
    let request = self.service.preparedRequest(forURL: URL, query: ["extra": "1"])

    XCTAssertEqual("http://api.ksr.com/v1/test?client_id=deadbeef&extra=1&key=value&oauth_token=cafebeef",
                   request.URL?.absoluteString)
    XCTAssertEqual(
      ["Kickstarter-iOS-App": "1234567890", "Authorization": "token cafebeef", "Accept-Language": "ksr"],
      request.allHTTPHeaderFields!
    )
    XCTAssertEqual("GET", request.HTTPMethod)
  }

  func testPreparedDeleteURL() {
    let URL = NSURL(string: "http://api.ksr.com/v1/test?key=value") ?? NSURL()
    let request = self.service.preparedRequest(forURL: URL, method: .DELETE, query: ["extra": "1"])

    XCTAssertEqual("http://api.ksr.com/v1/test?client_id=deadbeef&extra=1&key=value&oauth_token=cafebeef",
                   request.URL?.absoluteString)
    XCTAssertEqual(
      ["Kickstarter-iOS-App": "1234567890", "Authorization": "token cafebeef", "Accept-Language": "ksr"],
      request.allHTTPHeaderFields!
    )
    XCTAssertEqual("DELETE", request.HTTPMethod)
  }

  func testPreparedPostURL() {
    let URL = NSURL(string: "http://api.ksr.com/v1/test?key=value") ?? NSURL()
    let request = self.service.preparedRequest(forURL: URL, method: .POST, query: ["extra": "1"])

    XCTAssertEqual("http://api.ksr.com/v1/test?key=value",
                   request.URL?.absoluteString)
    XCTAssertEqual(
      ["Kickstarter-iOS-App": "1234567890", "Authorization": "token cafebeef", "Accept-Language": "ksr",
       "Content-Type": "application/x-www-form-urlencoded; charset=utf-8"],
      request.allHTTPHeaderFields!
    )
    XCTAssertEqual("POST", request.HTTPMethod)
    XCTAssertEqual("client_id=deadbeef&extra=1&key=value&oauth_token=cafebeef",
                   String(data: request.HTTPBody ?? NSData(), encoding: NSUTF8StringEncoding))
  }

  func testPreparedRequestWithoutOauthToken() {
    let anonService = Service(
      serverConfig: ServerConfig(
        apiBaseUrl: NSURL(string: "http://api.ksr.com")!,
        webBaseUrl: NSURL(string: "http://www.ksr.com")!,
        apiClientAuth: ClientAuth(
          clientId: "deadbeef"
        ),
        basicHTTPAuth: BasicHTTPAuth(
          username: "username",
          password: "password"
        )
      )
    )

    let URL = NSURL(string: "http://api.ksr.com/v1/test?key=value") ?? NSURL()
    let request = anonService.preparedRequest(forRequest: .init(URL: URL))

    XCTAssertEqual("http://api.ksr.com/v1/test?client_id=deadbeef&key=value",
                   request.URL?.absoluteString)
    XCTAssertEqual(
      ["Kickstarter-iOS-App": "1", "Authorization": "Basic dXNlcm5hbWU6cGFzc3dvcmQ=",
        "Accept-Language": "en"],
      request.allHTTPHeaderFields!
    )
  }
}
