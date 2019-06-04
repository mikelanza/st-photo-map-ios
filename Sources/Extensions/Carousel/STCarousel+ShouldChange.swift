//
//  STCarousel+ShouldChange.swift
//  STPhotoMap-iOS
//
//  Created by Crasneanu Cristian on 27/05/2019.
//  Copyright © 2019 mikelanza. All rights reserved.
//

import Foundation
import MapKit

extension STCarousel {
    func shouldChange(mapRect: MKMapRect) -> Bool {
        let biggestOverlay = self.overlays.max { (lhs, rhs) -> Bool in
            return lhs.boundingMapRect.area() < rhs.boundingMapRect.area()
        }
        
        guard let biggestMapRect = biggestOverlay?.boundingMapRect else { return true }
        let percentage = mapRect.overlapPercentage(mapRect: biggestMapRect)
        return percentage > 50 ? false : true
    }
}
