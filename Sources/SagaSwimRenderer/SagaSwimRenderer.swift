import HTML

@preconcurrency
public func swim<Context>(_ templateFunction: @Sendable @escaping (Context) -> NodeConvertible) -> (@Sendable (Context) -> String) {
  return { @Sendable context in
    let node = templateFunction(context)
    return node.asNode().toString()
  }
}
