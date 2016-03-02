import XCTest
@testable import KsApi
import struct ReactiveCocoa.SignalProducer
import enum Result.NoError

extension Int: ErrorType {}

class SignalProducer_FailOnNil_Tests: XCTestCase {

  func testFailOnNil_NeverNil() {

    let producer = SignalProducer<Int?, Int>(values: [1, 2, 3])

    var values: [Int?] = []
    var error: Int? = nil
    producer.failOnNil(1).start { event in
      error = event.error
      if let value = event.value {
        values.append(value)
      }
    }

    let expected: [Int?] = [1, 2, 3]
    XCTAssertTrue(expected == values)
    XCTAssertEqual(nil, error)
  }

  func testFailOnNil_HasNil() {

    let producer = SignalProducer<Int?, Int>(values: [1, 2, 3, nil, 4])

    var values: [Int?] = []
    var error: Int? = nil
    producer.failOnNil(1).start { event in
      error = event.error
      if let value = event.value {
        values.append(value)
      }
    }

    let expected: [Int?] = [1, 2, 3]
    XCTAssertTrue(expected == values)
    XCTAssertEqual(1, error)
  }
}
