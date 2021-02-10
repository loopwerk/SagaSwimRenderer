import HTML

public extension Node {
  func toString() -> String {
    var result = ""
    self.write(to: &result)
    return result
  }
}
