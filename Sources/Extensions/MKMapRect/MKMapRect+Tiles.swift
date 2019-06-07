//
//  MKMapRect+Tiles.swift
//  STPhotoMap-iOS
//
//  Created by Crasneanu Cristian on 06/06/2019.
//  Copyright © 2019 mikelanza. All rights reserved.
//

import MapKit

extension MKMapRect {
    public func tiles(zoom: Int) -> [TileCoordinate] {
        let northWestTileCoordinate = TileCoordinate(coordinate: self.northWestCoordinate, zoom: zoom)
        let southEastTileCoordinate = TileCoordinate(coordinate: self.southEastCoordinate, zoom: zoom)
        
        let xMax = northWestTileCoordinate.maxX(relation: southEastTileCoordinate)
        let xMin = northWestTileCoordinate.minX(relation: southEastTileCoordinate)
        
        let yMax = northWestTileCoordinate.maxY(relation: southEastTileCoordinate)
        let yMin = northWestTileCoordinate.minY(relation: southEastTileCoordinate)
        
        var visibleTiles = [TileCoordinate]()
        
        for y in yMin...yMax {
            for x in xMin...xMax {
                visibleTiles.append(TileCoordinate(zoom: zoom, x: x, y: y))
            }
        }
        
        return visibleTiles
    }
}
