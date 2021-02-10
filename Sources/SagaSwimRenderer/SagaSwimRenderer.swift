import HTML

public func swim<Context>(_ templateFunction: @escaping (Context) -> Node) -> ((Context) -> String) {
  return { context in
    let node = templateFunction(context)
    return node.toString()
  }
}
