import Foundation
import Saga
import SagaParsleyMarkdownReader
import SagaSwimRenderer

struct ChapterMetadata: Metadata {
  let summary: String?
  let chapter: Int
  let status: String?
}

try await Saga(input: "../Documentation", output: "deploy")
  .register(
    folder: "chapters",
    metadata: ChapterMetadata.self,
    readers: [.parsleyMarkdownReader],
    sorting: { $0.metadata.chapter < $1.metadata.chapter },
    writers: [
      .itemWriter(swim(renderChapter)),
      .listWriter(swim(renderChapterIndex), output: "index.html"),
    ]
  )
  .register(
    metadata: EmptyMetadata.self,
    readers: [.parsleyMarkdownReader],
    writers: [.itemWriter(swim(renderPage))]
  )
  .run()
