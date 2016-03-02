/**
 Free function for parsing raw `NSData` into raw JSON.
*/
internal func parseJSONData(data: NSData) -> AnyObject? {
  do {
    return try NSJSONSerialization.JSONObjectWithData(data, options: [])
  } catch {
    return nil
  }
}
