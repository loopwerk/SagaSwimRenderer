import HTML

public extension Node {
  func toString() -> String {
    var result = ""
    write(to: &result)
    return result
  }
}
