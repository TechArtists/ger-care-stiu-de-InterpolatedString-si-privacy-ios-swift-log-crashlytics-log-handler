// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SwiftLogCrashlyticsLogHandler",
    platforms: [ .iOS(.v14), .macOS(.v10_13)],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "SwiftLogCrashlyticsLogHandler",
            targets: ["SwiftLogCrashlyticsLogHandler"]),
    ],
    dependencies: [
        .package(
            url: "https://github.com/firebase/firebase-ios-sdk.git",
            .upToNextMajor(from: "10.0.0")
        ),
        .package(
            url: "https://github.com/apple/swift-log.git",
            from: "1.6.1"
        )
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "SwiftLogCrashlyticsLogHandler",
            dependencies: [
                .product(name:"FirebaseCore", package: "firebase-ios-sdk"),
                .product(name:"FirebaseCrashlytics", package: "firebase-ios-sdk"),
                .product(name: "Logging", package: "swift-log")
            ]
        ),
        .testTarget(
            name: "SwiftLogCrashlyticsLogHandlerTests",
            dependencies: ["SwiftLogCrashlyticsLogHandler"]
        ),
    ]
)
