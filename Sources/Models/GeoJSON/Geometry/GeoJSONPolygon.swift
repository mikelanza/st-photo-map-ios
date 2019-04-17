//
//  GeoJSONPolygon.swift
//  STPhotoMap-iOS
//
//  Created by Dimitri Strauneanu on 13/07/2018.
//  Copyright © 2018 mikelanza. All rights reserved.
//

import Foundation
import MapKit

internal typealias Polygon = GeoJSON.Polygon

public protocol GeoJSONPolygon: GeoJSONMultiCoordinatesGeometry {
    var linearRings: [GeoJSONLineString] { get }
    
    func isLocationInsidePolygon(location: STLocation) -> Bool
}

extension GeoJSON {
    public func polygon(linearRings: [GeoJSONLineString]) -> GeoJSONPolygon? {
        return Polygon(linearRings: linearRings)
    }
    
    public struct Polygon: GeoJSONPolygon {
        public let type: GeoJSONType = .polygon
        public var geoJSONCoordinates: [Any] { return linearRings.map { $0.geoJSONCoordinates } }
        
        public var description: String {
            return """
            Polygon: \(
            """
            (\n\(linearRings.enumerated().map { "\($0 == 0 ? "Main Ring" : "Negative Ring \($0)") - \($1)" }.joined(separator: ",\n"))
            """
            .replacingOccurrences(of: "\n", with: "\n\t")
            )\n)
            """
        }
        
        public let linearRings: [GeoJSONLineString]
        
        public var points: [GeoJSONPoint] {
            return linearRings.flatMap { $0.points }
        }
        
        public var boundingBox: GeoJSONBoundingBox? {
            return BoundingBox.best(linearRings.compactMap { $0.boundingBox })
        }
        
        internal init?(coordinatesJSON: [Any]) {
            guard let linearRingsJSON = coordinatesJSON as? [[Any]] else {
                print("A valid Polygon must have valid coordinates")
                return nil
            }
            
            var linearRings = [GeoJSONLineString]()
            for linearRingJSON in linearRingsJSON {
                if let linearRing = LineString(coordinatesJSON: linearRingJSON) {
                    linearRings.append(linearRing)
                } else {
                    print("Invalid linear ring (LineString) in Polygon"); return nil
                }
            }
            
            self.init(linearRings: linearRings)
        }
        
        fileprivate init?(linearRings: [GeoJSONLineString]) {
            guard linearRings.count >= 1 else {
                print("A valid Polygon must have at least one LinearRing")
                return nil
            }
            
            for linearRing in linearRings {
                guard linearRing.points.first! == linearRing.points.last! else {
                    print("A valid Polygon LinearRing must have the first and last points equal")
                    return nil
                }
                
                guard linearRing.points.count >= 4 else {
                    print("A valid Polygon LinearRing must have at least 4 points")
                    return nil
                }
            }
            
            self.linearRings = linearRings
        }
        
        public func isLocationInsidePolygon(location: STLocation) -> Bool {
            guard self.points.count > 0 else { return false }
            
            let locationMapPoint = MKMapPoint(location.coordinate)
            let locationPoint = CGPoint.init(x: locationMapPoint.x, y: locationMapPoint.y)
            
            let lastMapPoint = MKMapPoint(self.points.last!.locationCoordinate)
            var pointJ = CGPoint.init(x: lastMapPoint.x, y: lastMapPoint.y)
            
            var contains = false
            for point in self.points {
                let mapPoint = MKMapPoint(point.locationCoordinate)
                let pointI = CGPoint.init(x: mapPoint.x, y: mapPoint.y)
                if ( ((pointI.y >= locationPoint.y) != (pointJ.y >= locationPoint.y)) &&
                    (locationPoint.x <= (pointJ.x - pointI.x) * (locationPoint.y - pointI.y) / (pointJ.y - pointI.y) + pointI.x) ) {
                    contains = !contains
                }
                pointJ = pointI
            }
            return contains
        }
    }
}
