// swift-tools-version:5.0

import PackageDescription

let package = Package(
    name: "Swiftbrew",
    platforms: [
        .macOS(.v10_10)
    ],
    products: [
        .executable(name: "swift-brew", targets: ["Swiftbrew"])
    ],
    dependencies: [
        .package(url: "https://github.com/JustHTTP/Just.git",  .upToNextMajor(from: "0.7.0")),
        .package(url: "https://github.com/getGuaka/Colorizer.git", .upToNextMajor(from: "0.2.1")),
        .package(url: "https://github.com/getGuaka/Run.git", .upToNextMajor(from: "0.1.1")),
        .package(url: "https://github.com/nsomar/Guaka.git", .upToNextMajor(from: "0.4.1")),
        .package(url: "https://github.com/yonaskolb/Mint.git", .upToNextMajor(from: "0.12.0")),

        // SwiftCLI 5.3.0 doesn't build. This locks it to 5.2.x.
        // This is a transitive dependency of Mint. We're not using this.
        .package(url: "https://github.com/jakeheis/SwiftCLI.git", .upToNextMinor(from: "5.2.2")),
    ],
    targets: [
        .target(
            name: "Swiftbrew",
            dependencies: ["Guaka", "SwiftbrewCore"]),
        .target(
            name: "SwiftbrewCore",
            dependencies: ["Colorizer", "Just", "MintKit", "Run"]),
        .testTarget(
            name: "SwiftbrewTests",
            dependencies: ["Swiftbrew"]),
    ]
)
