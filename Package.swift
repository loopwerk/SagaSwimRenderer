// swift-tools-version:6.0

import PackageDescription

let package = Package(
  name: "SagaSwimRenderer",
  platforms: [
    .macOS(.v14),
  ],
  products: [
    .library(
      name: "SagaSwimRenderer",
      targets: ["SagaSwimRenderer"]
    ),
  ],
  dependencies: [
    .package(url: "https://github.com/loopwerk/Saga.git", "2.0.3"..<"4.0.0"),
    .package(url: "https://github.com/robb/Swim", from: "0.3.0"),
  ],
  targets: [
    .target(
      name: "SagaSwimRenderer",
      dependencies: [
        "Saga",
        .product(name: "HTML", package: "Swim"),
      ]
    ),
    .testTarget(
      name: "SagaSwimRendererTests",
      dependencies: ["SagaSwimRenderer"]
    ),
  ]
)
