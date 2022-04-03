import Foundation
import Saga
import PathKit
import SagaParsleyMarkdownReader
import SagaSwimRenderer

// SiteMetadata is given to every template.
// You can put whatever you want in here, as long as it's Decodable.
struct SiteMetadata: Metadata {
  let url: URL
  let name: String
}

let siteMetadata = SiteMetadata(
  url: URL(string: "http://www.example.com")!,
  name: "Example website"
)

@main
struct Run {
  static func main() async throws {
    try await Saga(input: "content", output: "deploy", siteMetadata: siteMetadata)
      // All the Markdown files will be parsed to html,
      // using the default EmptyMetadata as the Item's metadata type.
      .register(
        metadata: EmptyMetadata.self,
        readers: [.parsleyMarkdownReader()],
        itemWriteMode: .keepAsFile,
        writers: [
          .itemWriter(swim(renderPage))
        ]
      )

      // Run the steps we registered above
      .run()

      // All the remaining files that were not parsed to markdown, so for example images, raw html files and css,
      // are copied as-is to the output folder.
      .staticFiles()
  }
}
