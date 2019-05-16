//
//  GeoJSONMultiPolygon.swift
//  STPhotoMap-iOS
//
//  Created by Dimitri Strauneanu on 13/07/2018.
//  Copyright © 2018 mikelanza. All rights reserved.
//

import Foundation

internal typealias MultiPolygon = GeoJSON.MultiPolygon

public protocol GeoJSONMultiPolygon: GeoJSONMultiCoordinatesGeometry {
    var polygons: [GeoJSONPolygon] { get }
}

extension GeoJSON {
    public func multiPolygon(polygons: [GeoJSONPolygon]) -> GeoJSONMultiPolygon? {
        return MultiPolygon(polygons: polygons)
    }
    
    public struct MultiPolygon: GeoJSONMultiPolygon {
        public let type: GeoJSONType = .multiPolygon
        public var geoJSONCoordinates: [Any] { return polygons.map { $0.geoJSONCoordinates } }
        
        public var description: String {
            return """
            MultiPolygon: \(
            """
            (\n\(polygons.enumerated().map { "Line \($0) - \($1)" }.joined(separator: ",\n"))
            """
            .replacingOccurrences(of: "\n", with: "\n\t")
            )\n)
            """
        }
        
        public let polygons: [GeoJSONPolygon]
        
        public var points: [GeoJSONPoint] {
            return polygons.flatMap { $0.points }
        }
        
        public var boundingBox: GeoJSONBoundingBox? {
            return BoundingBox.best(polygons.compactMap { $0.boundingBox })
        }
        
        internal init?(coordinatesJSON: [Any]) {
            guard let multiPolygonJSON = coordinatesJSON as? [[Any]] else {
                print("A valid MultiPolygon must have valid coordinates")
                return nil
            }
            
            var polygons = [GeoJSONPolygon]()
            for polygonJSON in multiPolygonJSON {
                if let polygon = Polygon(coordinatesJSON: polygonJSON) {
                    polygons.append(polygon)
                } else {
                    print("Invalid Polygon in MultiPolygon")
                    return nil
                }
            }
            
            self.init(polygons: polygons)
        }
        
        fileprivate init?(polygons: [GeoJSONPolygon]) {
            guard polygons.count >= 1 else {
                print("A valid MultiPolygon must have at least one Polygon")
                return nil
            }
            
            self.polygons = polygons
        }
    }
}
