//
//  MKMapRect+SpiralTiles.swift
//  STPhotoMap-iOS
//
//  Created by Crasneanu Cristian on 07/06/2019.
//  Copyright © 2019 mikelanza. All rights reserved.
//

import MapKit

extension MKMapRect {
    public func spiralTiles(zoom: Int) -> [TileCoordinate] {
        let northWestTileCoordinate = TileCoordinate(coordinate: self.northWestCoordinate, zoom: zoom)
        let southEastTileCoordinate = TileCoordinate(coordinate: self.southEastCoordinate, zoom: zoom)
        
        var maxX = northWestTileCoordinate.maxX(relation: southEastTileCoordinate)
        var minX = northWestTileCoordinate.minX(relation: southEastTileCoordinate)
        
        var maxY = northWestTileCoordinate.maxY(relation: southEastTileCoordinate)
        var minY = northWestTileCoordinate.minY(relation: southEastTileCoordinate)
        
        var spiralVisibleTiles = [TileCoordinate]()
        
        while minX <= maxX && minY <= maxY {
            for i in minY ... maxY { spiralVisibleTiles.append(TileCoordinate(zoom: zoom, x: minX, y: i)) }
            minX += 1
            if self.validate(minX, maxX, minY, maxY) == true {
                for i in minX ... maxX { spiralVisibleTiles.append(TileCoordinate(zoom: zoom, x: i, y: maxY)) }
            }
            maxY -= 1
            if self.validate(minX, maxX, minY, maxY) == true {
                for i in (minY ... maxY).reversed() { spiralVisibleTiles.append(TileCoordinate(zoom: zoom, x: maxX, y: i)) }
            }
            maxX -= 1
            if self.validate(minX, maxX, minY, maxY) == true {
                for i in (minX ... maxX).reversed() { spiralVisibleTiles.append(TileCoordinate(zoom: zoom, x: i, y: minY)) }
            }
            minY += 1
        }
        
        return spiralVisibleTiles.reversed()
    }
    
    private func validate(_ minX: Int, _ maxX: Int, _ minY: Int, _ maxY: Int) -> Bool {
        if minX > maxX { return false }
        if minY > maxY { return false }
        return true
    }
}
