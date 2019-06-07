//
//  STPhotoMapInteractor+EntityLevel.swift
//  STPhotoMap-iOS
//
//  Created by Dimitri Strauneanu on 15/05/2019.
//  Copyright © 2019 mikelanza. All rights reserved.
//

import Foundation

// MARK: - Entity Level logic

extension STPhotoMapInteractor {
    func shouldDetermineEntityLevel() {
        self.cancelAllGeojsonEntityLevelOperations()
        
        let cachedTiles = self.getVisibleCachedTiles()
        
        if cachedTiles.count > 0 {
            self.calculateEntityLevelFor(cachedTiles: cachedTiles)
        } else {
            self.entityLevelGeojsonObjectsFor(tiles: self.prepareTilesForEntityLevel())
        }
        
        self.handleLoadingStateForEntityLevel()
    }
    
    private func calculateEntityLevelFor(cachedTiles: [STPhotoMapGeojsonCache.Tile]) {
        let entityLevel = cachedTiles.first?.geojsonObject.entityLevel ?? .unknown
        self.entityLevelHandler.change(entityLevel: entityLevel)
    }
    
    private func prepareTilesForEntityLevel() -> [TileCoordinate] {
        return self.visibleTiles.filter({ tile -> Bool in
            let url = STPhotoMapUrlBuilder().geojsonTileUrl(tileCoordinate: tile)
            return !self.entityLevelHandler.hasActiveDownload(url.keyUrl)
        })
    }
    
    private func entityLevelGeojsonObjectsFor(tiles: [TileCoordinate]) {
        tiles.forEach({ self.entityLevelGeojsonObjectsFor(tile: $0) })
    }
    
    private func entityLevelGeojsonObjectsFor(tile: TileCoordinate) {
        let url = STPhotoMapUrlBuilder().geojsonTileUrl(tileCoordinate: tile)
        self.entityLevelHandler.addActiveDownload(url.keyUrl)
        self.worker?.getGeojsonEntityLevel(tileCoordinate: tile, keyUrl: url.keyUrl, downloadUrl: url.downloadUrl)
    }
    
    private func didGetGeojsonTileForEntityLevel(tileCoordinate: TileCoordinate, geojsonObject: GeoJSONObject) {
        if self.isStillTileVisible(tileCoordinate: tileCoordinate) && geojsonObject.entityLevel != EntityLevel.unknown {
            self.entityLevelHandler.change(entityLevel: geojsonObject.entityLevel)
            self.worker?.cancelAllGeojsonEntityLevelOperations()
        }
        self.handleLoadingStateForEntityLevel()
    }
    
    private func isStillTileVisible(tileCoordinate: TileCoordinate) -> Bool {
        return self.visibleTiles.contains(tileCoordinate)
    }
    
    private func handleLoadingStateForEntityLevel() {
        if self.entityLevelHandler.activeDownloads.count > 0 {
            self.presenter?.presentLoadingState()
        } else {
            self.presenter?.presentNotLoadingState()
        }
    }
    
    private func cancelAllGeojsonEntityLevelOperations() {
        self.worker?.cancelAllGeojsonEntityLevelOperations()
    }
}

extension STPhotoMapInteractor {
    func successDidGetGeojsonTileForEntityLevel(tileCoordinate: TileCoordinate, keyUrl: String, downloadUrl: String, geojsonObject: GeoJSONObject) {
        self.entityLevelHandler.removeActiveDownload(keyUrl)
        self.didGetGeojsonTileForEntityLevel(tileCoordinate: tileCoordinate, geojsonObject: geojsonObject)
    }
    
    func failureDidGetGeojsonTileForEntityLevel(tileCoordinate: TileCoordinate, keyUrl: String, downloadUrl: String, error: OperationError) {
        self.entityLevelHandler.removeActiveDownload(keyUrl)
        self.handleLoadingStateForEntityLevel()
    }
}
