import Foundation

/**
 A type that can encode itself into a `[String:AnyObject]` dictionary, usually for then
 serializing to a JSON string.
*/
public protocol EncodableType {
  func encode() -> [String: AnyObject]
}

public extension EncodableType {
  /**
   Returns `NSData` form of encoding.

   - returns: `NSData`
   */
  public func toJSONData() -> NSData? {
    return try? NSJSONSerialization.dataWithJSONObject(encode(), options: [])
  }

  /**
   Returns `String` form of encoding.

   - returns: `String`
   */
  public func toJSONString() -> String? {
    return self.toJSONData().flatMap { String(data: $0, encoding: NSUTF8StringEncoding) }
  }
}
