infix operator ??= : AssignmentPrecedence

// RIP, SE-0024.
public func ??= <T>(lhs: inout T?, rhs: @autoclosure () throws -> T?) rethrows {
  if lhs == nil {
    lhs = try rhs()
  }
}


// Ergonomic (if ill-advised) loan from Ruby.
public func << <T>(lhs: inout [T], rhs: T) {
  lhs.append(rhs)
}
