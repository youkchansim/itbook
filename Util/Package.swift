// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Util",
    platforms: [.iOS(.v13)],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "Extension",
            targets: ["Extension"]),
        .library(
            name: "Cache",
            targets: ["Cache"]),
        .library(
            name: "Image",
            targets: ["Image"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
        .package(path: "../Network"),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "Extension",
            dependencies: []),
        .target(
            name: "Cache",
            dependencies: []),
        .target(
            name: "Image",
            dependencies: [
                "Cache",
                .product(name: "Network", package: "Network"),
            ]),
        .testTarget(
            name: "CacheTests",
            dependencies: [
                "Cache"
            ]),
        .testTarget(
            name: "ImageTests",
            dependencies: [
                "Image",
                "Extension",
            ]),
    ]
)
