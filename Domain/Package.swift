// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Domain",
    platforms: [.iOS(.v13)],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "Entities",
            targets: ["Entities"]),
        .library(
            name: "Interfaces",
            targets: ["Interfaces"]),
        .library(
            name: "UseCases",
            targets: ["UseCases"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
        .package(path: "../TestUtil"),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "Entities",
            dependencies: []),
        .target(
            name: "Interfaces",
            dependencies: ["Entities"]),
        .target(
            name: "UseCases",
            dependencies: [
                "Entities",
                "Interfaces"
            ]),
        .testTarget(
            name: "UseCasesTests",
            dependencies: [
                "UseCases",
                .product(name: "TestExtension", package: "TestUtil"),
            ]),
    ]
)
