import Foundation
import Saga
import SagaParsleyMarkdownReader
import SagaSwimRenderer

enum SiteMetadata {
  static let url = URL(string: "http://www.example.com")!
  static let name = "Example website"
}

try await Saga(input: "content", output: "deploy")
  // All the Markdown files will be parsed to html,
  // using the default EmptyMetadata as the Item's metadata type.
  .register(
    metadata: EmptyMetadata.self,
    readers: [.parsleyMarkdownReader()],
    itemWriteMode: .keepAsFile,
    writers: [
      .itemWriter(swim(renderPage)),
    ]
  )

  // Run the steps we registered above
  .run()
