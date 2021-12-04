// swift-tools-version:5.5

import PackageDescription

let package = Package(
  name: "SagaSwimRenderer",
  platforms: [
    .macOS(.v12)
  ],
  products: [
    .library(
      name: "SagaSwimRenderer",
      targets: ["SagaSwimRenderer"]),
  ],
  dependencies: [
    .package(name: "Saga", url: "https://github.com/loopwerk/Saga.git", from: "0.22.0"),
    .package(name: "HTML", url: "https://github.com/robb/Swim", from: "0.2.0"),
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
