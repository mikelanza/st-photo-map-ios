//
//  GeoJSONObject+EntityLevel.swift
//  STPhotoMap-iOS
//
//  Created by Dimitri Strauneanu on 15/05/2019.
//  Copyright © 2019 mikelanza. All rights reserved.
//

import Foundation

extension GeoJSONObject {
    var entityLevel: EntityLevel {
        switch self {
            case let featureCollection as GeoJSONFeatureCollection: return featureCollection.features.first?.entityLevel ?? .unknown
            case let feature as GeoJSONFeature: return feature.entityLevel
            default: return EntityLevel.unknown
        }
    }
}
