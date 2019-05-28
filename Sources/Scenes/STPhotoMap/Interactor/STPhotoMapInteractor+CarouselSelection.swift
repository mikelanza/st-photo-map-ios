//
//  STPhotoMapInteractor+CarouselSelection.swift
//  STPhotoMap-iOS
//
//  Created by Dimitri Strauneanu on 28/05/2019.
//  Copyright © 2019 mikelanza. All rights reserved.
//

import Foundation

extension STPhotoMapInteractor {
    func shouldSelectCarousel(request: STPhotoMapModels.CarouselSelection.Request) {
        do {
            let url = STPhotoMapUrlBuilder().geojsonTileUrl(tileCoordinate: request.tileCoordinate)
            let cachedTile = try self.cacheHandler.cache.getTile(for: url.keyUrl)
            let feature = cachedTile.geojsonObject.features().filter({ $0.contains(location: request.location) }).first
            self.shouldGetEntityForFeature(feature)
        } catch {
            
        }
    }
    
    func shouldGetEntityForFeature(_ feature: GeoJSONFeature?) {
        if let feature = feature, let id = feature.idAsString {
            self.presenter?.presentLoadingState()
            self.worker?.cancelAllGeoEntityOperations()
            self.worker?.getGeoEntityForEntity(id, entityLevel: feature.entityLevel)
        }
    }
}

extension STPhotoMapInteractor {
    func successDidGetGeoEntityForEntity(entityId: String, entityLevel: EntityLevel, geoEntity: GeoEntity) {
        self.presenter?.presentNotLoadingState()
        self.presenter?.presentRemoveCarousel()
        
        self.carouselHandler.updateCarouselFor(geoEntity: geoEntity)
        self.presenter?.presentNewCarousel(response: STPhotoMapModels.NewCarousel.Response(carousel: self.carouselHandler.carousel))
    }
    
    func failureDidGetGeoEntityForEntity(entityId: String, entityLevel: EntityLevel, error: OperationError) {
        self.presenter?.presentNotLoadingState()
    }
}
