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

protocol STPhotoMapBusinessLogic {
    func shouldUpdateVisibleTiles(request: STPhotoMapModels.VisibleTiles.Request)
    
    func shouldCacheGeojsonObjects()
    func shouldDetermineEntityLevel()
}

protocol STPhotoMapDataStore {
}

class STPhotoMapInteractor: STPhotoMapBusinessLogic, STPhotoMapDataStore, STPhotoMapWorkerDelegate {
    var presenter: STPhotoMapPresentationLogic?
    var worker: STPhotoMapWorker?
    
    var visibleTiles: [TileCoordinate]
    var cacheHandler: STPhotoMapCacheHandler
    var entityLevelHandler: STPhotoMapEntityLevelHandler
    
    init() {
        self.visibleTiles = []
        self.cacheHandler = STPhotoMapCacheHandler()
        self.entityLevelHandler = STPhotoMapEntityLevelHandler()
        self.worker = STPhotoMapWorker(delegate: self)
        self.entityLevelHandler.delegate = self
    }
}

// MARK: - Business logic

extension STPhotoMapInteractor {
    func shouldUpdateVisibleTiles(request: STPhotoMapModels.VisibleTiles.Request) {
        self.visibleTiles = request.tiles
    }
}

// MARK: - Entity handler delegate

extension STPhotoMapInteractor: STPhotoMapEntityLevelHandlerDelegate {
    func photoMapEntityLevelHandler(newEntityLevel level: EntityLevel) {
        self.worker?.cancelAllGeojsonEntityLevelOperations()
        self.presenter?.presentEntityLevel(response: STPhotoMapModels.EntityZoomLevel.Response(entityLevel: level))
    }
}
