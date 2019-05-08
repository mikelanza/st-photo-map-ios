//
//  MKMapView+VisibleTiles.swift
//  STPhotoMap-iOS
//
//  Created by Crasneanu Cristian on 22/04/2019.
//  Copyright © 2019 mikelanza. All rights reserved.
//

import MapKit

extension MKMapRect {
    public var northEastCoordinate: CLLocationCoordinate2D {
        return MKMapPoint(x: self.maxX, y: self.origin.y).coordinate
    }
    
    public var northWestCoordinate: CLLocationCoordinate2D {
        return MKMapPoint(x: self.minX, y: self.origin.y).coordinate
    }
    
    public var southEastCoordinate: CLLocationCoordinate2D {
        return MKMapPoint(x: self.maxX, y: self.maxY).coordinate
    }
    
    public var southWestCoordinate: CLLocationCoordinate2D {
        return MKMapPoint(x: self.origin.x, y: self.maxY).coordinate
    }
}

extension MKMapView {
    public func zoomLevel(minZoom: Int = 0, maxZoom: Int = 20) -> Int {
        let zoom = Int(round(log2(360 * Double(self.frame.size.width) / (self.region.span.longitudeDelta * 128))))
        if zoom < minZoom {
            return minZoom
        }
        if zoom > maxZoom {
            return maxZoom
        }
        return zoom
    }
    
    public func visibleTiles() -> [TileCoordinate] {
        let zoom = self.zoomLevel()
        
        let northWestTileCoordinate = TileCoordinate(coordinate: self.visibleMapRect.northWestCoordinate, zoom: zoom)
        let southEastTileCoordinate = TileCoordinate(coordinate: self.visibleMapRect.southEastCoordinate, zoom: zoom)
        
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
