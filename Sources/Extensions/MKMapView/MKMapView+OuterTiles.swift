//
//  MKMapView+OuterTiles.swift
//  STPhotoMap-iOS
//
//  Created by Crasneanu Cristian on 06/06/2019.
//  Copyright © 2019 mikelanza. All rights reserved.
//

import MapKit

extension MKMapView {
    public func outerTiles() -> [(MKMapRect, [TileCoordinate])] {
        let zoom = self.zoomLevel()
        
        let dx = self.visibleMapRect.maxX - self.visibleMapRect.minX
        let dy = self.visibleMapRect.maxY - self.visibleMapRect.minY
        
        let centerRight = self.visibleMapRect.offsetBy(dx: dx, dy: 0)
        let centerLeft = self.visibleMapRect.offsetBy(dx: -dx, dy: 0)
        
        let topRight = self.visibleMapRect.offsetBy(dx: dx, dy: -dy)
        let topCenter = self.visibleMapRect.offsetBy(dx: 0, dy: -dy)
        let topLeft = self.visibleMapRect.offsetBy(dx: -dx, dy: -dy)
        
        let bottomRight = self.visibleMapRect.offsetBy(dx: dx, dy: dy)
        let bottomCenter = self.visibleMapRect.offsetBy(dx: 0, dy: dy)
        let bottomLeft = self.visibleMapRect.offsetBy(dx: -dx, dy: dy)
        
        var outerTiles = [(MKMapRect, [TileCoordinate])]()
        outerTiles.append((topRight, topRight.tiles(from: topRight.westCenterEdgeCoordinate, to: topRight.southCenterEdgeCoordinate, zoom: zoom)))
        outerTiles.append((topCenter, topCenter.tiles(from: topCenter.westCenterEdgeCoordinate, to: topCenter.southEastCoordinate, zoom: zoom)))
        outerTiles.append((topLeft, topLeft.tiles(from: topLeft.westCenterEdgeCoordinate, to: topLeft.southEastCoordinate, zoom: zoom)))
        
        outerTiles.append((centerRight, centerRight.tiles(from: centerRight.northWestCoordinate, to: centerRight.southCenterEdgeCoordinate, zoom: zoom)))
        outerTiles.append((centerLeft, centerLeft.tiles(from: centerLeft.northCenterEdgeCoordinate, to: centerLeft.southEastCoordinate, zoom: zoom)))
        
        outerTiles.append((bottomRight, bottomRight.tiles(from: bottomRight.northWestCoordinate, to: bottomRight.eastCenterEdgeCoordinate, zoom: zoom)))
        outerTiles.append((bottomCenter, bottomCenter.tiles(from: bottomCenter.northWestCoordinate, to: bottomCenter.eastCenterEdgeCoordinate, zoom: zoom)))
        outerTiles.append((bottomLeft, bottomLeft.tiles(from: bottomLeft.northCenterEdgeCoordinate, to: bottomLeft.eastCenterEdgeCoordinate, zoom: zoom)))
        
        return outerTiles
    }
}
