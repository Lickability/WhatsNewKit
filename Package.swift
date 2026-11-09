// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "WhatsNewKit",
    platforms: [
        .iOS("26.0"),
        .macOS("26.0"),
        .visionOS(.v1)
    ],
    products: [
        .library(
            name: "WhatsNewKit",
            targets: [
                "WhatsNewKit"
            ]
        )
    ],
    targets: [
        .target(
            name: "WhatsNewKit",
            path: "Sources",
            resources: [
                .process("Resources/PrivacyInfo.xcprivacy")
            ]
        ),
        .testTarget(
            name: "WhatsNewKitTests",
            dependencies: [
                "WhatsNewKit"
            ],
            path: "Tests"
        )
    ]
)
