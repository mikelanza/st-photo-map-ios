//
//  GeoJSONMultiPoint.swift
//  STPhotoMap-iOS
//
//  Created by Dimitri Strauneanu on 13/07/2018.
//  Copyright © 2018 mikelanza. All rights reserved.
//

import Foundation

internal typealias MultiPoint = GeoJSON.MultiPoint

public protocol GeoJSONMultiPoint: GeoJSONMultiCoordinatesGeometry { }

extension GeoJSON {
    public func multiPoint(points: [GeoJSONPoint]) -> GeoJSONMultiPoint? {
        return MultiPoint(points: points)
    }
    
    public struct MultiPoint: GeoJSONMultiPoint {
        public var type: GeoJSONType { return .multiPoint }
        public var geoJSONCoordinates: [Any] { return points.map { $0.geoJSONCoordinates } }
        
        public var description: String {
            return """
            MultiPoint: \(
            """
            (\n\(points.enumerated().map { "\($0 + 1) - \($1)" }.joined(separator: ",\n"))
            """
            .replacingOccurrences(of: "\n", with: "\n\t")
            )\n)
            """
        }
        
        public let points: [GeoJSONPoint]
        
        public var boundingBox: GeoJSONBoundingBox? {
            return BoundingBox.best(points.compactMap { $0.boundingBox })
        }
        
        internal init?(coordinatesJSON: [Any]) {
            guard let pointsJSON = coordinatesJSON as? [[Any]] else {
                print("A valid MultiPoint must have valid coordinates")
                return nil
            }
            
            var points = [GeoJSONPoint]()
            for pointJSON in pointsJSON {
                if let point = Point(coordinatesJSON: pointJSON) {
                    points.append(point)
                } else {
                    print("Invalid Point in MultiPoint")
                    return nil
                }
            }
            
            self.init(points: points)
        }
        
        fileprivate init?(points: [GeoJSONPoint]) {
            guard points.count >= 1 else {
                print("A valid MultiPoint must have at least one Point")
                return nil
            }
            
            self.points = points
        }
    }
}
