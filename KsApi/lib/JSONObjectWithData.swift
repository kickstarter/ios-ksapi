internal func parseJSONData(data: NSData) -> AnyObject? {
  do {
    return try NSJSONSerialization.JSONObjectWithData(data, options: [])
  } catch {
    return nil
  }
}
