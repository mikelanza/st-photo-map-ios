//
//  STPhotoMapSeeds.swift
//  STPhotoMapTests-iOS
//
//  Created by Dimitri Strauneanu on 14/05/2019.
//  Copyright © 2019 mikelanza. All rights reserved.
//

@testable import STPhotoMap
import MapKit

enum STPhotoMapSeedsError: Error {
    case noResourceAvailable
    case noDataAvailable
    case noObjectAvailable
}

class STPhotoMapSeeds: NSObject {
    static let tileCoordinate: TileCoordinate = TileCoordinate(zoom: 10, x: 1, y: 2)
    static let tileCoordinates: [TileCoordinate] = [
        TileCoordinate(zoom: 10, x: 1, y: 2),
        TileCoordinate(zoom: 11, x: 2, y: 3),
        TileCoordinate(zoom: 12, x: 3, y: 4)
    ]
    static let coordinate: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 50, longitude: 50)
    static let photoAnnotation: PhotoAnnotation = PhotoAnnotation(id: "id", coordinate: STPhotoMapSeeds.coordinate)
    static let multiplePhotoClusterAnnotation = MultiplePhotoClusterAnnotation(photoIds: ["id"], memberAnnotations: [STPhotoMapSeeds.photoAnnotation])
    static let photoTileOverlayModel = STPhotoTileOverlay.Model(url: "url")
    static let photoTileOverlay = STPhotoTileOverlay(model: STPhotoMapSeeds.photoTileOverlayModel)
    
    func geojsonObject() throws -> GeoJSONObject {
        let bundle = Bundle(for: type(of: self))
        guard let path = bundle.path(forResource: "geojson_object", ofType: "json") else {
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
