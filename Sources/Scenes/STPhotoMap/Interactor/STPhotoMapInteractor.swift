//
//  STPhotoMapInteractor.swift
//  STPhotoMap
//
//  Created by Crasneanu Cristian on 12/04/2019.
//  Copyright (c) 2019 mikelanza. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit
import MapKit

protocol STPhotoMapBusinessLogic {
    func shouldUpdateVisibleTiles(request: STPhotoMapModels.VisibleTiles.Request)
    func shouldUpdateVisibleMapRect(request: STPhotoMapModels.VisibleMapRect.Request)
    func shouldUpdateSelectedPhotoAnnotation(request: STPhotoMapModels.SelectedPhotoAnnotation.Request)
    
    func shouldCacheGeojsonObjects()
    
    func shouldDetermineEntityLevel()
    func shouldDetermineLocationLevel()
    func shouldDetermineCarousel()
    func shouldDetermineSelectedPhotoAnnotation()
    
    func shouldDownloadImageForPhotoAnnotation(request: STPhotoMapModels.PhotoAnnotationImageDownload.Request)
    
    func shouldNavigateToPhotoDetails(request: STPhotoMapModels.PhotoDetailsNavigation.Request)
    func shouldNavigateToPhotoCollection(request: STPhotoMapModels.PhotoCollectionNavigation.Request)
    
    func shouldInflatePhotoClusterAnnotation(request: STPhotoMapModels.PhotoClusterAnnotationInflation.Request)
    
    func shouldSelectPhotoAnnotation(request: STPhotoMapModels.PhotoAnnotationSelection.Request)
    func shouldSelectPhotoClusterAnnotation(request: STPhotoMapModels.PhotoClusterAnnotationSelection.Request)
    func shouldSelectCarousel(request: STPhotoMapModels.CarouselSelection.Request)
    
    func shouldAskForLocationPermissions()
    
    func shouldOpenDataSourcesLink()
}

protocol STPhotoMapDataStore {
}

class STPhotoMapInteractor: NSObject, STPhotoMapBusinessLogic, STPhotoMapDataStore, STPhotoMapWorkerDelegate {
    var presenter: STPhotoMapPresentationLogic?
    var worker: STPhotoMapWorker?
    
    var visibleTiles: [TileCoordinate]
    var visibleMapRect: MKMapRect
    var selectedPhotoAnnotation: PhotoAnnotation?
    
    var cacheHandler: STPhotoMapCacheHandler
    var entityLevelHandler: STPhotoMapEntityLevelHandler
    var locationLevelHandler: STPhotoMapLocationLevelHandler
    let carouselHandler: STPhotoMapCarouselHandler
    var currentUserLocationHandler: STPhotoMapCurrentUserLocationHandler
    
    override init() {
        self.visibleTiles = []
        self.visibleMapRect = MKMapRect()
        self.cacheHandler = STPhotoMapCacheHandler()
        self.entityLevelHandler = STPhotoMapEntityLevelHandler()
        self.locationLevelHandler = STPhotoMapLocationLevelHandler()
        self.carouselHandler = STPhotoMapCarouselHandler()
        self.currentUserLocationHandler = STPhotoMapCurrentUserLocationHandler()
        
        super.init()
        
        self.worker = STPhotoMapWorker(delegate: self)
        self.entityLevelHandler.delegate = self
        self.carouselHandler.delegate = self
        self.currentUserLocationHandler.delegate = self
    }
    
    internal func getVisibleCachedTiles() -> [STPhotoMapCache.Tile] {
        return self.visibleTiles.compactMap({ tile -> STPhotoMapCache.Tile? in
            let url = STPhotoMapUrlBuilder().geojsonTileUrl(tileCoordinate: tile)
            return try? self.cacheHandler.cache.getTile(for: url.keyUrl)
        })
    }
}

// MARK: - Business logic

extension STPhotoMapInteractor {
    func shouldUpdateVisibleTiles(request: STPhotoMapModels.VisibleTiles.Request) {
        self.visibleTiles = request.tiles
    }
    
    func shouldUpdateVisibleMapRect(request: STPhotoMapModels.VisibleMapRect.Request) {
        self.visibleMapRect = request.mapRect
    }
    
    func shouldUpdateSelectedPhotoAnnotation(request: STPhotoMapModels.SelectedPhotoAnnotation.Request) {
        self.selectedPhotoAnnotation = request.annotation
    }
    
    func shouldDownloadImageForPhotoAnnotation(request: STPhotoMapModels.PhotoAnnotationImageDownload.Request) {
        if request.photoAnnotation.image == nil {
            request.photoAnnotation.isLoading = true
            self.worker?.getImageForPhotoAnnotation(request.photoAnnotation)
        }
    }
    
    func shouldNavigateToPhotoDetails(request: STPhotoMapModels.PhotoDetailsNavigation.Request) {
        self.presenter?.presentNavigateToPhotoDetails(response: STPhotoMapModels.PhotoDetailsNavigation.Response(photoId: request.photoId))
    }
    
    func shouldNavigateToPhotoCollection(request: STPhotoMapModels.PhotoCollectionNavigation.Request) {
        self.presenter?.presentNavigateToPhotoCollection(response: STPhotoMapModels.PhotoCollectionNavigation.Response(location: request.location, entityLevel: request.entityLevel))
    }
    
    func shouldOpenDataSourcesLink() {
        self.presenter?.presentOpenDataSourcesLink()
    }
}

// MARK: - Entity handler delegate

extension STPhotoMapInteractor: STPhotoMapEntityLevelHandlerDelegate {
    func photoMapEntityLevelHandler(newEntityLevel level: EntityLevel) {
        self.worker?.cancelAllGeojsonEntityLevelOperations()
        self.worker?.cancelAllGeojsonLocationLevelOperations()
        
        self.presenter?.presentRemoveLocationAnnotations()
        self.presenter?.presentRemoveLocationOverlay()
        self.presenter?.presentRemoveCarousel()
        self.presenter?.presentEntityLevel(response: STPhotoMapModels.EntityZoomLevel.Response(entityLevel: level))
        self.shouldDetermineCarousel()
    }
    
    func photoMapEntityLevelHandler(location level: EntityLevel) {
        self.worker?.cancelAllGeojsonEntityLevelOperations()
        
        self.presenter?.presentRemoveCarousel()
        self.presenter?.presentEntityLevel(response: STPhotoMapModels.EntityZoomLevel.Response(entityLevel: level))
        
        self.shouldDetermineLocationLevel()
    }
}
