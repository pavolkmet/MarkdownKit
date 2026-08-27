// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "MarkdownKit",
    platforms: [
        .iOS(.v15),
        .macOS(.v12),
    ],
    products: [
        .library(
            name: "MarkdownKit",
            targets: ["MarkdownKit"]
        ),
    ],
    dependencies: [
        .package(
            url: "https://github.com/swiftlang/swift-markdown.git",
            exact: "0.8.0"
        ),
    ],
    targets: [
        .target(
            name: "MarkdownKit",
            dependencies: [
                .product(name: "Markdown", package: "swift-markdown"),
            ],
            path: "Sources/MarkdownKit"
        ),
        .testTarget(
            name: "MarkdownKitTests",
            dependencies: [
                "MarkdownKit",
                .product(name: "Markdown", package: "swift-markdown"),
            ],
            path: "Tests/MarkdownKitTests"
        ),
    ]
)
