// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "IDScanIDDetector",
    platforms: [
        .iOS(.v12)
    ],
    products: [
        .library(
            name: "IDScanPDFDetector",
            targets: ["IDScanPDFDetector"]),
        .library(
            name: "IDScanMRZDetector",
            targets: ["IDScanMRZDetector"]),
    ],
    targets: [
        .binaryTarget(
            name: "IDScanPDFDetector",
            path: "Libs/IDScanPDFDetector.xcframework"
        ),
        .binaryTarget(
            name: "IDScanMRZDetector",
            path: "Libs/IDScanMRZDetector.xcframework"
        ),
        .testTarget(
            name: "IDScanIDDetectorTests",
            dependencies: [
                "IDScanPDFDetector",
                "IDScanMRZDetector"
            ]
        ),
    ]
)
