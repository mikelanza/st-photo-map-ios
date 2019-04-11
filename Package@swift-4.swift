// swift-tools-version:4.0
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
    products: [
        .library(
            name: "STPhotoMap",
            targets: ["STPhotoMap"]
        ),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
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
    swiftLanguageVersions: [4]
)
