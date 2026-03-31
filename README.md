# SagaSwimRenderer
A renderer for [Saga](https://github.com/loopwerk/Saga) that uses [Swim](https://github.com/robb/Swim) to turn a RenderingContext into a String.

It comes with a free function named `swim` which takes a function that goes from `RenderingContext` to `Node`, and turns it into a function that goes from `RenderingContext` to `String`, which can then be plugged into Saga's writers — which take functions of signature `(RenderingContext) -> String`.

## Example
The best example is Saga's [Example project](https://github.com/loopwerk/Saga/tree/main/Example/Sources/Example), although a simplified example app is [included in this repo](https://github.com/loopwerk/SagaSwimRenderer/tree/main/Example).

TLDR;

Package.swift

``` swift
// swift-tools-version:6.0

import PackageDescription

let package = Package(
  name: "Example",
  platforms: [
    .macOS(.v14)
  ],
  dependencies: [
    .package(url: "https://github.com/loopwerk/SagaParsleyMarkdownReader", from: "1.0.0"),
    .package(url: "https://github.com/loopwerk/SagaSwimRenderer", from: "1.0.0")
  ],
  targets: [
    .target(
      name: "Example",
      dependencies: [
        "SagaParsleyMarkdownReader",
        "SagaSwimRenderer"
      ]
    ),
  ]
)
```

main.swift:

``` swift
import Saga
import SagaParsleyMarkdownReader
import SagaSwimRenderer

try await Saga(input: "content", output: "deploy")
  .register(
    metadata: EmptyMetadata.self,
    readers: [.parsleyMarkdownReader()],
    writers: [
      .itemWriter(swim(renderItem))
    ]
  )

  // Run the steps we registered above
  .run()
```

And your `renderItem` template:

``` swift
func renderItem(context: ItemRenderingContext<EmptyMetadata, SiteMetadata>) -> Node {
  html(lang: "en-US") {
    body {
      div(id: "item") {
        h1 { context.item.title }
        context.item.body
      }
    }
  }
}
```
