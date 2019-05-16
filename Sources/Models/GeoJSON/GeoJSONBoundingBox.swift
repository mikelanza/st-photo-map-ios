//
//  GeoJSONBoundingBox.swift
//  STPhotoMap-iOS
//
//  Created by Dimitri Strauneanu on 13/07/2018.
//  Copyright © 2018 mikelanza. All rights reserved.
//

import Foundation
import MapKit

public typealias BoundingCoordinates = (minLongitude: Double, minLatitude: Double, maxLongitude: Double, maxLatitude: Double)

public protocol GeoJSONBoundingBox: CustomStringConvertible {
    var minLongitude: Double { get }
    var minLatitude: Double { get }
    var maxLongitude: Double { get }
    var maxLatitude: Double { get }
    
    var longitudeDelta: Double { get }
    var latitudeDelta: Double { get }
    
    var points: [GeodesicPoint] { get }
    var centroid: GeodesicPoint { get }
    var boundingCoordinates: BoundingCoordinates { get }
    
    func best(_ boundingBoxes: [GeoJSONBoundingBox]) -> GeoJSONBoundingBox
    func contains(point: GeodesicPoint) -> Bool
    
    func mapRect() -> MKMapRect
}

public class BoundingBox: GeoJSONBoundingBox {
    public var description: String {
        return "\(minLongitude),\(minLatitude),\(maxLongitude),\(maxLatitude)"
    }
    
    public var points: [GeodesicPoint]
    public let centroid: GeodesicPoint
    
    public var boundingCoordinates: BoundingCoordinates {
        return (minLongitude: minLongitude, minLatitude: minLatitude, maxLongitude: maxLongitude, maxLatitude: maxLatitude)
    }
    
    public let minLongitude: Double
    public let minLatitude: Double
    public let maxLongitude: Double
    public let maxLatitude: Double
    
    public let longitudeDelta: Double
    public let latitudeDelta: Double
    
    public init(boundingCoordinates: BoundingCoordinates) {
        minLongitude = boundingCoordinates.minLongitude
        minLatitude = boundingCoordinates.minLatitude
        maxLongitude = boundingCoordinates.maxLongitude
        maxLatitude = boundingCoordinates.maxLatitude
        
        points = [Coordinate(longitude: minLongitude, latitude: minLatitude), Coordinate(longitude: minLongitude, latitude: maxLatitude), Coordinate(longitude: maxLongitude, latitude: maxLatitude), Coordinate(longitude: maxLongitude, latitude: minLatitude)]
        
        longitudeDelta = maxLongitude - minLongitude
        latitudeDelta = maxLatitude - minLatitude
        
        centroid = Coordinate(longitude: maxLongitude - (longitudeDelta / 2), latitude: maxLatitude - (latitudeDelta / 2))
    }
    
    public func best(_ boundingBoxes: [GeoJSONBoundingBox]) -> GeoJSONBoundingBox {
        return boundingBoxes.reduce(self) {
            let boundingCoordinates = (minLongitude: min($0.minLongitude, $1.minLongitude), minLatitude: min($0.minLatitude, $1.minLatitude), maxLongitude: max($0.maxLongitude, $1.maxLongitude), maxLatitude: max($0.maxLatitude, $1.maxLatitude))
            
            return BoundingBox(boundingCoordinates: boundingCoordinates)
        }
    }
    
    public func contains(point: GeodesicPoint) -> Bool {
        return point.longitude >= minLongitude && point.longitude <= maxLongitude &&
            point.latitude >= minLatitude && point.latitude <= maxLatitude
    }
    
    public func center() -> CLLocationCoordinate2D {
        return self.centroid.locationCoordinate
    }
    
    public func coordinateRegion() -> MKCoordinateRegion {
        return MKCoordinateRegion(center: self.center(), span: MKCoordinateSpan(latitudeDelta: self.latitudeDelta, longitudeDelta: self.longitudeDelta))
    }
    
    public func mapRect() -> MKMapRect {
        let southEast = Coordinate(longitude: minLongitude, latitude: maxLatitude)
        let northWest = Coordinate(longitude: maxLongitude, latitude: minLatitude)
       
        let topLeft = MKMapPoint(northWest.locationCoordinate)
        let bottomRight = MKMapPoint(southEast.locationCoordinate)
        
        let mapRect = MKMapRect(x: fmin(topLeft.x,bottomRight.x), y: fmin(topLeft.y,bottomRight.y), width: fabs(topLeft.x-bottomRight.x), height: fabs(topLeft.y-bottomRight.y));
        return mapRect
    }
}

extension BoundingBox {
    public static func best(_ boundingBoxes: [GeoJSONBoundingBox]) -> GeoJSONBoundingBox? {
        guard let firstBoundingBox = boundingBoxes.first else { return nil }
        
        guard let boundingBoxesTail = boundingBoxes.tail, !boundingBoxesTail.isEmpty else { return firstBoundingBox }
        
        return firstBoundingBox.best(boundingBoxesTail)
    }
}

public func == (lhs: GeoJSONBoundingBox, rhs: GeoJSONBoundingBox) -> Bool {
    return lhs.minLongitude == rhs.minLongitude && lhs.minLatitude == rhs.minLatitude && lhs.maxLongitude == rhs.maxLongitude && lhs.maxLatitude == rhs.maxLatitude
}
