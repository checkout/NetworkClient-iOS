// swift-tools-version: 5.6
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "CheckoutNetwork",
    products: [
        .library(
            name: "CheckoutNetwork",
            targets: ["CheckoutNetwork"]),
        // Use in Unit tests to ensure your client requests are formatted correctly for the Checkout Network Client
        .library(
            name: "CheckoutNetworkFakeClient",
            targets: ["CheckoutNetworkFakeClient"])
    ],
    targets: [
        .target(
            name: "CheckoutNetwork"),
        .target(
            name: "CheckoutNetworkFakeClient",
            dependencies: ["CheckoutNetwork"]),
        .testTarget(
            name: "CheckoutNetworkTests",
            dependencies: ["CheckoutNetwork"]),
    ]
)
