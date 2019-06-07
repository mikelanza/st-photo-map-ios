//
//  MKMapRect+BoundingBox.swift
//  STPhotoMap-iOS
//
//  Created by Crasneanu Cristian on 06/06/2019.
//  Copyright © 2019 mikelanza. All rights reserved.
//

import MapKit

extension MKMapRect {
    public func boundingBox() -> BoundingBox {
        let minLongitude: Double = self.southWestCoordinate.longitude
        let minLatitude: Double = self.southWestCoordinate.latitude
        let maxLongitude: Double = self.northEastCoordinate.longitude
        let maxLatitude: Double = self.northEastCoordinate.latitude
        let boundingCoordinates: BoundingCoordinates = (minLongitude, minLatitude, maxLongitude, maxLatitude)
        return BoundingBox(boundingCoordinates: boundingCoordinates)
    }
}
