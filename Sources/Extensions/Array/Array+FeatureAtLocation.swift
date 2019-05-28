//
//  Array+FeatureAtLocation.swift
//  STPhotoMap-iOS
//
//  Created by Crasneanu Cristian on 27/05/2019.
//  Copyright © 2019 mikelanza. All rights reserved.
//

import Foundation
import MapKit

extension Array where Element: GeoJSONObject {
    func feature(atLocation location: STLocation) -> GeoJSONFeature? {
        let features: [GeoJSONFeature] = self.flatMap({ $0.features() })
        
        return features.filter({ $0.contains(location: location) }).first
    }
}
