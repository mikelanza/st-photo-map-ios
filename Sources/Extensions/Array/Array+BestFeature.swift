//
//  Array+BestFeature.swift
//  STPhotoMap-iOS
//
//  Created by Crasneanu Cristian on 27/05/2019.
//  Copyright © 2019 mikelanza. All rights reserved.
//

import Foundation
import MapKit

extension Array where Element: GeoJSONObject {
    func bestFeature(mapRect: MKMapRect) -> GeoJSONFeature? {
        var features: [GeoJSONFeature] = self.flatMap({ $0.features() })
        features.sort(by: { self.compare(lht: $0, rht: $1, for: mapRect)})
        return features.first
    }
    
    private func compare(lht: GeoJSONFeature, rht: GeoJSONFeature, for mapRect: MKMapRect) -> Bool {
        return mapRect.overlapPercentage(mapRect: lht.objectBoundingBox?.mapRect()) > mapRect.overlapPercentage(mapRect: rht.objectBoundingBox?.mapRect()) &&
            lht.objectBoundingBox?.mapRect().area() ?? 0 > rht.objectBoundingBox?.mapRect().area() ?? 0 &&
            lht.photoProperties?.photoCount ?? 0 > rht.photoProperties?.photoCount ?? 0
    }
}
