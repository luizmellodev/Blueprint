import Foundation
import Saga
import SagaParsleyMarkdownReader
import SagaSwimRenderer

struct DocMetadata: Metadata {
  let summary: String?
  let order: Int?
}

struct ADRMetadata: Metadata {
  let summary: String?
  let status: String
  let date: String?
  let order: Int?
}

try await Saga(input: "../Documentation/Content/en", output: "deploy")
  .register(
    folder: "guides",
    metadata: DocMetadata.self,
    readers: [.parsleyMarkdownReader],
    sorting: { ($0.metadata.order ?? 0) < ($1.metadata.order ?? 0) },
    writers: [
      .itemWriter(swim(renderGuide)),
      .listWriter(swim(renderGuideIndex), output: "index.html"),
    ]
  )
  .register(
    folder: "architecture",
    metadata: DocMetadata.self,
    readers: [.parsleyMarkdownReader],
    sorting: { ($0.metadata.order ?? 0) < ($1.metadata.order ?? 0) },
    writers: [
      .itemWriter(swim(renderArchitecture)),
      .listWriter(swim(renderArchitectureIndex), output: "index.html"),
    ]
  )
  .register(
    folder: "concepts",
    metadata: DocMetadata.self,
    readers: [.parsleyMarkdownReader],
    sorting: { ($0.metadata.order ?? 0) < ($1.metadata.order ?? 0) },
    writers: [
      .itemWriter(swim(renderConcept)),
      .listWriter(swim(renderConceptIndex), output: "index.html"),
    ]
  )
  .register(
    folder: "decisions",
    metadata: ADRMetadata.self,
    readers: [.parsleyMarkdownReader],
    sorting: { ($0.metadata.order ?? 0) < ($1.metadata.order ?? 0) },
    writers: [
      .itemWriter(swim(renderADR)),
      .listWriter(swim(renderADRIndex), output: "index.html"),
    ]
  )
  .register(
    metadata: EmptyMetadata.self,
    readers: [.parsleyMarkdownReader],
    writers: [.itemWriter(swim(renderHome))]
  )
  .run()
