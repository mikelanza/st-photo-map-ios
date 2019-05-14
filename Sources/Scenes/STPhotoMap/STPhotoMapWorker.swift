//
//  STPhotoMapWorker.swift
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

protocol STPhotoMapWorkerDelegate: class {
    func successDidGetGeojsonTileForCaching(tileCoordinate: TileCoordinate, keyUrl: String, downloadUrl: String, geojsonObject: GeoJSONObject)
    func failureDidGetGeojsonTileForCaching(tileCoordinate: TileCoordinate, keyUrl: String, downloadUrl: String, error: OperationError)
    
    func successDidGetGeojsonTileForEntityLevel(tileCoordinate: TileCoordinate, keyUrl: String, downloadUrl: String, geojsonObject: GeoJSONObject)
    func failureDidGetGeojsonTileForEntityLevel(tileCoordinate: TileCoordinate, keyUrl: String, downloadUrl: String, error: OperationError)
}

class STPhotoMapWorker {
    public var delegate: STPhotoMapWorkerDelegate?
    private var geojsonTileCachingQueue: OperationQueue
    private var geojsonEntityLevelQueue: OperationQueue
    
    init(delegate: STPhotoMapWorkerDelegate? = nil) {
        self.delegate = delegate
        
        self.geojsonTileCachingQueue = OperationQueue()
        self.geojsonTileCachingQueue.maxConcurrentOperationCount = 12
        
        self.geojsonEntityLevelQueue = OperationQueue()
        self.geojsonEntityLevelQueue.maxConcurrentOperationCount = 12
    }
    
    func getGeojsonTileForCaching(tileCoordinate: TileCoordinate, keyUrl: String, downloadUrl: String) {
        let model = GetGeojsonTileOperationModel.Request(tileCoordinate: tileCoordinate, url: downloadUrl)
        let operation = GetGeojsonTileOperation(model: model) { result in
            switch result {
                case .success(let value): self.delegate?.successDidGetGeojsonTileForCaching(tileCoordinate: tileCoordinate, keyUrl: keyUrl, downloadUrl: downloadUrl, geojsonObject: value.geoJSONObject); break
                case .failure(let error): self.delegate?.failureDidGetGeojsonTileForCaching(tileCoordinate: tileCoordinate, keyUrl: keyUrl, downloadUrl: downloadUrl, error: error); break
            }
        }
        self.geojsonTileCachingQueue.addOperation(operation)
    }
    
    func getGeojsonEntityLevel(tileCoordinate: TileCoordinate, keyUrl: String, downloadUrl: String) {
        let model = GetGeojsonTileOperationModel.Request(tileCoordinate: tileCoordinate, url: downloadUrl)
        let operation = GetGeojsonTileOperation(model: model) { result in
            switch result {
            case .success(let value): self.delegate?.successDidGetGeojsonTileForEntityLevel(tileCoordinate: tileCoordinate, keyUrl: keyUrl, downloadUrl: downloadUrl, geojsonObject: value.geoJSONObject); break
            case .failure(let error): self.delegate?.failureDidGetGeojsonTileForEntityLevel(tileCoordinate: tileCoordinate, keyUrl: keyUrl, downloadUrl: downloadUrl, error: error); break
            }
        }
        self.geojsonEntityLevelQueue.addOperation(operation)
    }
    
    func cancelAllGeojsonEntityLevelOperations() {
        self.geojsonEntityLevelQueue.cancelAllOperations()
    }
}
