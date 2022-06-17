// swift-tools-version: 5.6
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "AsyncBluetooth",
    platforms: [.iOS(.v13)],
    products: [
        .library(name: "CoreBluetoothWrapper", targets: ["CoreBluetoothWrapper"]),
        .library(name: "AsyncBle", targets: ["AsyncBle"]),
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
        .target(
            name: "AsyncBle",
            dependencies: ["CoreBluetoothWrapper", "Utils"]),
        .testTarget(
            name: "AsyncBleTests",
            dependencies: ["AsyncBle"]),
    ]
)
