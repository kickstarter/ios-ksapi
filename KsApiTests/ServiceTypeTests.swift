import XCTest
@testable import KsApi

private let emptyUrl = URL(string: "")!

final class ServiceTypeTests: XCTestCase {
  fileprivate let service = Service(
    appId: "com.kickstarter.test",
    serverConfig: ServerConfig(
      apiBaseUrl: URL(string: "http://api.ksr.com")!,
      webBaseUrl: URL(string: "http://www.ksr.com")!,
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

  fileprivate let anonAdHocService = Service(
    appId: "com.kickstarter.test",
    serverConfig: ServerConfig(
      apiBaseUrl: URL(string: "http://api-hq.dev.ksr.com")!,
      webBaseUrl: URL(string: "http://hq.dev.ksr.com")!,
      apiClientAuth: ClientAuth(
        clientId: "deadbeef"
      ),
      basicHTTPAuth: BasicHTTPAuth(
        username: "username",
        password: "password"
      )
    )
  )

  fileprivate let anonService = Service(
    appId: "com.kickstarter.test",
    serverConfig: ServerConfig(
      apiBaseUrl: URL(string: "http://api.ksr.com")!,
      webBaseUrl: URL(string: "http://hq.ksr.com")!,
      apiClientAuth: ClientAuth(
        clientId: "deadbeef"
      ),
      basicHTTPAuth: nil
    )
  )

  func testEquals() {
    XCTAssertTrue(Service() != MockService())
  }

  func testIsPreparedAdhocWithoutOauthToken() {
    let URL = Foundation.URL(string: "http://api-dev.ksr.com/v1/test?key=value") ?? emptyUrl
    let request = URLRequest(url: URL)
    XCTAssertFalse(self.anonAdHocService.isPrepared(request: request))
    XCTAssertTrue(self.anonAdHocService.isPrepared(request:
      self.anonAdHocService.preparedRequest(forRequest: request))
    )
  }

  func testIsPreparedWithOauthToken() {
    let URL = Foundation.URL(string: "http://api.ksr.com/v1/test?key=value&oauth_token=cafebeef") ?? emptyUrl
    let request = URLRequest(url: URL)
    XCTAssertFalse(self.service.isPrepared(request: request))
    XCTAssertTrue(self.service.isPrepared(request: self.service.preparedRequest(forRequest: request)))
  }

  func testIsPreparedWithoutOauthToken() {
    let URL = Foundation.URL(string: "http://api.ksr.com/v1/test?key=value") ?? emptyUrl
    let request = URLRequest(url: URL)
    XCTAssertFalse(self.anonService.isPrepared(request: request))
    XCTAssertTrue(self.anonService.isPrepared(request: self.anonService.preparedRequest(forRequest: request)))
  }

  func testPreparedRequest() {
    let url = Foundation.URL(string: "http://api.ksr.com/v1/test?key=value") ?? emptyUrl
    let request = self.service.preparedRequest(forRequest: .init(url: url))

    XCTAssertEqual("http://api.ksr.com/v1/test?client_id=deadbeef&key=value&oauth_token=cafebeef",
                   request.url?.absoluteString)
    XCTAssertEqual(
      ["Kickstarter-iOS-App": "1234567890", "Authorization": "token cafebeef", "Accept-Language": "ksr",
        "Kickstarter-App-Id": "com.kickstarter.test",
        "User-Agent": "Kickstarter/1 (iPhone; iOS 9.3 Scale/2.0)"],
      request.allHTTPHeaderFields!
    )
  }

  func testPreparedURL() {
    let URL = Foundation.URL(string: "http://api.ksr.com/v1/test?key=value") ?? emptyUrl
    let request = self.service.preparedRequest(forURL: URL, query: ["extra": "1"])

    XCTAssertEqual("http://api.ksr.com/v1/test?client_id=deadbeef&extra=1&key=value&oauth_token=cafebeef",
                   request.url?.absoluteString)
    XCTAssertEqual(
      ["Kickstarter-iOS-App": "1234567890", "Authorization": "token cafebeef", "Accept-Language": "ksr",
        "Kickstarter-App-Id": "com.kickstarter.test",
        "User-Agent": "Kickstarter/1 (iPhone; iOS 9.3 Scale/2.0)"],
      request.allHTTPHeaderFields!
    )
    XCTAssertEqual("GET", request.httpMethod)
  }

  func testPreparedDeleteURL() {
    let URL = Foundation.URL(string: "http://api.ksr.com/v1/test?key=value") ?? emptyUrl
    let request = self.service.preparedRequest(forURL: URL, method: .DELETE, query: ["extra": "1"])

    XCTAssertEqual("http://api.ksr.com/v1/test?client_id=deadbeef&extra=1&key=value&oauth_token=cafebeef",
                   request.url?.absoluteString)
    XCTAssertEqual(
      ["Kickstarter-iOS-App": "1234567890", "Authorization": "token cafebeef", "Accept-Language": "ksr",
        "Kickstarter-App-Id": "com.kickstarter.test",
        "User-Agent": "Kickstarter/1 (iPhone; iOS 9.3 Scale/2.0)"],
      request.allHTTPHeaderFields!
    )
    XCTAssertEqual("DELETE", request.httpMethod)
  }

  func testPreparedPostURL() {
    let URL = Foundation.URL(string: "http://api.ksr.com/v1/test?key=value") ?? emptyUrl
    let request = self.service.preparedRequest(forURL: URL, method: .POST, query: ["extra": "1"])

    XCTAssertEqual("http://api.ksr.com/v1/test?client_id=deadbeef&key=value&oauth_token=cafebeef",
                   request.url?.absoluteString)
    XCTAssertEqual(
      ["Kickstarter-iOS-App": "1234567890", "Authorization": "token cafebeef", "Accept-Language": "ksr",
        "Kickstarter-App-Id": "com.kickstarter.test",
        "Content-Type": "application/json; charset=utf-8",
        "User-Agent": "Kickstarter/1 (iPhone; iOS 9.3 Scale/2.0)"],
      request.allHTTPHeaderFields!
    )
    XCTAssertEqual("POST", request.httpMethod)
    XCTAssertEqual("{\"extra\":\"1\"}",
                   String(data: request.httpBody ?? Data(), encoding: .utf8))
  }

  func testPreparedPostURLWithBody() {
    let URL = Foundation.URL(string: "http://api.ksr.com/v1/test?key=value") ?? emptyUrl
    var baseRequest = URLRequest(url: URL)
    let body = "test".data(using: String.Encoding.utf8, allowLossyConversion: false)
    baseRequest.httpBody = body
    baseRequest.httpMethod = "POST"
    let request = self.service.preparedRequest(forRequest: baseRequest, query: ["extra": "1"])

    XCTAssertEqual("http://api.ksr.com/v1/test?client_id=deadbeef&key=value&oauth_token=cafebeef",
                   request.url?.absoluteString)
    XCTAssertEqual(
      ["Kickstarter-iOS-App": "1234567890", "Authorization": "token cafebeef", "Accept-Language": "ksr",
        "Kickstarter-App-Id": "com.kickstarter.test",
        "User-Agent": "Kickstarter/1 (iPhone; iOS 9.3 Scale/2.0)"],
      request.allHTTPHeaderFields!
    )
    XCTAssertEqual("POST", request.httpMethod)
    XCTAssertEqual(body, request.httpBody, "Body remains unchanged")
  }

  func testPreparedAdHocWithoutOauthToken() {
    let URL = Foundation.URL(string: "http://api-hq.ksr.com/v1/test?key=value") ?? emptyUrl
    let request = anonAdHocService.preparedRequest(forRequest: .init(url: URL))

    XCTAssertEqual("http://api-hq.ksr.com/v1/test?client_id=deadbeef&key=value", request.url?.absoluteString)
    XCTAssertEqual(
      ["Kickstarter-iOS-App": "1", "Authorization": "Basic dXNlcm5hbWU6cGFzc3dvcmQ=",
        "Accept-Language": "en", "Kickstarter-App-Id": "com.kickstarter.test",
        "User-Agent": "Kickstarter/1 (iPhone; iOS 9.3 Scale/2.0)"],
      request.allHTTPHeaderFields!
    )
  }

  func testPreparedRequestWithoutOauthToken() {
    let anonService = Service(
      appId: "com.kickstarter.test",
      serverConfig: ServerConfig(
        apiBaseUrl: Foundation.URL(string: "http://api.ksr.com")!,
        webBaseUrl: Foundation.URL(string: "http://www.ksr.com")!,
        apiClientAuth: ClientAuth(
          clientId: "deadbeef"
        ),
        basicHTTPAuth: BasicHTTPAuth(
          username: "username",
          password: "password"
        )
      )
    )

    let URL = Foundation.URL(string: "http://api.ksr.com/v1/test?key=value") ?? emptyUrl
    let request = anonService.preparedRequest(forRequest: .init(url: URL))

    XCTAssertEqual("http://api.ksr.com/v1/test?client_id=deadbeef&key=value",
                   request.url?.absoluteString)
    XCTAssertEqual(
      ["Kickstarter-iOS-App": "1", "Authorization": "Basic dXNlcm5hbWU6cGFzc3dvcmQ=",
        "Accept-Language": "en", "Kickstarter-App-Id": "com.kickstarter.test",
        "User-Agent": "Kickstarter/1 (iPhone; iOS 9.3 Scale/2.0)"],
      request.allHTTPHeaderFields!
    )
  }
}
