//
//  STLocation.swift
//  STPhotoMap-iOS
//
//  Created by Dimitri Strauneanu on 12/02/2018.
//  Copyright © 2018 mikelanza. All rights reserved.
//

import Foundation
import MapKit

public struct STLocation {
    public var latitude: Double
    public var longitude: Double
    
    public static func from(location: CLLocation) -> STLocation {
        return STLocation(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
    }
    
    public static func from(coordinate: CLLocationCoordinate2D) -> STLocation {
        return STLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
    }
    
    public func log() {
        print("********** STLocation **********")
        print("Latitude: \(self.latitude)")
        print("Longitude: \(self.longitude)")
        print("********** STLocation **********")
    }
}

extension STLocation: Equatable {
    public static func ==(lhs: STLocation, rhs: STLocation) -> Bool {
        return (lhs.latitude == rhs.latitude && lhs.longitude == rhs.longitude)
    }
}

extension STLocation {
    public var coordinate: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: self.latitude, longitude: self.longitude)
    }
}
