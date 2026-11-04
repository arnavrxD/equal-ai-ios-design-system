// swift-tools-version:5.9
import PackageDescription

let package = Package(
    name: "EqualDesignSystem",
    defaultLocalization: "en",
    platforms: [.iOS(.v17), .macOS(.v14)],
    products: [
        .library(name: "EqualDesignSystem", targets: ["EqualDesignSystem"])
    ],
    targets: [
        .executableTarget(
            name: "equal-snapshots",
            dependencies: ["EqualDesignSystem"],
            path: "Tools/Snapshots"
        ),
        .target(
            name: "EqualDesignSystem",
            resources: [
                .process("Resources/Images"),
                .copy("Resources/Fonts")
            ]
        )
    ]
)
