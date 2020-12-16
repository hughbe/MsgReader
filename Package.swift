// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "MsgReader",
    products: [
        // Products define the executables and libraries produced by a package, and make them visible to other packages.
        .library(
            name: "MsgReader",
            targets: ["MsgReader"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        .package(url: "https://github.com/hughbe/CompoundFileReader", from: "1.0.0"),
        .package(url: "https://github.com/hughbe/CompressedRtf", from: "1.0.0"),
        .package(url: "https://github.com/hughbe/DataStream", from: "2.0.0"),
        .package(name: "MAPI", url: "https://github.com/hughbe/SwiftMAPI", from: "1.0.0"),
        .package(url: "https://github.com/hughbe/WindowsDataTypes", from: "1.0.0"),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages which this package depends on.
        .target(
            name: "MsgReader",
            dependencies: ["CompoundFileReader", "CompressedRtf", "DataStream", "MAPI", "WindowsDataTypes"]),
        .testTarget(
            name: "MsgReaderTests",
            dependencies: ["MsgReader", "CompressedRtf"],
            resources: [.process("Resources")]),
    ]
)
