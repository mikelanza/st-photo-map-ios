//
//  STPhotoMapInteractor+Location.swift
//  STPhotoMap-iOS
//
//  Created by Crasneanu Cristian on 17/05/2019.
//  Copyright © 2019 mikelanza. All rights reserved.
//

import Foundation

// MARK: - Location level logic

extension STPhotoMapInteractor {
    func shouldDetermineLocationLevel() {
        guard isLocationLevel() else { return }
        
        let cachedTiles = self.getVisibleCachedTiles()
        self.presentPhotoAnnotationsForCached(tiles: cachedTiles)
        self.locationLevelGeojsonObjectsFor(tiles: self.prepareTilesForLocationLevel())
    }
    
    private func presentLocationAnnotations(annotations: [STPhotoMapModels.Annotation]) {
        guard !annotations.isEmpty else { return }
        
        self.presenter?.presentLocationAnnotations(response: STPhotoMapModels.LocationAnnotations.Response(annotations: annotations))
    }
    
    func isLocationLevel() -> Bool {
        return self.entityLevelHandler.entityLevel == EntityLevel.location
    }
    
    private func presentPhotoAnnotationsForCached(tiles:  [STPhotoMapGeojsonCache.Tile]) {
        var annotations = [STPhotoMapModels.Annotation]()
        for tile in tiles {
            let tileAnnotations = self.getAnnotations(from: tile.geojsonObject)
            if tileAnnotations.isEmpty == false {
                annotations.append(contentsOf: tileAnnotations)
            }
        }
        self.presentLocationAnnotations(annotations: annotations)
    }
    
    private func getAnnotations(from geojsonObject: GeoJSONObject) -> [STPhotoMapModels.Annotation] {
        return self.getAnnotations(from: geojsonObject.features())
    }
    
    internal func getAnnotations(from features: [GeoJSONFeature]) -> [STPhotoMapModels.Annotation] {
        var annotations: [STPhotoMapModels.Annotation] = []
        for feature in features {
            if let annotation = self.annotation(from: feature) {
                annotations.append(annotation)
            }
        }
        return annotations
    }
    
    internal func annotation(from feature: GeoJSONFeature) -> STPhotoMapModels.Annotation? {
        if let id = feature.idAsString, let point = feature.geometry as? GeoJSONPoint {
            return STPhotoMapModels.Annotation(id: id, imageUrl: feature.photoProperties?.image250Url,  latitude: point.latitude, longitude: point.longitude)
        }
        return nil
    }
    
    private func prepareTilesForLocationLevel() -> [TileCoordinate] {
        return self.visibleTiles.filter({ tile -> Bool in
            let url = STPhotoMapUrlBuilder().geojsonTileUrl(tileCoordinate: tile)
            return !self.locationLevelHandler.hasActiveDownload(url.keyUrl)
        })
    }
    
    private func locationLevelGeojsonObjectsFor(tiles: [TileCoordinate]) {
        tiles.forEach({ self.locationLevelGeojsonObjectsFor(tile: $0) })
    }
    
    private func locationLevelGeojsonObjectsFor(tile: TileCoordinate) {
        let url = STPhotoMapUrlBuilder().geojsonTileUrl(tileCoordinate: tile)
        self.locationLevelHandler.addActiveDownload(url.keyUrl)
        self.worker?.getGeojsonLocationLevel(tileCoordinate: tile, keyUrl: url.keyUrl, downloadUrl: url.downloadUrl)
    }
    
    private func didGetGeojsonTileForLocationLevel(geojsonObject: GeoJSONObject) {
        guard isLocationLevel() else { return }
        let annotations = self.getAnnotations(from: geojsonObject)
        self.presentLocationAnnotations(annotations: annotations)
    }
    
    func shouldReloadLocationLevel() {
        self.presenter?.presentRemoveLocationOverlay()
        self.presenter?.presentRemoveLocationAnnotations()
        self.shouldDetermineLocationLevel()
    }
}

extension STPhotoMapInteractor {
    func successDidGetGeojsonTileForLocationLevel(tileCoordinate: TileCoordinate, keyUrl: String, downloadUrl: String, geojsonObject: GeoJSONObject) {
        self.locationLevelHandler.removeActiveDownload(keyUrl)
        self.didGetGeojsonTileForLocationLevel(geojsonObject: geojsonObject)
        
        self.determineSelectedPhotoAnnotationForDownloadedLocationTile(features: geojsonObject.features())
    }
    
    func failureDidGetGeojsonTileForLocationLevel(tileCoordinate: TileCoordinate, keyUrl: String, downloadUrl: String, error: OperationError) {
        self.locationLevelHandler.removeActiveDownload(keyUrl)
    }
}
