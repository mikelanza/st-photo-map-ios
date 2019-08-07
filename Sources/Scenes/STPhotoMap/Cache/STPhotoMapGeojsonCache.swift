//
//  STPhotoMapCache.swift
//  STPhotoMap-iOS
//
//  Created by Crasneanu Cristian on 10/05/2019.
//  Copyright © 2019 mikelanza. All rights reserved.
//

import Foundation
import STPhotoCore

enum STPhotoMapGeojsonCacheError: Error {
    case noTileAvailable
}

class STPhotoMapGeojsonCache {
    struct Tile {
        var keyUrl: String
        var geojsonObject: GeoJSONObject
    }
    
    var tiles: SynchronizedArray<Tile>
    
    init() {
        self.tiles = SynchronizedArray<Tile>()
    }
    
    func addTile(tile: Tile) {
        self.tiles.append(tile)
    }
    
    func removeAllTiles() {
        self.tiles.removeAll()
    }
    
    func getTiles(for urls: [String]) -> [Tile] {
        return self.tiles.filter({ urls.contains($0.keyUrl) })
    }
    
    func getTile(for keyUrl: String) throws -> Tile {
        guard let tile = self.tiles.first(where: { $0.keyUrl == keyUrl }) else {
            throw STPhotoMapGeojsonCacheError.noTileAvailable
        }
        return tile
    }
    
    func tileCount() -> Int {
        return self.tiles.count
    }
}
