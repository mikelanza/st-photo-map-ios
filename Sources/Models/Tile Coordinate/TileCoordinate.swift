//
//  TileCoordinate.swift
//  STPhotoMap-iOS
//
//  Created by Dimitri Strauneanu on 11/07/2018.
//  Copyright © 2018 mikelanza. All rights reserved.
//

import Foundation
import MapKit

public struct TileCoordinate: Equatable {
    let zoom: Int
    let x: Int
    let y: Int
    
    public static func == (lhs: TileCoordinate, rhs: TileCoordinate) -> Bool {
        return
            lhs.x == rhs.x &&
                lhs.y == rhs.y &&
                lhs.zoom == rhs.zoom
    }
    
    public init(zoom: Int, x: Int, y: Int) {
        self.zoom = zoom
        self.x = x
        self.y = y
    }
    
    public init(coordinate: CLLocationCoordinate2D, zoom: Int) {
        self.zoom = zoom
        self.x = Int(floor((coordinate.longitude + 180) / 360.0 * pow(2.0, Double(zoom))))
        self.y = Int(floor((1 - log(tan(coordinate.latitude * Double.pi / 180.0) + 1 / cos(coordinate.latitude * Double.pi / 180.0)) / Double.pi) / 2 * pow(2.0, Double(zoom))))
    }
    
    public func maxX(relation: TileCoordinate) -> Int {
        return max(self.x, relation.x)
    }
    
    public func minX(relation: TileCoordinate) -> Int {
        let minX = min(self.x, relation.x)
        return minX > 0 ? minX : 0
    }

    public func maxY(relation: TileCoordinate) -> Int {
        return max(self.y, relation.y)
    }
    
    public func minY(relation: TileCoordinate) -> Int {
        let minY = min(self.y, relation.y)
        return minY > 0 ? minY : 0
    }
}
