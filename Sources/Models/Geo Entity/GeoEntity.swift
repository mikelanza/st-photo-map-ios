//
//  GeoEntity.swift
//  STPhotoMap-iOS
//
//  Created by Crasneanu Cristian on 28/08/2018.
//  Copyright © 2018 mikelanza. All rights reserved.
//

import Foundation

public struct GeoEntity {
    public var id: Int
    public var name: String?
    public var entityLevel: EntityLevel = .unknown
    public var boundingBox: BoundingBox
    public var center: Coordinate?
    public var geoJSONPolygons = Array<GeoJSONPolygon>()
    public var area: Double = 0
    
    public var geoJSONObject: GeoJSONObject?
    public var photoCount: Int = 0
    public var photos: [STPhoto] = []
    public var label: GeoLabel?
    
    public init(id: Int, boundingBox: BoundingBox) {
        self.id = id
        self.boundingBox = boundingBox
    }
}
