//
//  TileCoordinate.swift
//  STPhotoMap-iOS
//
//  Created by Dimitri Strauneanu on 11/07/2018.
//  Copyright © 2018 mikelanza. All rights reserved.
//

import Foundation

struct TileCoordinate: Equatable {
    let zoom: Int
    let x: Int
    let y: Int
    
    public func log() {
        print("********** Tile Coordinate **********")
        print("x: \(self.x)")
        print("y: \(self.y)")
        print("Zoom: \(self.zoom)")
        print("********** Tile Coordinate **********")
    }
    
    static func == (lhs: TileCoordinate, rhs: TileCoordinate) -> Bool {
        return
            lhs.x == rhs.x &&
                lhs.y == rhs.y &&
                lhs.zoom == rhs.zoom
    }
}
