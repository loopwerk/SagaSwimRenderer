import HTML

public func swim<Context>(_ templateFunction: @escaping (Context) -> NodeConvertible) -> ((Context) -> String) {
  return { context in
    let node = templateFunction(context)
    return node.asNode().toString()
  }
}
