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
    static let photoId: String = "photo_id"
    static let imageUrl: String = "image_url"
    
    static let tileCoordinate: TileCoordinate = TileCoordinate(zoom: 10, x: 1, y: 2)
    static let tileCoordinates: [TileCoordinate] = [
        TileCoordinate(zoom: 10, x: 1, y: 2),
        TileCoordinate(zoom: 11, x: 2, y: 3),
        TileCoordinate(zoom: 12, x: 3, y: 4)
    ]
    
    static let coordinate: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 50, longitude: 50)
    static let location: STLocation = STLocation.from(coordinate: coordinate)
    
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
    
    func locationGeojsonObject() throws -> GeoJSONObject {
        let bundle = Bundle(for: type(of: self))
        guard let path = bundle.path(forResource: "geojson_object_location", ofType: "json") else {
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
    
    func annotations() -> [STPhotoMapModels.Annotation] {
        let firstAnnotation = STPhotoMapModels.Annotation(id: "1", imageUrl: "https://strtgrph.s3-us-west-1.amazonaws.com/processed/964d83ac70036166b4fb43c93516ab25_250_250.jpg", latitude: 37.896175586962535, longitude: -122.5092990375)
        let secondAnnotation = STPhotoMapModels.Annotation(id: "2", imageUrl: "https://strtgrph.s3-us-west-1.amazonaws.com/processed/1575c2eeef87a57256a03b8e6d9d8eec_250_250.jpg", latitude: 37.92717416710873, longitude: -122.51521212095439)
        return [firstAnnotation, secondAnnotation]
    }
    
    func photoAnnotations() -> [PhotoAnnotation] {
        return self.annotations().map({ $0.toPhotoAnnotation() })
    }
    
    func photoAnnotation() -> PhotoAnnotation {
        let annotation = self.photoAnnotations().first!
        annotation.image = UIImage()
        return annotation
    }
    
    func multiplePhotoClusterAnnotation(count: Int, sameCoordinate: Bool = true) -> MultiplePhotoClusterAnnotation {
        var annotations: [PhotoAnnotation] = []
        for i in 0..<count {
            var coordinate: CLLocationCoordinate2D
            if sameCoordinate {
                coordinate = STPhotoMapSeeds.coordinate
            } else {
                coordinate = CLLocationCoordinate2D(latitude: CLLocationDegrees(50 + i), longitude: CLLocationDegrees(50 + i))
            }
            let annotation = PhotoAnnotation(id: String(i), coordinate: coordinate)
            annotations.append(annotation)
        }
        let photoIds = annotations.map({ $0.model.photoId })
        return MultiplePhotoClusterAnnotation(photoIds: photoIds, memberAnnotations: annotations)
    }
    
    func photo() -> STPhoto {
        var photo = STPhoto(id: "photo_id", createdAt: Date())
        photo.user = self.user()
        return photo
    }
    
    func user() -> STUser {
        return STUser(id: "user_id")
    }
}
