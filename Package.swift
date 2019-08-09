// swift-tools-version:5.0
//
//  STPhotoMap.swift
//  STPhotoMap
//
//  Created by Streetography on 01/04/19.
//  Copyright © 2019 mikelanza. All rights reserved.
//

import PackageDescription

let package = Package(
    name: "STPhotoMap",
    platforms: [
        .iOS(.v11)
    ],
    products: [
        .library(
            name: "STPhotoMap",
            targets: ["STPhotoMap"]
        ),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
        .package(url: "https://github.com/onevcat/Kingfisher.git", .upToNextMajor(from: "5.0")),
        .package(url: "https://github.com/mikelanza/st-photo-core-ios.git", .upToNextMajor(from: "0.1.1")),
        .package(url: "https://github.com/mikelanza/st-photo-details-ios.git", .upToNextMajor(from: "0.0.7"))
    ],
    targets: [
        .target(
            name: "STPhotoMap",
            dependencies: [],
            path: "Sources"
        ),
        .testTarget(
            name: "STPhotoMapTests",
            dependencies: ["STPhotoMap"],
            path: "Tests"
        ),
    ],
    swiftLanguageVersions: [.v5]
)
