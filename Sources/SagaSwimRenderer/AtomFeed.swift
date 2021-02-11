import Foundation
import HTML
import Saga

public struct AtomFeed {
  let dateFormatter = ISO8601DateFormatter()
  let title: String
  let author: String
  let baseURL: URL /// the base path of your website, for example https://www.loopwerk.io
  let pagesPath: String /// the relative path of your list of pages, for example articles/
  let feedPath: String /// the relative path where this feed will be hosted, for example articles/feed.xml
  let pages: [AnyPage]
  let summary: ((AnyPage) -> String?)?

  public init(title: String, author: String, baseURL: URL, pagesPath: String, feedPath: String, pages: [AnyPage], summary: ((AnyPage) -> String?)? = nil) {
    self.title = title
    self.author = author
    self.baseURL = baseURL
    self.pagesPath = pagesPath
    self.feedPath = feedPath
    self.pages = pages
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
        baseURL.appendingPathComponent(pagesPath).absoluteString
      }
      link(href: baseURL.appendingPathComponent(feedPath).absoluteString, rel: "self")
      link(href: baseURL.appendingPathComponent(pagesPath).absoluteString)
      updated {
        Date()
      }
      pages.map { page in
        entry {
          title {
            page.title.escapedXMLCharacters
          }
          id {
            baseURL.appendingPathComponent(page.url).absoluteString
          }
          link(href: baseURL.appendingPathComponent(page.url).absoluteString, rel: "alternate")
          updated {
            page.date
          }

          if let summaryString = self.summary?(page) {
            summary {
              summaryString.escapedXMLCharacters
            }
          }

          content(type: "html") {
            Node.text("<![CDATA[")
            page.body
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
