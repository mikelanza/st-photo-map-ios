//
//  STPhotoMapInteractor+CarouselDetermination.swift
//  STPhotoMap-iOS
//
//  Created by Crasneanu Cristian on 28/05/2019.
//  Copyright © 2019 mikelanza. All rights reserved.
//

import Foundation
import MapKit

// MARK: - Determine carousel

extension STPhotoMapInteractor {
    func shouldDetermineCarousel() {
        guard entityLevelHandler.entityLevel != .location else { return }
        guard self.carouselHandler.carousel.shouldChange(mapRect: self.visibleMapRect) == true else { return }
        
        let cachedTiles = self.getVisibleCachedTiles()
        let geojsonObjects = cachedTiles.compactMap({ $0.geojsonObject })
        if let feature = self.bestFeature(mapRect: self.visibleMapRect, geojsonObjects: geojsonObjects) {
            self.shouldGetGeoEntityForFeature(feature)
        } else {
            self.geojsonObjectsForDeterminingCarousel(tiles: self.prepareTilesForDeterminingCarousel(cachedTiles: cachedTiles))
        }
    }
    
    private func prepareTilesForDeterminingCarousel(cachedTiles: [STPhotoMapGeojsonCache.Tile]) -> [TileCoordinate]  {
        let notCachedTile = self.getVisibleNotCachedTiles()
        return notCachedTile.filter({
            let url = STPhotoMapUrlBuilder().geojsonTileUrl(tileCoordinate: $0)
            return self.carouselHandler.hasActiveDownload(url.keyUrl) == false
        })
    }
    
    private func geojsonObjectsForDeterminingCarousel(tiles: [TileCoordinate]) {
        tiles.forEach({ self.geojsonObjectForDeterminingCarousel(tile: $0) })
    }
    
    private func geojsonObjectForDeterminingCarousel(tile: TileCoordinate) {
        let url = STPhotoMapUrlBuilder().geojsonTileUrl(tileCoordinate: tile)
        self.carouselHandler.addActiveDownload(url.keyUrl)
        self.worker?.getGeojsonTileForCarouselDetermination(tileCoordinate: tile, keyUrl: url.keyUrl, downloadUrl: url.downloadUrl)
    }
    
    private func bestFeature(mapRect: MKMapRect, geojsonObjects: [GeoJSONObject]) -> GeoJSONFeature? {
        var features: [GeoJSONFeature] = geojsonObjects.flatMap({ $0.features() })
        features.sort(by: { self.compare(lht: $0, rht: $1, for: mapRect)})
        return features.first
    }
    
    private func compare(lht: GeoJSONFeature, rht: GeoJSONFeature, for mapRect: MKMapRect) -> Bool {
        let lhtPercentage = mapRect.overlapPercentage(mapRect: lht.objectBoundingBox?.mapRect())
        let rhtPercentage = mapRect.overlapPercentage(mapRect: rht.objectBoundingBox?.mapRect())
        let lhtArea = lht.objectBoundingBox?.mapRect().area() ?? 0
        let rhtArea = rht.objectBoundingBox?.mapRect().area() ?? 0
        let lhtPhotoCount = lht.photoProperties?.photoCount ?? 0
        let rhtPhotoCount = rht.photoProperties?.photoCount ?? 0
        
        if lhtPercentage == rhtPercentage {
            if lhtArea == rhtArea {
                return lhtPhotoCount > rhtPhotoCount
            }
            return lhtArea > rhtArea
        }
        return lhtPercentage > rhtPercentage
    }
    
    private func getVisibleNotCachedTiles() -> [TileCoordinate] {
        return self.visibleTiles.filter({
            let url = STPhotoMapUrlBuilder().geojsonTileUrl(tileCoordinate: $0)
            let cachedTile = try? self.cacheHandler.cache.getTile(for: url.keyUrl)
            return cachedTile == nil ? true : false
        })
    }
    
    private func didDownloadGeojsonTileForDeterminingCarousel(keyUrl: String, geojsonObject: GeoJSONObject) {
        self.carouselHandler.removeActiveDownload(keyUrl)
        
        let feature = self.bestFeature(mapRect: self.visibleMapRect, geojsonObjects: [geojsonObject])
        if self.visibleMapRect.overlapPercentage(mapRect: feature?.objectBoundingBox?.mapRect()) > 80 {
            self.worker?.cancelAllGeojsonTileForCarouselDeterminationOperations()
            self.carouselHandler.removeAllActiveDownloads()
            self.shouldGetGeoEntityForFeature(feature)
        }
    }
}

extension STPhotoMapInteractor {    
    func successDidGetGeojsonTileForCarouselDetermination(tileCoordinate: TileCoordinate, keyUrl: String, downloadUrl: String, geojsonObject: GeoJSONObject) {
        self.didDownloadGeojsonTileForDeterminingCarousel(keyUrl: keyUrl, geojsonObject: geojsonObject)
    }
    
    func failureDidGetGeojsonTileForCarouselDetermination(tileCoordinate: TileCoordinate, keyUrl: String, downloadUrl: String, error: OperationError) {
        self.carouselHandler.removeActiveDownload(keyUrl)
    }
}
