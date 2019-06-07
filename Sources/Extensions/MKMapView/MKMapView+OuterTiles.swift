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
        outerTiles.append((topRight, topRight.tiles(zoom: zoom)))
        outerTiles.append((topCenter, topCenter.tiles(zoom: zoom)))
        outerTiles.append((topLeft, topLeft.tiles(zoom: zoom)))
        
        outerTiles.append((centerRight, centerRight.tiles(zoom: zoom)))
        outerTiles.append((centerLeft, centerLeft.tiles(zoom: zoom)))
        
        outerTiles.append((bottomRight, bottomRight.tiles(zoom: zoom)))
        outerTiles.append((bottomCenter, bottomCenter.tiles(zoom: zoom)))
        outerTiles.append((bottomLeft, bottomLeft.tiles(zoom: zoom)))
        
        return outerTiles
    }
}
