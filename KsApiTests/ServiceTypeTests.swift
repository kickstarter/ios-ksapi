import XCTest
@testable import KsApi

final class ServiceTypeTests: XCTestCase {
  private let service = Service(
    appId: "com.kickstarter.test",
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

  private let anonAdHocService = Service(
    appId: "com.kickstarter.test",
    serverConfig: ServerConfig(
      apiBaseUrl: NSURL(string: "http://api-hq.dev.ksr.com")!,
      webBaseUrl: NSURL(string: "http://hq.dev.ksr.com")!,
      apiClientAuth: ClientAuth(
        clientId: "deadbeef"
      ),
      basicHTTPAuth: BasicHTTPAuth(
        username: "username",
        password: "password"
      )
    )
  )

  private let anonService = Service(
    appId: "com.kickstarter.test",
    serverConfig: ServerConfig(
      apiBaseUrl: NSURL(string: "http://api.ksr.com")!,
      webBaseUrl: NSURL(string: "http://hq.ksr.com")!,
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
    let URL = NSURL(string: "http://api-dev.ksr.com/v1/test?key=value") ?? NSURL()
    let request = NSURLRequest(URL: URL)
    XCTAssertFalse(self.anonAdHocService.isPrepared(request: request))
    XCTAssertTrue(self.anonAdHocService.isPrepared(request:
      self.anonAdHocService.preparedRequest(forRequest: request))
    )
  }

  func testIsPreparedWithOauthToken() {
    let URL = NSURL(string: "http://api.ksr.com/v1/test?key=value&oauth_token=cafebeef") ?? NSURL()
    let request = NSURLRequest(URL: URL)
    XCTAssertFalse(self.service.isPrepared(request: request))
    XCTAssertTrue(self.service.isPrepared(request: self.service.preparedRequest(forRequest: request)))
  }

  func testIsPreparedWithoutOauthToken() {
    let URL = NSURL(string: "http://api.ksr.com/v1/test?key=value") ?? NSURL()
    let request = NSURLRequest(URL: URL)
    XCTAssertFalse(self.anonService.isPrepared(request: request))
    XCTAssertTrue(self.anonService.isPrepared(request: self.anonService.preparedRequest(forRequest: request)))
  }

  func testPreparedRequest() {
    let URL = NSURL(string: "http://api.ksr.com/v1/test?key=value") ?? NSURL()
    let request = self.service.preparedRequest(forRequest: .init(URL: URL))

    XCTAssertEqual("http://api.ksr.com/v1/test?client_id=deadbeef&key=value&oauth_token=cafebeef",
                   request.URL?.absoluteString)
    XCTAssertEqual(
      ["Kickstarter-iOS-App": "1234567890", "Authorization": "token cafebeef", "Accept-Language": "ksr",
        "Kickstarter-App-Id": "com.kickstarter.test"],
      request.allHTTPHeaderFields!
    )
  }

  func testPreparedURL() {
    let URL = NSURL(string: "http://api.ksr.com/v1/test?key=value") ?? NSURL()
    let request = self.service.preparedRequest(forURL: URL, query: ["extra": "1"])

    XCTAssertEqual("http://api.ksr.com/v1/test?client_id=deadbeef&extra=1&key=value&oauth_token=cafebeef",
                   request.URL?.absoluteString)
    XCTAssertEqual(
      ["Kickstarter-iOS-App": "1234567890", "Authorization": "token cafebeef", "Accept-Language": "ksr",
        "Kickstarter-App-Id": "com.kickstarter.test"],
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
      ["Kickstarter-iOS-App": "1234567890", "Authorization": "token cafebeef", "Accept-Language": "ksr",
        "Kickstarter-App-Id": "com.kickstarter.test"],
      request.allHTTPHeaderFields!
    )
    XCTAssertEqual("DELETE", request.HTTPMethod)
  }

  func testPreparedPostURL() {
    let URL = NSURL(string: "http://api.ksr.com/v1/test?key=value") ?? NSURL()
    let request = self.service.preparedRequest(forURL: URL, method: .POST, query: ["extra": "1"])

    XCTAssertEqual("http://api.ksr.com/v1/test?client_id=deadbeef&key=value&oauth_token=cafebeef",
                   request.URL?.absoluteString)
    XCTAssertEqual(
      ["Kickstarter-iOS-App": "1234567890", "Authorization": "token cafebeef", "Accept-Language": "ksr",
        "Kickstarter-App-Id": "com.kickstarter.test",
       "Content-Type": "application/json; charset=utf-8"],
      request.allHTTPHeaderFields!
    )
    XCTAssertEqual("POST", request.HTTPMethod)
    XCTAssertEqual("{\"extra\":\"1\"}",
                   String(data: request.HTTPBody ?? NSData(), encoding: NSUTF8StringEncoding))
  }

  func testPreparedPostURLWithBody() {
    let URL = NSURL(string: "http://api.ksr.com/v1/test?key=value") ?? NSURL()
    let baseRequest = NSMutableURLRequest(URL: URL)
    let body = "test".dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)
    baseRequest.HTTPBody = body
    baseRequest.HTTPMethod = "POST"
    let request = self.service.preparedRequest(forRequest: baseRequest, query: ["extra": "1"])

    XCTAssertEqual("http://api.ksr.com/v1/test?client_id=deadbeef&key=value&oauth_token=cafebeef",
                   request.URL?.absoluteString)
    XCTAssertEqual(
      ["Kickstarter-iOS-App": "1234567890", "Authorization": "token cafebeef", "Accept-Language": "ksr",
        "Kickstarter-App-Id": "com.kickstarter.test"],
      request.allHTTPHeaderFields!
    )
    XCTAssertEqual("POST", request.HTTPMethod)
    XCTAssertEqual(body, request.HTTPBody, "Body remains unchanged")
  }

  func testPreparedAdHocWithoutOauthToken() {
    let URL = NSURL(string: "http://api-hq.ksr.com/v1/test?key=value") ?? NSURL()
    let request = anonAdHocService.preparedRequest(forRequest: .init(URL: URL))

    XCTAssertEqual("http://api-hq.ksr.com/v1/test?client_id=deadbeef&key=value", request.URL?.absoluteString)
    XCTAssertEqual(
      ["Kickstarter-iOS-App": "1", "Authorization": "Basic dXNlcm5hbWU6cGFzc3dvcmQ=",
        "Accept-Language": "en", "Kickstarter-App-Id": "com.kickstarter.test"],
      request.allHTTPHeaderFields!
    )
  }

  func testPreparedRequestWithoutOauthToken() {
    let anonService = Service(
      appId: "com.kickstarter.test",
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
        "Accept-Language": "en", "Kickstarter-App-Id": "com.kickstarter.test"],
      request.allHTTPHeaderFields!
    )
  }
}
