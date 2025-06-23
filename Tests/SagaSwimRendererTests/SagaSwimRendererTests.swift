import Foundation
import HTML
import PathKit
@testable import Saga
@testable import SagaSwimRenderer
import XCTest

final class SagaSwimRendererTests: XCTestCase {
  private func normalizeWhitespace(_ html: String) -> String {
    return html
      .replacingOccurrences(of: "\n", with: "")
      .replacingOccurrences(of: "\t", with: "")
      .replacingOccurrences(of: "  ", with: " ")
      .replacingOccurrences(of: "  ", with: " ")
      .replacingOccurrences(of: "  ", with: " ")
      .replacingOccurrences(of: "> <", with: "><")
      .trimmingCharacters(in: .whitespaces)
  }

  func testSwimRenderer() {
    let templateFunction: (String) -> NodeConvertible = { context in
      div {
        h1 { "Hello, \(context)!" }
        p { "This is a test." }
      }
    }

    let renderer = swim(templateFunction)
    let result = renderer("World")
    let normalized = normalizeWhitespace(result)

    XCTAssertEqual(normalized, "<div><h1>Hello, World!</h1><p>This is a test.</p></div>")
  }

  func testSwimRendererWithComplexHTML() {
    let templateFunction: (String) -> NodeConvertible = { pageTitle in
      html {
        head {
          title { pageTitle }
        }
        body {
          header {
            h1(class: "main-title") { pageTitle }
          }
          main {
            article {
              p { "Content goes here" }
            }
          }
        }
      }
    }

    let renderer = swim(templateFunction)
    let result = renderer("Test Page")
    let normalized = normalizeWhitespace(result)

    let expected = "<html><head><title>Test Page</title></head><body><header><h1 class=\"main-title\">Test Page</h1></header><main><article><p>Content goes here</p></article></main></body></html>"
    XCTAssertEqual(normalized, expected)
  }

  func testSwimRendererWithItemContext() {
    let item = Item<EmptyMetadata>(
      absoluteSource: "root/input/test.md",
      relativeSource: "test.md",
      relativeDestination: "test/index.html",
      title: "Test Article",
      body: "<p>Test content</p>",
      date: Date(),
      lastModified: Date(),
      metadata: EmptyMetadata()
    )

    let context = ItemRenderingContext<EmptyMetadata>(
      item: item,
      items: [item],
      allItems: [],
      resources: []
    )

    let templateFunction: (ItemRenderingContext<EmptyMetadata>) -> NodeConvertible = { context in
      article {
        h1 { context.item.title }
        div(class: "content") {
          Node.raw(context.item.body)
        }
      }
    }

    let renderer = swim(templateFunction)
    let result = renderer(context)
    let normalized = normalizeWhitespace(result)

    let expected = "<article><h1>Test Article</h1><div class=\"content\"><p>Test content</p></div></article>"
    XCTAssertEqual(normalized, expected)
  }

  func testSwimRendererWithListContext() {
    let items = [
      Item<EmptyMetadata>(
        absoluteSource: "root/input/test.md",
        relativeSource: "test.md",
        relativeDestination: "test/index.html",
        title: "Test Article",
        body: "<p>Test content</p>",
        date: Date(),
        lastModified: Date(),
        metadata: EmptyMetadata()
      ),
      Item<EmptyMetadata>(
        absoluteSource: "root/input/test2.md",
        relativeSource: "test2.md",
        relativeDestination: "test2/index.html",
        title: "Another Article",
        body: "<p>More content</p>",
        date: Date(),
        lastModified: Date(),
        metadata: EmptyMetadata()
      ),
    ]

    let context = ItemsRenderingContext<EmptyMetadata>(
      items: items,
      allItems: [],
      paginator: nil,
      outputPath: "output"
    )

    let templateFunction: (ItemsRenderingContext<EmptyMetadata>) -> NodeConvertible = { context in
      ul {
        context.items.map { item in
          li {
            a(href: "/\(item.relativeDestination)") {
              item.title
            }
          }
        }
      }
    }

    let renderer = swim(templateFunction)
    let result = renderer(context)
    let normalized = normalizeWhitespace(result)

    let expected = "<ul><li><a href=\"/test/index.html\">Test Article</a></li><li><a href=\"/test2/index.html\">Another Article</a></li></ul>"
    XCTAssertEqual(normalized, expected)
  }

  func testNodeToStringExtension() {
    let node = Node.element("div", ["class": "test"], [
      Node.element("p", [:], [Node.text("Hello World")]),
    ])

    let result = node.toString()
    let normalized = normalizeWhitespace(result)

    XCTAssertEqual(normalized, "<div class=\"test\"><p>Hello World</p></div>")
  }

  static var allTests = [
    ("testSwimRenderer", testSwimRenderer),
    ("testSwimRendererWithComplexHTML", testSwimRendererWithComplexHTML),
    ("testSwimRendererWithItemContext", testSwimRendererWithItemContext),
    ("testSwimRendererWithListContext", testSwimRendererWithListContext),
    ("testNodeToStringExtension", testNodeToStringExtension),
  ]
}
