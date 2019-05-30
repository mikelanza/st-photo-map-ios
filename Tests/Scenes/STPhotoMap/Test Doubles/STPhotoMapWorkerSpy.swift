//
//  STPhotoMapWorkerSpy.swift
//  STPhotoMapTests-iOS
//
//  Created by Dimitri Strauneanu on 10/05/2019.
//  Copyright © 2019 mikelanza. All rights reserved.
//

@testable import STPhotoMap
import UIKit
import MapKit

class STPhotoMapWorkerSuccessSpy: STPhotoMapWorker {
    var delay: Double = 0
    
    var getGeojsonTileForCachingCalled: Bool = false
    var getGeojsonTileForEntityLevelCalled: Bool = false
    var getGeojsonLocationLevelCalled: Bool = false
    var downloadImageForPhotoAnnotationCalled: Bool = false
    var getPhotoDetailsForPhotoAnnotationCalled: Bool = false
    var getGeoEntityForEntityCalled: Bool = false
    var cancelAllGeoEntityOperationsCalled: Bool = false
    var getGeojsonTileForCarouselSelectionCalled: Bool = false
    var cancelAllGeojsonCarouselSelectionOperationsCalled: Bool = false
    var getGeojsonTileForCarouselDeterminationCalled: Bool = false
    var cancelAllGeojsonCarouselDeterminationOperationsCalled: Bool = false
    var getImageForPhotoCalled: Bool = false
    
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
        let geoEntity = try! STPhotoMapSeeds().geoEntity()
        if self.delay == 0 {
            self.delegate?.successDidGetGeoEntityForEntity(entityId: entityId, entityLevel: entityLevel, geoEntity: geoEntity)
        } else {
            DispatchQueue.global().asyncAfter(deadline: .now() + self.delay) {
                self.delegate?.successDidGetGeoEntityForEntity(entityId: entityId, entityLevel: entityLevel, geoEntity: geoEntity)
            }
        }
    }
    
    override func cancelAllGeoEntityOperations() {
        self.cancelAllGeoEntityOperationsCalled = true
    }
    
    override func getGeojsonTileForCarouselSelection(tileCoordinate: TileCoordinate, location: STLocation, keyUrl: String, downloadUrl: String) {
        self.getGeojsonTileForCarouselSelectionCalled = true
        
        if self.delay == 0 {
            let geojsonObject = try! STPhotoMapSeeds().geojsonObject()
            self.delegate?.successDidGetGeojsonTileForCarouselSelection(tileCoordinate: tileCoordinate, location: location, keyUrl: keyUrl, downloadUrl: downloadUrl, geojsonObject: geojsonObject)
        } else {
            DispatchQueue.global().asyncAfter(deadline: .now() + self.delay) {
                let geojsonObject = try! STPhotoMapSeeds().geojsonObject()
                self.delegate?.successDidGetGeojsonTileForCarouselSelection(tileCoordinate: tileCoordinate, location: location, keyUrl: keyUrl, downloadUrl: downloadUrl, geojsonObject: geojsonObject)
            }
        }
    }
    
    override func cancelAllGeojsonCarouselSelectionOperations() {
        self.cancelAllGeojsonCarouselSelectionOperationsCalled = true
    }
    
    override func getGeojsonTileForCarouselDetermination(tileCoordinate: TileCoordinate, mapRect: MKMapRect, keyUrl: String, downloadUrl: String) {
        self.getGeojsonTileForCarouselDeterminationCalled = true
        
        let geojsonObject = try! STPhotoMapSeeds().geojsonObject()
        if self.delay == 0 {
            self.delegate?.successDidGetGeojsonTileForCarouselDetermination(tileCoordinate: tileCoordinate, mapRect: mapRect, keyUrl: keyUrl, downloadUrl: downloadUrl, geojsonObject: geojsonObject)
        } else {
            DispatchQueue.global().asyncAfter(deadline: .now() + self.delay) {
                self.delegate?.successDidGetGeojsonTileForCarouselDetermination(tileCoordinate: tileCoordinate, mapRect: mapRect, keyUrl: keyUrl, downloadUrl: downloadUrl, geojsonObject: geojsonObject)
            }
        }
    }
    
    override func cancelAllGeojsonTileForCarouselDeterminationOperations() {
        self.cancelAllGeojsonCarouselDeterminationOperationsCalled = true
    }
    
    override func getImageForPhoto(photo: STPhoto) {
        self.getImageForPhotoCalled = true
        
        if self.delay == 0 {
            self.delegate?.successDidGetImageForPhoto(photo: photo, image: UIImage())
        } else {
            DispatchQueue.global().asyncAfter(deadline: .now() + self.delay) {
                self.delegate?.successDidGetImageForPhoto(photo: photo, image: UIImage())
            }
        }
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
    var getGeojsonTileForCarouselSelectionCalled: Bool = false
    var cancelAllGeojsonCarouselSelectionOperationsCalled: Bool = false
    var getGeojsonTileForCarouselDeterminationCalled: Bool = false
    var cancelAllGeojsonCarouselDeterminationOperationsCalled: Bool = false
    var getImageForPhotoCalled: Bool = false
    
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
    
    override func getGeojsonTileForCarouselSelection(tileCoordinate: TileCoordinate, location: STLocation, keyUrl: String, downloadUrl: String) {
        self.getGeojsonTileForCarouselSelectionCalled = true
        
        if self.delay == 0 {
            self.delegate?.failureDidGetGeojsonTileForCarouselSelection(tileCoordinate: tileCoordinate, location: location, keyUrl: keyUrl, downloadUrl: downloadUrl, error: OperationError.cannotParseResponse)
        } else {
            DispatchQueue.global().asyncAfter(deadline: .now() + self.delay) {
                self.delegate?.failureDidGetGeojsonTileForCarouselSelection(tileCoordinate: tileCoordinate, location: location, keyUrl: keyUrl, downloadUrl: downloadUrl, error: OperationError.cannotParseResponse)
            }
        }
    }
    
    override func cancelAllGeojsonCarouselSelectionOperations() {
        self.cancelAllGeojsonCarouselSelectionOperationsCalled = true
    }
    
    override func getGeojsonTileForCarouselDetermination(tileCoordinate: TileCoordinate, mapRect: MKMapRect, keyUrl: String, downloadUrl: String) {
        self.getGeojsonTileForCarouselDeterminationCalled = true
        
        if self.delay == 0 {
            self.delegate?.failureDidGetGeojsonTileForCarouselDetermination(tileCoordinate: tileCoordinate, mapRect: mapRect, keyUrl: keyUrl, downloadUrl: downloadUrl, error: OperationError.cannotParseResponse)
        } else {
            DispatchQueue.global().asyncAfter(deadline: .now() + self.delay) {
                self.delegate?.failureDidGetGeojsonTileForCarouselDetermination(tileCoordinate: tileCoordinate, mapRect: mapRect, keyUrl: keyUrl, downloadUrl: downloadUrl, error: OperationError.cannotParseResponse)
            }
        }
    }
    
    override func cancelAllGeojsonTileForCarouselDeterminationOperations() {
         self.cancelAllGeojsonCarouselDeterminationOperationsCalled = true
    }

    override func getImageForPhoto(photo: STPhoto) {
        self.getImageForPhotoCalled = true
        
        if self.delay == 0 {
            self.delegate?.successDidGetImageForPhoto(photo: photo, image: nil)
        } else {
            DispatchQueue.global().asyncAfter(deadline: .now() + self.delay) {
                self.delegate?.successDidGetImageForPhoto(photo: photo, image: nil)
            }
        }
    }
}
