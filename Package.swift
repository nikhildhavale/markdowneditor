// swift-tools-version:5.5
import PackageDescription

let package = Package(
    name: "RichTextEditor",
    platforms: [
        .iOS(.v13)
    ],
    products: [
        .library(
            name: "RichTextEditor",
            targets: ["RichTextEditor"]
        )
    ],
    targets: [
        .target(
            name: "RichTextEditor",
            dependencies: [],
            path: "MarkdownEditor/Sources/RichTextEditor"
        )
    ]
)
