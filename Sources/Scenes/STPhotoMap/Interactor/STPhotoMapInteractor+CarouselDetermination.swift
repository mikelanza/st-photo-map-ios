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
    func shouldDetermineCarousel(request: STPhotoMapModels.CarouselDetermination.Request) {
        guard entityLevelHandler.entityLevel != .location else { return }
        guard self.carouselHandler.carousel.shouldChange(mapRect: request.mapRect) == true else { return }
        
        let cachedTiles = self.getVisibleCachedTiles()
        let geojsonObjects = cachedTiles.compactMap({ $0.geojsonObject })
        if let feature = self.bestFeature(mapRect: request.mapRect, geojsonObjects: geojsonObjects) {
            self.shouldGetEntityForFeature(feature)
        } else {
            self.geojsonObjectsForDeterminingCarousel(tiles: self.prepareTilesForDeterminingCarousel(cachedTiles: cachedTiles))
        }
    }
    
    private func prepareTilesForDeterminingCarousel(cachedTiles: [STPhotoMapCache.Tile]) -> [TileCoordinate]  {
        return []
    }
    
    private func geojsonObjectsForDeterminingCarousel(tiles: [TileCoordinate] ) {
        tiles.forEach({ self.geojsonObjectForDeterminingCarousel(tile: $0) })
    }
    
    private func geojsonObjectForDeterminingCarousel(tile: TileCoordinate) {
        let url = STPhotoMapUrlBuilder().geojsonTileUrl(tileCoordinate: tile)
        //self.carouselHandler.addActiveDownload(url.keyUrl)
        self.worker?.getGeojsonTileForDeterminingCarousel(tileCoordinate: tile, keyUrl: url.keyUrl, downloadUrl: url.downloadUrl)
    }
    
    private func bestFeature(mapRect: MKMapRect, geojsonObjects: [GeoJSONObject]) -> GeoJSONFeature? {
        var features: [GeoJSONFeature] = geojsonObjects.flatMap({ $0.features() })
        features.sort(by: { self.compare(lht: $0, rht: $1, for: mapRect)})
        return features.first
    }
    
    private func compare(lht: GeoJSONFeature, rht: GeoJSONFeature, for mapRect: MKMapRect) -> Bool {
        return mapRect.overlapPercentage(mapRect: lht.objectBoundingBox?.mapRect()) > mapRect.overlapPercentage(mapRect: rht.objectBoundingBox?.mapRect()) &&
            lht.objectBoundingBox?.mapRect().area() ?? 0 > rht.objectBoundingBox?.mapRect().area() ?? 0 &&
            lht.photoProperties?.photoCount ?? 0 > rht.photoProperties?.photoCount ?? 0
    }
    
    private func didDownloadGeojsonTileForDeterminingCarousel(geojsonObject: GeoJSONObject) {
        // Check if geojsonObject fulfill conditions
    }
}

extension STPhotoMapInteractor {
    func successDidGetGeojsonTileForDeterminingCarousel(tileCoordinate: TileCoordinate, keyUrl: String, downloadUrl: String, geojsonObject: GeoJSONObject) {
        self.didDownloadGeojsonTileForDeterminingCarousel(geojsonObject: geojsonObject)
    }
    
    func failureDidGetGeojsonTileForDeterminingCarousel(tileCoordinate: TileCoordinate, keyUrl: String, downloadUrl: String, error: OperationError) {
        
    }
}
