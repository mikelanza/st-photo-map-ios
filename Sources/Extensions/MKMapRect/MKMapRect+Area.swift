//
//  MKMapRect+Area.swift
//  STPhotoMap-iOS
//
//  Created by Dimitri Strauneanu on 23/05/2019.
//  Copyright © 2019 mikelanza. All rights reserved.
//

import MapKit

extension MKMapRect {
    func area() -> Double {
        let northEastLocation = CLLocation(latitude: self.northEastCoordinate.latitude, longitude: self.northEastCoordinate.longitude)
        let southWestLocation = CLLocation(latitude: self.southWestCoordinate.latitude, longitude: self.southWestCoordinate.longitude)
        let southEastLocation = CLLocation(latitude: self.southEastCoordinate.latitude, longitude: self.southEastCoordinate.longitude)
        let width: Double = southWestLocation.distance(from: southEastLocation) / 1000
        let height: Double = southEastLocation.distance(from: northEastLocation) / 1000
        return width * height
    }
}
