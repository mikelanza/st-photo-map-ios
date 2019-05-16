//
//  GeoJSONLineString.swift
//  STPhotoMap-iOS
//
//  Created by Dimitri Strauneanu on 13/07/2018.
//  Copyright © 2018 mikelanza. All rights reserved.
//

import Foundation

public typealias GeoJSONLineSegment = (point1: GeodesicPoint, point2: GeodesicPoint)

internal typealias LineString = GeoJSON.LineString

public protocol GeoJSONLineString: GeoJSONMultiCoordinatesGeometry {
    var segments: [GeoJSONLineSegment] { get }
}

extension GeoJSON {
    public func lineString(points: [GeoJSONPoint]) -> GeoJSONLineString? {
        return LineString(points: points)
    }
    
    public struct LineString: GeoJSONLineString {
        public let type: GeoJSONType = .lineString
        public var geoJSONCoordinates: [Any] { return points.map { $0.geoJSONCoordinates } }
        
        public var description: String {
            return """
            LineString: \(
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
        
        public let segments: [GeoJSONLineSegment]
        
        internal init?(coordinatesJSON: [Any]) {
            guard let pointsJSON = coordinatesJSON as? [[Any]] else {
                print("A valid LineString must have valid coordinates")
                return nil
            }
            
            var points = [GeoJSONPoint]()
            for pointJSON in pointsJSON {
                if let point = Point(coordinatesJSON: pointJSON) {
                    points.append(point)
                } else {
                    print("Invalid Point in LineString")
                    return nil
                }
            }
            
            self.init(points: points)
        }
        
        fileprivate init?(points: [GeoJSONPoint]) {
            guard points.count >= 2 else {
                print("A valid LineString must have at least two Points");
                return nil
            }
            
            self.points = points
            
            segments = points.enumerated().compactMap { (offset, point) in
                if points.count == offset + 1 { return nil }
                
                return (point, points[offset + 1])
            }
        }
    }
}
