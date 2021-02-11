// swift-tools-version:5.2

import PackageDescription

let package = Package(
  name: "SagaSwimRenderer",
  platforms: [
    .macOS(.v10_12)
  ],
  products: [
    .library(
      name: "SagaSwimRenderer",
      targets: ["SagaSwimRenderer"]),
  ],
  dependencies: [
    .package(name: "Saga", url: "https://github.com/loopwerk/Saga.git", from: "0.14.0"),
    .package(name: "HTML", url: "https://github.com/robb/Swim", from: "0.1.1"),
  ],
  targets: [
    .target(
      name: "SagaSwimRenderer",
      dependencies: [
        "Saga",
        "HTML",
      ]),
    .testTarget(
      name: "SagaSwimRendererTests",
      dependencies: ["SagaSwimRenderer"]),
  ]
)
