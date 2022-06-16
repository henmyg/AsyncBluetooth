// swift-tools-version: 5.6
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "AsyncBle",
    platforms: [.iOS(.v13)],
    products: [
        .library(name: "CoreBluetoothWrapper", targets: ["CoreBluetoothWrapper"]),
    ],
    dependencies: [
        .package(url: "https://github.com/henmyg/Utils.git", from: "0.0.0")
    ],
    targets: [
        .target(
            name: "CoreBluetoothWrapper",
            dependencies: ["Utils"]),
        .testTarget(
            name: "CoreBluetoothWrapperTests",
            dependencies: ["CoreBluetoothWrapper"]),
    ]
)
