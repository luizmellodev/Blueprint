// swift-tools-version:6.0

import PackageDescription

let package = Package(
  name: "Website",
  platforms: [
    .macOS(.v14),
  ],
  products: [
    .executable(name: "Website", targets: ["Website"]),
  ],
  dependencies: [
    .package(url: "https://github.com/loopwerk/Saga", from: "3.0.0"),
    .package(url: "https://github.com/loopwerk/SagaParsleyMarkdownReader", from: "1.0.0"),
    .package(url: "https://github.com/loopwerk/SagaSwimRenderer", from: "1.0.0"),
    .package(url: "https://github.com/loopwerk/Moon", from: "1.0.0"),
  ],
  targets: [
    .executableTarget(
      name: "Website",
      dependencies: [
        "Saga",
        "SagaParsleyMarkdownReader",
        "SagaSwimRenderer",
        "Moon",
      ]
    ),
  ]
)