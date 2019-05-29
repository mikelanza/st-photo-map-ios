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
        let url = STPhotoMapUrlBuilder().geojsonTileUrl(tileCoordinate: request.tileCoordinate)
        do {
            let cachedTile = try self.cacheHandler.cache.getTile(for: url.keyUrl)
            let feature = cachedTile.geojsonObject.features().filter({ $0.contains(location: request.location) }).first
            self.shouldGetGeoEntityForFeature(feature)
        } catch {
            self.shouldGetGeojsonTileForCarousel(tileCoordinate: request.tileCoordinate, location: request.location, keyUrl: url.keyUrl, downloadUrl: url.downloadUrl)
        }
    }
    
    func shouldGetGeoEntityForFeature(_ feature: GeoJSONFeature?) {
        if let feature = feature, let id = feature.idAsString {
            self.presenter?.presentLoadingState()
            self.worker?.cancelAllGeoEntityOperations()
            self.worker?.getGeoEntityForEntity(id, entityLevel: feature.entityLevel)
        }
    }
    
    private func shouldGetGeojsonTileForCarousel(tileCoordinate: TileCoordinate, location: STLocation, keyUrl: String, downloadUrl: String) {
        self.presenter?.presentLoadingState()
        self.worker?.cancelAllGeojsonCarouselOperations()
        self.worker?.getGeojsonTileForCarousel(tileCoordinate: tileCoordinate, location: location, keyUrl: keyUrl, downloadUrl: downloadUrl)
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

extension STPhotoMapInteractor {
    func successDidGetGeojsonTileForCarousel(tileCoordinate: TileCoordinate, location: STLocation, keyUrl: String, downloadUrl: String, geojsonObject: GeoJSONObject) {
        self.presenter?.presentNotLoadingState()
        
        let feature = geojsonObject.features().filter({ $0.contains(location: location) }).first
        self.shouldGetGeoEntityForFeature(feature)
    }
    
    func failureDidGetGeojsonTileForCarousel(tileCoordinate: TileCoordinate, location: STLocation, keyUrl: String, downloadUrl: String, error: OperationError) {
        self.presenter?.presentNotLoadingState()
    }
}
