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
    
    func successDidGetGeojsonTileForLocationLevel(tileCoordinate: TileCoordinate, keyUrl: String, downloadUrl: String, geojsonObject: GeoJSONObject)
    func failureDidGetGeojsonTileForLocationLevel(tileCoordinate: TileCoordinate, keyUrl: String, downloadUrl: String, error: OperationError)
    
    func successDidGetPhotoForPhotoAnnotation(photoAnnotation: PhotoAnnotation, photo: STPhoto)
    func failureDidGetPhotoForPhotoAnnotation(photoAnnotation: PhotoAnnotation, error: OperationError)
    
    func successDidGetGeoEntityForEntity(entityId: String, entityLevel: EntityLevel, geoEntity: GeoEntity)
    func failureDidGetGeoEntityForEntity(entityId: String, entityLevel: EntityLevel, error: OperationError)
    
    func successDidGetGeojsonTileForCarouselSelection(tileCoordinate: TileCoordinate, location: STLocation, keyUrl: String, downloadUrl: String, geojsonObject: GeoJSONObject)
    func failureDidGetGeojsonTileForCarouselSelection(tileCoordinate: TileCoordinate, location: STLocation, keyUrl: String, downloadUrl: String, error: OperationError)
    
    func successDidGetGeojsonTileForDeterminingCarousel(tileCoordinate: TileCoordinate, keyUrl: String, downloadUrl: String, geojsonObject: GeoJSONObject)
    func failureDidGetGeojsonTileForDeterminingCarousel(tileCoordinate: TileCoordinate, keyUrl: String, downloadUrl: String, error: OperationError)
}

class STPhotoMapWorker {
    public var delegate: STPhotoMapWorkerDelegate?
    private var geojsonTileCachingQueue: OperationQueue
    private var geojsonEntityLevelQueue: OperationQueue
    private var geojsonLocationLevelQueue: OperationQueue
    private var geojsonTileDeterminingCarouselQueue: OperationQueue
    private var geoEntityQueue: OperationQueue
    private var geojsonTileCarouselSelectionQueue: OperationQueue
    
    init(delegate: STPhotoMapWorkerDelegate? = nil) {
        self.delegate = delegate
        
        self.geojsonTileCachingQueue = OperationQueue()
        self.geojsonTileCachingQueue.maxConcurrentOperationCount = 12
        
        self.geojsonEntityLevelQueue = OperationQueue()
        
        self.geojsonLocationLevelQueue = OperationQueue()
        self.geojsonLocationLevelQueue.maxConcurrentOperationCount = 12
        
        self.geoEntityQueue = OperationQueue()
        self.geoEntityQueue.maxConcurrentOperationCount = 1
        
        self.geojsonTileCarouselSelectionQueue = OperationQueue()
        self.geojsonTileCarouselSelectionQueue.maxConcurrentOperationCount = 1
        
        self.geojsonTileDeterminingCarouselQueue = OperationQueue()
        self.geojsonTileDeterminingCarouselQueue.maxConcurrentOperationCount = 12
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
    
    func downloadImageForPhotoAnnotation(_ photoAnnotation: PhotoAnnotation, completion: ((_ image: UIImage?) -> Void)? = nil) {
        photoAnnotation.model.imageUrl?.downloadImage(result: { (image, error) in
            photoAnnotation.isLoading = false
            photoAnnotation.image = image
            completion?(image)
        })
    }
    
    func getGeojsonLocationLevel(tileCoordinate: TileCoordinate, keyUrl: String, downloadUrl: String) {
        let model = GetGeojsonTileOperationModel.Request(tileCoordinate: tileCoordinate, url: downloadUrl)
        let operation = GetGeojsonTileOperation(model: model) { result in
            switch result {
            case .success(let value): self.delegate?.successDidGetGeojsonTileForLocationLevel(tileCoordinate: tileCoordinate, keyUrl: keyUrl, downloadUrl: downloadUrl, geojsonObject: value.geoJSONObject); break
            case .failure(let error): self.delegate?.failureDidGetGeojsonTileForLocationLevel(tileCoordinate: tileCoordinate, keyUrl: keyUrl, downloadUrl: downloadUrl, error: error); break
            }
        }
        self.geojsonLocationLevelQueue.addOperation(operation)
    }
    
    func cancelAllGeojsonLocationLevelOperations() {
        self.geojsonLocationLevelQueue.cancelAllOperations()
    }
    
    func getGeojsonTileForCarouselSelection(tileCoordinate: TileCoordinate, location: STLocation, keyUrl: String, downloadUrl: String) {
        let model = GetGeojsonTileOperationModel.Request(tileCoordinate: tileCoordinate, url: downloadUrl)
        let operation = GetGeojsonTileOperation(model: model) { result in
            switch result {
            case .success(let value): self.delegate?.successDidGetGeojsonTileForCarouselSelection(tileCoordinate: tileCoordinate, location: location, keyUrl: keyUrl, downloadUrl: downloadUrl, geojsonObject: value.geoJSONObject); break
            case .failure(let error): self.delegate?.failureDidGetGeojsonTileForCarouselSelection(tileCoordinate: tileCoordinate, location: location, keyUrl: keyUrl, downloadUrl: downloadUrl, error: error); break
            }
        }
        self.geojsonTileCarouselSelectionQueue.addOperation(operation)
    }
    
    func cancelAllGeojsonCarouselSelectionOperations() {
        self.geojsonTileCarouselSelectionQueue.cancelAllOperations()
    }
    
    func getPhotoDetailsForPhotoAnnotation(_ photoAnnotation: PhotoAnnotation) {
        let queue = OperationQueue()
        queue.maxConcurrentOperationCount = 1
        
        let model = GetPhotoOperationModel.Request(photoId: photoAnnotation.model.photoId)
        let operation = GetPhotoOperation(model: model) { result in
            switch result {
                case .success(let value): self.delegate?.successDidGetPhotoForPhotoAnnotation(photoAnnotation: photoAnnotation, photo: value.photo); break
                case .failure(let error): self.delegate?.failureDidGetPhotoForPhotoAnnotation(photoAnnotation: photoAnnotation, error: error); break
            }
        }
        
        queue.addOperation(operation)
    }
    
    func getGeoEntityForEntity(_ entityId: String, entityLevel: EntityLevel) {
        let model = GetGeoEntityOperationModel.Request(entityId: entityId, entity: entityLevel, page: 0, limit: 10)
        let operation = GetGeoEntityOperation(model: model) { result in
            switch result {
                case .success(let value): self.delegate?.successDidGetGeoEntityForEntity(entityId: entityId, entityLevel: entityLevel, geoEntity: value.geoEntity); break
                case .failure(let error): self.delegate?.failureDidGetGeoEntityForEntity(entityId: entityId, entityLevel: entityLevel, error: error); break
            }
        }
        self.geoEntityQueue.addOperation(operation)
    }
    
    func cancelAllGeoEntityOperations() {
        self.geoEntityQueue.cancelAllOperations()
    }
    
    func getGeojsonTileForDeterminingCarousel(tileCoordinate: TileCoordinate, keyUrl: String, downloadUrl: String) {
        let model = GetGeojsonTileOperationModel.Request(tileCoordinate: tileCoordinate, url: downloadUrl)
        let operation = GetGeojsonTileOperation(model: model) { result in
            switch result {
            case .success(let value): self.delegate?.successDidGetGeojsonTileForDeterminingCarousel(tileCoordinate: tileCoordinate, keyUrl: keyUrl, downloadUrl: downloadUrl, geojsonObject: value.geoJSONObject); break
            case .failure(let error): self.delegate?.failureDidGetGeojsonTileForDeterminingCarousel(tileCoordinate: tileCoordinate, keyUrl: keyUrl, downloadUrl: downloadUrl, error: error); break
            }
        }
        self.geojsonTileDeterminingCarouselQueue.addOperation(operation)
    }
    
    func cancelAllGeojsonTileForDeterminingCarouselOperations() {
        self.geojsonTileDeterminingCarouselQueue.cancelAllOperations()
    }
}
