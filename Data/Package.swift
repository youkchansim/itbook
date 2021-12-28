// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Data",
    platforms: [.iOS(.v13)],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "Repositories",
            targets: ["Repositories"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
        .package(path: "../Domain"),
        .package(path: "../Network"),
        .package(path: "../TestUtil"),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "DTO",
            dependencies: [
                .product(name: "Entities", package: "Domain"),
            ]),
        .target(
            name: "Repositories",
            dependencies: [
                .target(name: "DTO"),
                .product(name: "Interfaces", package: "Domain"),
                .product(name: "Entities", package: "Domain"),
                .product(name: "Network", package: "Network"),
                .product(name: "Targets", package: "Network"),
            ]),
        .testTarget(
            name: "DTOTests",
            dependencies: [
                "DTO"
            ]),
        .testTarget(
            name: "RepositoryTests",
            dependencies: [
                "Repositories",
                .product(name: "TestExtension", package: "TestUtil"),
            ]),
    ]
)
