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
    
    // MARK: - Getter
    
    func getTiles(for urls: [String]) -> [Tile] {
        return self.tiles.filter({ urls.contains($0.keyUrl) })
    }
    
    func getTile(for keyUrl: String) -> Tile? {
        return self.tiles.first(where: { $0.keyUrl == keyUrl })
    }
}
