//
//  Coordinate.swift
//  STPhotoMap-iOS
//
//  Created by Dimitri Strauneanu on 13/07/2018.
//  Copyright © 2018 mikelanza. All rights reserved.
//

import Foundation
import MapKit

public protocol GeodesicPoint: CustomStringConvertible {
    var longitude: Double { get }
    var latitude: Double { get }
}

public struct Coordinate: GeodesicPoint {
    public let longitude: Double
    public let latitude: Double
    
    public init(longitude: Double, latitude: Double) {
        self.longitude = longitude
        self.latitude = latitude
    }
    
    public var description: String {
        return "Coordinate: (longitude: \(self.longitude), latitude: \(self.latitude))"
    }
    
    public static func fromCLLocationCoordinate2D(coordinate: CLLocationCoordinate2D) -> Coordinate {
        return Coordinate(longitude: coordinate.longitude, latitude: coordinate.latitude)
    }
    
    public static func fromCLLocation(location: CLLocation) -> Coordinate {
        return Coordinate.fromCLLocationCoordinate2D(coordinate: location.coordinate)
    }
    
    public static func fromSTLocation(location: STLocation) -> Coordinate {
        return Coordinate(longitude: location.longitude, latitude: location.latitude)
    }
}

public func == (lhs: GeodesicPoint, rhs: GeodesicPoint) -> Bool {
    return lhs.latitude.description == rhs.latitude.description && lhs.longitude.description == rhs.longitude.description
}

public extension GeodesicPoint {
    var locationCoordinate: CLLocationCoordinate2D { return CLLocationCoordinate2D(latitude: latitude, longitude: longitude) }
}
