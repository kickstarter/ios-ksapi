// Define `==` on arrays of equatable optionals.
internal func == <A: Equatable> (lhs: [A?], rhs: [A?]) -> Bool {
  guard lhs.count == rhs.count else {
    return false
  }

  return zip(lhs, rhs).reduce(true) { accum, lr in accum && lr.0 == lr.1 }
}
