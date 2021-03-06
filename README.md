# SagaSwimRenderer
A renderer for [Saga](https://github.com/loopwerk/Saga) that uses [Swim](https://github.com/robb/Swim) to turn a RenderingContext into a String.

It comes with a free function named `swim` which takes a function that goes from `RenderingContext` to `Node`, and turns it into a function that goes from `RenderingContext` to `String`, which can then be plugged into Saga's writers — which take functions of signature `(RenderingContext) -> String`.

## Example
The best example is Saga's [Example project](https://github.com/loopwerk/Saga/tree/main/Example/Sources/Example).

TLDR;

Package.swift

``` swift
// swift-tools-version:5.2

import PackageDescription

let package = Package(
  name: "Example",
  platforms: [
    .macOS(.v10_15)
  ],
  dependencies: [
    .package(url: "https://github.com/loopwerk/Saga", from: "0.19.0"),
    .package(url: "https://github.com/loopwerk/SagaParsleyMarkdownReader", from: "0.4.0"),
    .package(url: "https://github.com/loopwerk/SagaSwimRenderer", from: "0.4.0")
  ],
  targets: [
    .target(
      name: "Example",
      dependencies: [
        "Saga",
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

try Saga(input: "content", output: "deploy", siteMetadata: EmptyMetadata())
  .register(
    metadata: EmptyMetadata.self,
    readers: [.parsleyMarkdownReader()],
    writers: [
      .itemWriter(swim(renderItem))
    ]
  )
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
