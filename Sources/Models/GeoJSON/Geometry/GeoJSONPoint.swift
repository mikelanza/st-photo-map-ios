//
//  GeoJSONPoint.swift
//  STPhotoMap-iOS
//
//  Created by Dimitri Strauneanu on 13/07/2018.
//  Copyright © 2018 mikelanza. All rights reserved.
//

import Foundation

internal typealias Point = GeoJSON.Point

public protocol GeoJSONPoint: GeodesicPoint, GeoJSONCoordinatesGeometry {
    
}

extension GeoJSON {
    public func point(longitude: Double, latitude: Double) -> GeoJSONPoint {
        return Point(longitude: longitude, latitude: latitude)
    }
    
    public struct Point: GeoJSONPoint {
        public var type: GeoJSONType { return .point }
        
        public var geoJSONCoordinates: [Any] { return [longitude, latitude] }
        
        public var description: String { return "Point: (longitude: \(longitude), latitude: \(latitude)" }
        
        public let longitude: Double
        public let latitude: Double
        
        public var boundingBox: GeoJSONBoundingBox? {
            return BoundingBox(boundingCoordinates: (minLongitude: longitude, minLatitude: latitude, maxLongitude: longitude, maxLatitude: latitude))
        }
        
        internal init?(coordinatesJSON: [Any]) {
            guard let pointJSON = (coordinatesJSON as? [NSNumber])?.map({ $0.doubleValue }), pointJSON.count >= 2 else {
                print("A valid Point must have at least 2 coordinates")
                return nil
            }
            
            self.init(longitude: pointJSON[0], latitude: pointJSON[1])
        }
        
        internal init(longitude: Double, latitude: Double) {
            self.longitude = longitude
            self.latitude = latitude
        }
    }
}
