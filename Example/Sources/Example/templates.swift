import HTML
import Saga
import SagaSwimRenderer
import Foundation

func baseHtml(title pageTitle: String, @NodeBuilder children: () -> NodeConvertible) -> Node {
  html(lang: "en-US") {
    head {
      title { "\(SiteMetadata.name): \(pageTitle)" }
      link(href: "/static/style.css", rel: "stylesheet")
    }
    body {
      nav {
        a(href: "/") { "Home" }
        a(href: "/about") { "About" }
      }
      div(id: "content") {
        children()
      }
    }
  }
}

func renderPage(context: ItemRenderingContext<EmptyMetadata>) -> Node {
  baseHtml(title: context.item.title) {
    div(id: "page") {
      h1 { context.item.title }
      Node.raw(context.item.body)
    }
  }
}
