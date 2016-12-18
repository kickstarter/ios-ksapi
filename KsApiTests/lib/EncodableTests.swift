import XCTest
@testable import KsApi

final class EncodableTests: XCTestCase {

  struct EncodableModel: EncodableType {
    let id: Int
    let name: String
    func encode() -> [String:AnyObject] {
      return ["ID": self.id as AnyObject, "NAME": self.name as AnyObject]
    }
  }

  func testToJSONString() {
    let model = EncodableModel(id: 1, name: "Blob")
    XCTAssertEqual(model.toJSONString(), "{\"ID\":1,\"NAME\":\"Blob\"}")
  }

  func testToJSONData() {
    let model = EncodableModel(id: 1, name: "Blob")
    let jsonString = "{\"ID\":1,\"NAME\":\"Blob\"}"
    let jsonData = jsonString.data(using: String.Encoding.utf8)

    XCTAssertEqual(model.toJSONData(), jsonData)
  }
}
