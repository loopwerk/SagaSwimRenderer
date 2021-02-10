// swift-tools-version:5.2

import PackageDescription

let package = Package(
  name: "SagaSwimRenderer",
  products: [
    .library(
      name: "SagaSwimRenderer",
      targets: ["SagaSwimRenderer"]),
  ],
  dependencies: [
    .package(name: "HTML", url: "https://github.com/robb/Swim", from: "0.1.1"),
  ],
  targets: [
    .target(
      name: "SagaSwimRenderer",
      dependencies: [
        "HTML",
      ]),
    .testTarget(
      name: "SagaSwimRendererTests",
      dependencies: ["SagaSwimRenderer"]),
  ]
)
