// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "AVWXKit",
    platforms: [
        .iOS(.v13),
    ],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "AVWXKit",
            targets: ["AVWXKit"]),
    ],
    dependencies: [
        .package(url: "https://github.com/Quick/Quick.git", from: "6.1.0"),
        .package(url: "https://github.com/Quick/Nimble.git", from: "11.2.2"),
        .package(url: "https://github.com/AliSoftware/OHHTTPStubs.git", from: "9.1.0")
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "AVWXKit",
            dependencies: []),
        .testTarget(
            name: "AVWXKitTests",
            dependencies: [
                "AVWXKit",
                "Quick",
                "Nimble",
                .product(name: "OHHTTPStubsSwift", package: "OHHTTPStubs")
            ],
            resources: [
                .process("Resources")
            ]),
    ]
)
