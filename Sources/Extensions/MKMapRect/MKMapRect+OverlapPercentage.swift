//
//  MKMapRect+OverlapPercentage.swift
//  STPhotoMap-iOS
//
//  Created by Crasneanu Cristian on 27/05/2019.
//  Copyright © 2019 mikelanza. All rights reserved.
//

import MapKit

extension MKMapRect {
    func overlapPercentage(mapRect: MKMapRect?) -> Double {
        guard let mapRect = mapRect else { return 0.0 }
        
        let intersection = self.intersection(mapRect)
        
        if intersection.isNull || intersection.isEmpty {
            return 0.0
        }
        
        return (intersection.area() / mapRect.area()) * 100.0
    }
}

