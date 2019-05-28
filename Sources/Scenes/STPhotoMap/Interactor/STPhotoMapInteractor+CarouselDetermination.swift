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
        
        let cachedTiles = self.getVisibleCachedTiles()
        let feature = self.bestFeature(mapRect: request.mapRect, geojsonObjects: cachedTiles.compactMap({ $0.geojsonObject }))
        self.shouldGetEntityForFeature(feature)
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
}

extension STPhotoMapInteractor {
    func successDidGetGeojsonTileForDeterminingCarousel(tileCoordinate: TileCoordinate, keyUrl: String, downloadUrl: String, geojsonObject: GeoJSONObject) {
        
    }
    
    func failureDidGetGeojsonTileForDeterminingCarousel(tileCoordinate: TileCoordinate, keyUrl: String, downloadUrl: String, error: OperationError) {
        
    }
}
