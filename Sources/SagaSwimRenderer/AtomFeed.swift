import Foundation
import HTML
import Saga

public struct AtomFeed {
  let dateFormatter = ISO8601DateFormatter()
  let title: String
  let author: String
  let baseURL: URL /// the base URL of your website, for example https://www.loopwerk.io
  let pagePath: String /// the relative path of your page of items, for example articles/
  let feedPath: String /// the relative path where this feed will be hosted, for example articles/feed.xml
  let items: [AnyItem]
  let summary: ((AnyItem) -> String?)?

  public init(title: String, author: String, baseURL: URL, pagePath: String, feedPath: String, items: [AnyItem], summary: ((AnyItem) -> String?)? = nil) {
    self.title = title
    self.author = author
    self.baseURL = baseURL
    self.pagePath = pagePath
    self.feedPath = feedPath
    self.items = items
    self.summary = summary
  }

  public func node() -> Node {
    feed(xmlns: "http://www.w3.org/2005/Atom") {
      author {
        name {
          self.author
        }
      }
      title {
        self.title
      }
      id {
        baseURL.appendingPathComponent(pagePath).absoluteString
      }
      link(href: baseURL.appendingPathComponent(feedPath).absoluteString, rel: "self")
      link(href: baseURL.appendingPathComponent(pagePath).absoluteString)
      updated {
        Date()
      }
      items.map { item in
        entry {
          title {
            item.title.escapedXMLCharacters
          }
          id {
            baseURL.appendingPathComponent(item.url).absoluteString
          }
          link(href: baseURL.appendingPathComponent(item.url).absoluteString, rel: "alternate")
          updated {
            item.date
          }

          if let summaryString = self.summary?(item) {
            summary {
              summaryString.escapedXMLCharacters
            }
          }

          content(type: "html") {
            Node.text("<![CDATA[")
            item.body
            Node.text("]]>")
          }
        }
      }
    }
  }
}

public extension AtomFeed {
  func feed(xmlns: String, @NodeBuilder children: () -> NodeConvertible) -> Node {
    .element("feed", [ "xmlns": xmlns ], children().asNode())
  }

  func author(@NodeBuilder children: () -> NodeConvertible) -> Node {
    .element("author", [:], children().asNode())
  }

  func name(children: () -> String) -> Node {
    .element("name", [:], children().asNode())
  }

  func title(type: String = "text", children: () -> String) -> Node {
    .element("title", [ "type": type ], %children().asNode()%)
  }

  func id(children: () -> String) -> Node {
    .element("id", [:], %children().asNode()%)
  }

  func updated(date: () -> Date) -> Node {
    .element("updated", [:], %.text(dateFormatter.string(from: date()))%)
  }

  func entry(@NodeBuilder children: () -> NodeConvertible) -> Node {
    .element("entry", [:], children().asNode())
  }

  func link(href: String) -> Node {
    .element("link", [ "href": href ], [])
  }

  func link(href: String, rel: String) -> Node {
    .element("link", [ "href": href, "rel": rel ], [])
  }

  func summary(type: String = "text", children: () -> String) -> Node {
    .element("summary", [ "type": type ], children().asNode())
  }

  func content(type: String = "text", @NodeBuilder children: () -> NodeConvertible) -> Node {
    .element("content", [ "type": type ], children().asNode())
  }
}
