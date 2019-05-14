//
//  STPhotoMapSeeds.swift
//  STPhotoMapTests-iOS
//
//  Created by Dimitri Strauneanu on 14/05/2019.
//  Copyright © 2019 mikelanza. All rights reserved.
//

@testable import STPhotoMap

enum STPhotoMapSeedsError: Error {
    case noResourceAvailable
    case noDataAvailable
    case noObjectAvailable
}

class STPhotoMapSeeds: NSObject {
    static let
    tileCoordinate: TileCoordinate = TileCoordinate(zoom: 10, x: 1, y: 2),
    tileCoordinates: [TileCoordinate] = [TileCoordinate(zoom: 10, x: 1, y: 2), TileCoordinate(zoom: 11, x: 2, y: 3)]
    
    func geojsonObject() throws -> GeoJSONObject {
        let bundle = Bundle(for: type(of: self))
        guard let path = bundle.path(forResource: "geojsonobject", ofType: "json") else {
            throw STPhotoMapSeedsError.noResourceAvailable
        }
        let url = URL(fileURLWithPath: path)
        let data = try Data(contentsOf: url)
        guard let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] else {
            throw STPhotoMapSeedsError.noDataAvailable
        }
        guard let geojsonObject = GeoJSON().parse(geoJSON: json) else {
            throw STPhotoMapSeedsError.noObjectAvailable
        }
        return geojsonObject
    }
}
