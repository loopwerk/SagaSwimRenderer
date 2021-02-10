# SagaSwimWriter

A renderer for [Saga](https://github.com/loopwerk/Saga) that uses [Swim](https://github.com/robb/Swim) to turn a RenderingContext into a String.

It comes with a free function named `swim` which takes a function that goes from `RenderingContext` to `Node`, and turns it into a function that goes from `RenderingContext` to `String`, which can then be plugged into Saga's writers - which take functions of signature `(RenderingContext) -> String`.

## Example
The best example is Saga's [Example project](https://github.com/loopwerk/Saga/tree/main/Example/Sources/Example).

TLDR;

Package.json

``` swift
// swift-tools-version:5.3

import PackageDescription

let package = Package(
  name: "Example",
  platforms: [
    .macOS(.v10_15)
  ],
  dependencies: [
    .package(url: "https://github.com/loopwerk/Saga", from: "0.14.0"),
    .package(url: "https://github.com/loopwerk/SagaSwimRenderer", from: "0.1.0")
  ],
  targets: [
    .target(
      name: "Example",
      dependencies: [
        "Saga",
        "SagaSwimRenderer"
      ]
    ),
  ]
)
```

main.swift:

``` swift
import Saga
import SagaSwimRenderer

try Saga(input: "content", output: "deploy", siteMetadata: EmptyMetadata())
  .register(
    metadata: EmptyMetadata.self,
    readers: [.markdownReader()],
    writers: [
      .pageWriter(swim(renderPage))
    ]
  )
```

And your `renderPage` template:

``` swift
func renderPage(context: PageRenderingContext<EmptyMetadata, SiteMetadata>) -> Node {
  html(lang: "en-US") {
    body {
      div(id: "page") {
        h1 { context.page.title }
        context.page.body
      }
    }
  }
}
```