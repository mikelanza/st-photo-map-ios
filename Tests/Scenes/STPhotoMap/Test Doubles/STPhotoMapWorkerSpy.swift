//
//  STPhotoMapWorkerSpy.swift
//  STPhotoMapTests-iOS
//
//  Created by Dimitri Strauneanu on 10/05/2019.
//  Copyright © 2019 mikelanza. All rights reserved.
//

@testable import STPhotoMap
import UIKit

class STPhotoMapWorkerSuccessSpy: STPhotoMapWorker {
    var delay: Double = 0
    
    var getGeojsonTileForCachingCalled: Bool = false
    var getGeojsonTileForEntityLevelCalled: Bool = false
    var getGeojsonLocationLevelCalled: Bool = false
    var downloadImageForPhotoAnnotationCalled: Bool = false
    var getPhotoDetailsForPhotoAnnotationCalled: Bool = false
    var getGeoEntityForEntityCalled: Bool = false
    var cancelAllGeoEntityOperationsCalled: Bool = false
    var getGeojsonTileForCarouselCalled: Bool = false
    var cancelAllGeojsonCarouselOperationsCalled: Bool = false
    
    override func getGeojsonTileForCaching(tileCoordinate: TileCoordinate, keyUrl: String, downloadUrl: String) {
        self.getGeojsonTileForCachingCalled = true
        
        let geojsonObject = try! STPhotoMapSeeds().geojsonObject()
        self.delegate?.successDidGetGeojsonTileForCaching(tileCoordinate: tileCoordinate, keyUrl: keyUrl, downloadUrl: downloadUrl, geojsonObject: geojsonObject)
    }
    
    override func getGeojsonEntityLevel(tileCoordinate: TileCoordinate, keyUrl: String, downloadUrl: String) {
        self.getGeojsonTileForEntityLevelCalled = true
        
        if self.delay == 0 {
            let geojsonObject = try! STPhotoMapSeeds().geojsonObject()
            self.delegate?.successDidGetGeojsonTileForEntityLevel(tileCoordinate: tileCoordinate, keyUrl: keyUrl, downloadUrl: downloadUrl, geojsonObject: geojsonObject)
        } else {
            DispatchQueue.global().asyncAfter(deadline: .now() + self.delay) {
                let geojsonObject = try! STPhotoMapSeeds().geojsonObject()
                self.delegate?.successDidGetGeojsonTileForEntityLevel(tileCoordinate: tileCoordinate, keyUrl: keyUrl, downloadUrl: downloadUrl, geojsonObject: geojsonObject)
            }
        }
    }
    
    override func getGeojsonLocationLevel(tileCoordinate: TileCoordinate, keyUrl: String, downloadUrl: String) {
        self.getGeojsonLocationLevelCalled = true
        
        if self.delay == 0 {
            let geojsonObject = try! STPhotoMapSeeds().locationGeojsonObject()
            self.delegate?.successDidGetGeojsonTileForLocationLevel(tileCoordinate: tileCoordinate, keyUrl: keyUrl, downloadUrl: downloadUrl, geojsonObject: geojsonObject)
        } else {
            DispatchQueue.global().asyncAfter(deadline: .now() + self.delay) {
                let geojsonObject = try! STPhotoMapSeeds().locationGeojsonObject()
                self.delegate?.successDidGetGeojsonTileForLocationLevel(tileCoordinate: tileCoordinate, keyUrl: keyUrl, downloadUrl: downloadUrl, geojsonObject: geojsonObject)
            }
        }
    }
    
    override func downloadImageForPhotoAnnotation(_ photoAnnotation: PhotoAnnotation, completion: ((UIImage?) -> Void)? = nil) {
        self.downloadImageForPhotoAnnotationCalled = true
        
        if self.delay == 0 {
            photoAnnotation.isLoading = false
            photoAnnotation.image = UIImage()
            completion?(UIImage())
        } else {
            DispatchQueue.global().asyncAfter(deadline: .now() + self.delay) {
                photoAnnotation.isLoading = false
                photoAnnotation.image = UIImage()
                completion?(UIImage())
            }
        }
    }
    
    override func getPhotoDetailsForPhotoAnnotation(_ photoAnnotation: PhotoAnnotation) {
        self.getPhotoDetailsForPhotoAnnotationCalled = true
        
        if self.delay == 0 {
            self.delegate?.successDidGetPhotoForPhotoAnnotation(photoAnnotation: photoAnnotation, photo: STPhotoMapSeeds().photo())
        } else {
            DispatchQueue.global().asyncAfter(deadline: .now() + self.delay) {
                self.delegate?.successDidGetPhotoForPhotoAnnotation(photoAnnotation: photoAnnotation, photo: STPhotoMapSeeds().photo())
            }
        }
    }
    
    override func getGeoEntityForEntity(_ entityId: String, entityLevel: EntityLevel) {
        self.getGeoEntityForEntityCalled = true
        
        if self.delay == 0 {
            self.delegate?.successDidGetGeoEntityForEntity(entityId: entityId, entityLevel: entityLevel, geoEntity: STPhotoMapSeeds().geoEntity())
        } else {
            DispatchQueue.global().asyncAfter(deadline: .now() + self.delay) {
                self.delegate?.successDidGetGeoEntityForEntity(entityId: entityId, entityLevel: entityLevel, geoEntity: STPhotoMapSeeds().geoEntity())
            }
        }
    }
    
    override func cancelAllGeoEntityOperations() {
        self.cancelAllGeoEntityOperationsCalled = true
    }
    
    override func getGeojsonTileForCarousel(tileCoordinate: TileCoordinate, location: STLocation, keyUrl: String, downloadUrl: String) {
        self.getGeojsonTileForCarouselCalled = true
        
        if self.delay == 0 {
            let geojsonObject = try! STPhotoMapSeeds().geojsonObject()
            self.delegate?.successDidGetGeojsonTileForCarousel(tileCoordinate: tileCoordinate, location: location, keyUrl: keyUrl, downloadUrl: downloadUrl, geojsonObject: geojsonObject)
        } else {
            DispatchQueue.global().asyncAfter(deadline: .now() + self.delay) {
                let geojsonObject = try! STPhotoMapSeeds().geojsonObject()
                self.delegate?.successDidGetGeojsonTileForCarousel(tileCoordinate: tileCoordinate, location: location, keyUrl: keyUrl, downloadUrl: downloadUrl, geojsonObject: geojsonObject)
            }
        }
    }
    
    override func cancelAllGeojsonCarouselOperations() {
        self.cancelAllGeojsonCarouselOperationsCalled = true
    }
}

class STPhotoMapWorkerFailureSpy: STPhotoMapWorker {
    var delay: Double = 0
    
    var getGeojsonTileForCachingCalled: Bool = false
    var getGeojsonTileForEntityLevelCalled: Bool = false
    var downloadImageForPhotoAnnotationCalled: Bool = false
    var getPhotoDetailsForPhotoAnnotationCalled: Bool = false
    var getGeoEntityForEntityCalled: Bool = false
    var cancelAllGeoEntityOperationsCalled: Bool = false
    var getGeojsonTileForCarouselCalled: Bool = false
    var cancelAllGeojsonCarouselOperationsCalled: Bool = false
    
    override func getGeojsonTileForCaching(tileCoordinate: TileCoordinate, keyUrl: String, downloadUrl: String) {
        self.getGeojsonTileForCachingCalled = true
        self.delegate?.failureDidGetGeojsonTileForCaching(tileCoordinate: tileCoordinate, keyUrl: keyUrl, downloadUrl: downloadUrl, error: OperationError.cannotParseResponse)
    }
    
    override func getGeojsonEntityLevel(tileCoordinate: TileCoordinate, keyUrl: String, downloadUrl: String) {
        self.getGeojsonTileForEntityLevelCalled = true
        self.delegate?.failureDidGetGeojsonTileForEntityLevel(tileCoordinate: tileCoordinate, keyUrl: keyUrl, downloadUrl: downloadUrl, error: OperationError.cannotParseResponse)
    }
    
    override func downloadImageForPhotoAnnotation(_ photoAnnotation: PhotoAnnotation, completion: ((UIImage?) -> Void)? = nil) {
        self.downloadImageForPhotoAnnotationCalled = true
        
        if self.delay == 0 {
            photoAnnotation.isLoading = false
            photoAnnotation.image = nil
            completion?(nil)
        } else {
            DispatchQueue.global().asyncAfter(deadline: .now() + self.delay) {
                photoAnnotation.isLoading = false
                photoAnnotation.image = nil
                completion?(nil)
            }
        }
    }
    
    override func getPhotoDetailsForPhotoAnnotation(_ photoAnnotation: PhotoAnnotation) {
        self.getPhotoDetailsForPhotoAnnotationCalled = true
        
        if self.delay == 0 {
            self.delegate?.failureDidGetPhotoForPhotoAnnotation(photoAnnotation: photoAnnotation, error: OperationError.cannotParseResponse)
        } else {
            DispatchQueue.global().asyncAfter(deadline: .now() + self.delay) {
                self.delegate?.failureDidGetPhotoForPhotoAnnotation(photoAnnotation: photoAnnotation, error: OperationError.cannotParseResponse)
            }
        }
    }
    
    override func getGeoEntityForEntity(_ entityId: String, entityLevel: EntityLevel) {
        self.getGeoEntityForEntityCalled = true
        
        if self.delay == 0 {
            self.delegate?.failureDidGetGeoEntityForEntity(entityId: entityId, entityLevel: entityLevel, error: OperationError.cannotParseResponse)
        } else {
            DispatchQueue.global().asyncAfter(deadline: .now() + self.delay) {
                self.delegate?.failureDidGetGeoEntityForEntity(entityId: entityId, entityLevel: entityLevel, error: OperationError.cannotParseResponse)
            }
        }
    }
    
    override func cancelAllGeoEntityOperations() {
        self.cancelAllGeoEntityOperationsCalled = true
    }
    
    override func getGeojsonTileForCarousel(tileCoordinate: TileCoordinate, location: STLocation, keyUrl: String, downloadUrl: String) {
        self.getGeojsonTileForCarouselCalled = true
        
        if self.delay == 0 {
            self.delegate?.failureDidGetGeojsonTileForCarousel(tileCoordinate: tileCoordinate, location: location, keyUrl: keyUrl, downloadUrl: downloadUrl, error: OperationError.cannotParseResponse)
        } else {
            DispatchQueue.global().asyncAfter(deadline: .now() + self.delay) {
                self.delegate?.failureDidGetGeojsonTileForCarousel(tileCoordinate: tileCoordinate, location: location, keyUrl: keyUrl, downloadUrl: downloadUrl, error: OperationError.cannotParseResponse)
            }
        }
    }
    
    override func cancelAllGeojsonCarouselOperations() {
        self.cancelAllGeojsonCarouselOperationsCalled = true
    }
}
