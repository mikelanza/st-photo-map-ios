//
//  MKMapView+BoundingBox.swift
//  STPhotoMap-iOS
//
//  Created by Crasneanu Cristian on 16/05/2019.
//  Copyright © 2019 mikelanza. All rights reserved.
//

import Foundation
import MapKit

extension MKMapView {
    public func boundingBox() -> BoundingBox {
        let minLongitude: Double = self.visibleMapRect.southWestCoordinate.longitude
        let minLatitude: Double = self.visibleMapRect.southWestCoordinate.latitude
        let maxLongitude: Double = self.visibleMapRect.northEastCoordinate.longitude
        let maxLatitude: Double = self.visibleMapRect.northEastCoordinate.latitude
        let boundingCoordinates: BoundingCoordinates = (minLongitude, minLatitude, maxLongitude, maxLatitude)
        return BoundingBox(boundingCoordinates: boundingCoordinates)
    }
}
