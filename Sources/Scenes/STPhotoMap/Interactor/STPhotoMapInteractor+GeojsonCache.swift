//
//  STPhotoMapInteractor+GeojsonCache.swift
//  STPhotoMap-iOS
//
//  Created by Dimitri Strauneanu on 15/05/2019.
//  Copyright © 2019 mikelanza. All rights reserved.
//

import Foundation

// MARK: - Caching geojson objects logic

extension STPhotoMapInteractor {
    func shouldCacheGeojsonObjects() {
        let tiles = self.prepareTilesForCaching()
        self.cacheGeojsonObjectsFor(tiles: tiles)
    }
    
    private func prepareTilesForCaching() -> [TileCoordinate] {
        return self.visibleTiles.filter({ tile -> Bool in
            let url = STPhotoMapUrlBuilder().geojsonTileUrl(tileCoordinate: tile)
            return self.cacheHandler.shouldPrepareTileForCaching(url: url.keyUrl)
        })
    }
    
    private func cacheGeojsonObjectsFor(tiles: [TileCoordinate]) {
        tiles.forEach({ self.cacheGeojsonObjectsFor(tile: $0) })
    }
    
    private func cacheGeojsonObjectsFor(tile: TileCoordinate) {
        let url = STPhotoMapUrlBuilder().geojsonTileUrl(tileCoordinate: tile)
        self.cacheHandler.addActiveDownload(url.keyUrl)
        self.worker?.getGeojsonTileForCaching(tileCoordinate: tile, keyUrl: url.keyUrl, downloadUrl: url.downloadUrl)
    }
}

extension STPhotoMapInteractor {
    func successDidGetGeojsonTileForCaching(tileCoordinate: TileCoordinate, keyUrl: String, downloadUrl: String, geojsonObject: GeoJSONObject) {
        self.cacheHandler.cache.addTile(tile: STPhotoMapGeojsonCache.Tile(keyUrl: keyUrl, geojsonObject: geojsonObject))
        self.cacheHandler.removeActiveDownload(keyUrl)
    }
    
    func failureDidGetGeojsonTileForCaching(tileCoordinate: TileCoordinate, keyUrl: String, downloadUrl: String, error: OperationError) {
        self.cacheHandler.removeActiveDownload(keyUrl)
    }
}
