//
//  STPhotoMapSeeds.swift
//  STPhotoMapTests-iOS
//
//  Created by Dimitri Strauneanu on 14/05/2019.
//  Copyright © 2019 mikelanza. All rights reserved.
//

@testable import STPhotoMap

struct STPhotoMapSeeds {
    static let
    tileCoordinate: TileCoordinate = TileCoordinate(zoom: 10, x: 1, y: 2),
    tileCoordinates: [TileCoordinate] = [TileCoordinate(zoom: 10, x: 1, y: 2), TileCoordinate(zoom: 11, x: 2, y: 3)]
}
