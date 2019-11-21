// swift-tools-version:5.0

import PackageDescription

let package = Package(
    name: "Ylert",
    products: [
        .library(
            name: "Ylert",
            targets: ["Ylert"])
    ],
    targets: [
        .target(name: "Ylert", path: "Source")
    ],
    swiftLanguageVersions: [.v5]
)
