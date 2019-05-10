//
//  STPhotoMapCache.swift
//  STPhotoMap-iOS
//
//  Created by Crasneanu Cristian on 10/05/2019.
//  Copyright © 2019 mikelanza. All rights reserved.
//

import Foundation

class STPhotoMapCache {
    struct Tile {
        var keyUrl: String
        // TODO: Add geo object
    }
    
    var tiles = SynchronizedArray<Tile>()
    
    // MARK: Getter
    
    func getTiles(for urls: [String]) -> [Tile] {
        var cachedTiles = [Tile]()
        urls.forEach { (keyUrl) in
            if let cachedTile = self.getTile(for: keyUrl) {
                cachedTiles.append(cachedTile)
            }
        }
        return cachedTiles
    }
    
    func getTile(for keyUrl: String) -> Tile? {
        return self.tiles.first { (tile) -> Bool in
            return tile.keyUrl == keyUrl
        }
    }
}
