import Foundation
import Saga
import SagaParsleyMarkdownReader
import SagaSwimRenderer
import SwiftTailwind

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

let tailwind = SwiftTailwind(version: "4.2.1")

let tailwindInput = "../Documentation/Content/en/static/input.css"
let tailwindOutput = "../Documentation/Content/en/static/output.css"

try await Saga(input: "../Documentation/Content/en", output: "deploy")
  .beforeRead { saga in
    if let path = saga.buildReason.changedFile(),
       path.extension != "css",
       !path.components.contains("Sources")
    {
      return
    }
    try await tailwind.run(
      input: tailwindInput,
      output: tailwindOutput,
      options: .minify
    )
  }
  .ignoreChanges("output.css")
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
    folder: "website",
    metadata: DocMetadata.self,
    readers: [.parsleyMarkdownReader],
    sorting: { ($0.metadata.order ?? 0) < ($1.metadata.order ?? 0) },
    writers: [
      .itemWriter(swim(renderWebsite)),
      .listWriter(swim(renderWebsiteIndex), output: "index.html"),
    ]
  )
  .register(
    metadata: EmptyMetadata.self,
    readers: [.parsleyMarkdownReader],
    writers: [.itemWriter(swim(renderHome))]
  )
  .afterWrite { _ in
    let fileManager = FileManager.default
    try fileManager.createDirectory(atPath: "deploy/static", withIntermediateDirectories: true)
    if fileManager.fileExists(atPath: tailwindOutput) {
      let deployOutput = "deploy/static/output.css"
      if fileManager.fileExists(atPath: deployOutput) {
        try fileManager.removeItem(atPath: deployOutput)
      }
      try fileManager.copyItem(atPath: tailwindOutput, toPath: deployOutput)
    }
    let inputPath = (tailwindInput as NSString).lastPathComponent
    let deployInput = "deploy/static/\(inputPath)"
    if fileManager.fileExists(atPath: deployInput) {
      try fileManager.removeItem(atPath: deployInput)
    }
    if fileManager.fileExists(atPath: "vercel.json") {
      let deployConfig = "deploy/vercel.json"
      if fileManager.fileExists(atPath: deployConfig) {
        try fileManager.removeItem(atPath: deployConfig)
      }
      try """
      {
        "cleanUrls": true,
        "trailingSlash": true
      }
      """.write(toFile: deployConfig, atomically: true, encoding: .utf8)
    }
  }
  .run()
