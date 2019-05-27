//
//  GeoJSONGeometry+ContainsLocation.swift
//  STPhotoMap-iOS
//
//  Created by Crasneanu Cristian on 27/05/2019.
//  Copyright © 2019 mikelanza. All rights reserved.
//

import Foundation

extension GeoJSONGeometry {
    func contains(location: STLocation) -> Bool {
        switch self {
        case let polygon as GeoJSONPolygon: return polygon.isLocationInsidePolygon(location: location)
        case let multiPolygon as GeoJSONMultiPolygon:
            for polygon in multiPolygon.polygons {
                if polygon.isLocationInsidePolygon(location: location) {
                    return true
                }
            }
        default: break
        }
        return false
    }
}
