//
//  GeoEntity.swift
//  STPhotoMap-iOS
//
//  Created by Crasneanu Cristian on 28/08/2018.
//  Copyright © 2018 mikelanza. All rights reserved.
//

import Foundation

public struct GeoEntity {
    var id: Int
    var name: String?
    var entityLevel: EntityLevel = .unknown
    var boundingBox: BoundingBox
    var center: Coordinate?
    var geoJSONPolygons = Array<GeoJSONPolygon>()
    var area: Double = 0
    
    var geoJSONObject: GeoJSONObject?
    var photoCount: Int = 0
    var photos: [STPhoto] = []
    var label: GeoLabel?
    
    init(id: Int, boundingBox: BoundingBox) {
        self.id = id
        self.boundingBox = boundingBox
    }
}
