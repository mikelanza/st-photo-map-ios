//
//  STPhotoMapImageCache.swift
//  STPhotoMap-iOS
//
//  Created by Crasneanu Cristian on 06/06/2019.
//  Copyright © 2019 mikelanza. All rights reserved.
//

import Foundation
import MapKit

enum STPhotoMapImageCacheError: Error {
    case noTileAvailable
}

class STPhotoMapImageCache {
    class Tile: NSObject {
        var data: Data
        var keyUrl: String
        var downloadUrl: String
        
        init(data: Data, keyUrl: String, downloadUrl: String) {
            self.data = data
            self.keyUrl = keyUrl
            self.downloadUrl = downloadUrl
        }
    }
    
    private var tiles: SynchronizedArray<Tile> = SynchronizedArray()
    
    init() {
        self.tiles = SynchronizedArray<Tile>()
    }
    
    func removeAll() {
        self.tiles.removeAll()
    }
    
    func addTile(data: Data, forUrl downloadUrl: String, keyUrl: String) {
        if self.tiles.filter({ $0.keyUrl == keyUrl }).count == 0 {
            self.tiles.append(Tile(data: data, keyUrl: keyUrl, downloadUrl: downloadUrl))
        }
    }
    
    func optionalImageDataForUrl(url: String) -> Data? {
        return self.tiles.first(where: { $0.keyUrl == url })?.data
    }
}

