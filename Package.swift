// swift-tools-version:5.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Iterators",
    products: [
        .library(
            name: "Iterators",
            targets: ["Iterators"]
        ),
    ],
    dependencies: [
    ],
    targets: [
        .target(
            name: "Iterators",
            dependencies: []
        ),
        .testTarget(
            name: "IteratorsTests",
            dependencies: ["Iterators"]
        ),
    ]
)
