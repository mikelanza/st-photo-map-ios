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
        var features = self.flatMap { (geojsonObject) -> [GeoJSONFeature] in
            geojsonObject.features()
        }
        
        features.sort { (lht, rht) -> Bool in
            return mapRect.overlapPercentage(mapRect: lht.objectBoundingBox?.mapRect()) > mapRect.overlapPercentage(mapRect: rht.objectBoundingBox?.mapRect())
                && lht.objectBoundingBox?.mapRect().area() ?? 0 > rht.objectBoundingBox?.mapRect().area() ?? 0
                && lht.photoProperties?.photoCount ?? 0 > rht.photoProperties?.photoCount ?? 0
        }
        
        return features.first
    }
}
