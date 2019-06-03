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

class STPhotoMapWorkerSpy: STPhotoMapWorker {
    var delay: Double = 0
    var geojsonObject: GeoJSONObject!
    var image: UIImage!
    var photo: STPhoto!
    var geoEntity: GeoEntity!
    
    var shouldFailGetGeojsonTileForCaching: Bool = false
    var getGeojsonTileForCachingCalled: Bool = false
    
    var shouldFailGetGeojsonTileForEntityLevel: Bool = false
    var getGeojsonTileForEntityLevelCalled: Bool = false
    
    var shouldFailGetGeojsonForLocationLevel: Bool = false
    var getGeojsonLocationLevelCalled: Bool = false
    
    var shouldFailDownloadImageForPhotoAnnotation: Bool = false
    var downloadImageForPhotoAnnotationCalled: Bool = false
    
    var shouldFailGetPhotoDetailsForPhotoAnnotation: Bool = false
    var getPhotoDetailsForPhotoAnnotationCalled: Bool = false
    
    var shouldFailGetGeoEntityForEntity: Bool = false
    var getGeoEntityForEntityCalled: Bool = false
    
    var shouldFailGetGeojsonTileForCarouselSelection: Bool = false
    var getGeojsonTileForCarouselSelectionCalled: Bool = false
    
    var shouldFailGetGeojsonTileForCarouselDetermination: Bool = false
    var getGeojsonTileForCarouselDeterminationCalled: Bool = false
    
    var shouldFailGetImageForPhoto: Bool = false
    var getImageForPhotoCalled: Bool = false
    
    var cancelAllGeoEntityOperationsCalled: Bool = false
    
    var cancelAllGeojsonCarouselSelectionOperationsCalled: Bool = false
    
    var cancelAllGeojsonCarouselDeterminationOperationsCalled: Bool = false
    
    // MARK: - Geojson tile for caching
    
    override func getGeojsonTileForCaching(tileCoordinate: TileCoordinate, keyUrl: String, downloadUrl: String) {
        self.getGeojsonTileForCachingCalled = true
        
        if self.delay == 0 {
            self.didGetGeojsonTileForCaching(tileCoordinate: tileCoordinate, keyUrl: keyUrl, downloadUrl: downloadUrl)
        } else {
            DispatchQueue.global().asyncAfter(deadline: .now() + self.delay) {
                self.didGetGeojsonTileForCaching(tileCoordinate: tileCoordinate, keyUrl: keyUrl, downloadUrl: downloadUrl)
            }
        }
    }
    
    private func didGetGeojsonTileForCaching(tileCoordinate: TileCoordinate, keyUrl: String, downloadUrl: String) {
        if self.shouldFailGetGeojsonTileForCaching {
            self.delegate?.failureDidGetGeojsonTileForCaching(tileCoordinate: tileCoordinate, keyUrl: keyUrl, downloadUrl: downloadUrl, error: OperationError.noDataAvailable)
        } else {
            self.delegate?.successDidGetGeojsonTileForCaching(tileCoordinate: tileCoordinate, keyUrl: keyUrl, downloadUrl: downloadUrl, geojsonObject: self.geojsonObject)
        }
    }
    
    // MARK: - Geojson for entity level
    
    override func getGeojsonEntityLevel(tileCoordinate: TileCoordinate, keyUrl: String, downloadUrl: String) {
        self.getGeojsonTileForEntityLevelCalled = true
        
        if self.delay == 0 {
            self.didGetGeojsonTileForEntityLevel(tileCoordinate: tileCoordinate, keyUrl: keyUrl, downloadUrl: downloadUrl)
        } else {
            DispatchQueue.global().asyncAfter(deadline: .now() + self.delay) {
                self.didGetGeojsonTileForEntityLevel(tileCoordinate: tileCoordinate, keyUrl: keyUrl, downloadUrl: downloadUrl)
            }
        }
    }
    
    private func didGetGeojsonTileForEntityLevel(tileCoordinate: TileCoordinate, keyUrl: String, downloadUrl: String) {
        if self.shouldFailGetGeojsonTileForEntityLevel {
            self.delegate?.failureDidGetGeojsonTileForEntityLevel(tileCoordinate: tileCoordinate, keyUrl: keyUrl, downloadUrl: downloadUrl, error: OperationError.noDataAvailable)
        } else {
            self.delegate?.successDidGetGeojsonTileForEntityLevel(tileCoordinate: tileCoordinate, keyUrl: keyUrl, downloadUrl: downloadUrl, geojsonObject: self.geojsonObject)
        }
    }
    
    // MARK: - Geojson for location level
    
    override func getGeojsonLocationLevel(tileCoordinate: TileCoordinate, keyUrl: String, downloadUrl: String) {
        self.getGeojsonLocationLevelCalled = true
        
        if self.delay == 0 {
            self.didGetGeojsonTileForLocationLevel(tileCoordinate: tileCoordinate, keyUrl: keyUrl, downloadUrl: downloadUrl)
        } else {
            DispatchQueue.global().asyncAfter(deadline: .now() + self.delay) {
                self.didGetGeojsonTileForLocationLevel(tileCoordinate: tileCoordinate, keyUrl: keyUrl, downloadUrl: downloadUrl)
            }
        }
    }
    
    private func didGetGeojsonTileForLocationLevel(tileCoordinate: TileCoordinate, keyUrl: String, downloadUrl: String) {
        if self.shouldFailGetGeojsonForLocationLevel {
            self.delegate?.failureDidGetGeojsonTileForLocationLevel(tileCoordinate: tileCoordinate, keyUrl: keyUrl, downloadUrl: downloadUrl, error: OperationError.noDataAvailable)
        } else {
            self.delegate?.successDidGetGeojsonTileForLocationLevel(tileCoordinate: tileCoordinate, keyUrl: keyUrl, downloadUrl: downloadUrl, geojsonObject: self.geojsonObject)
        }
    }
    
    // MARK: - Get image for photo annotation
    
    override func downloadImageForPhotoAnnotation(_ photoAnnotation: PhotoAnnotation, completion: ((UIImage?) -> Void)? = nil) {
        self.downloadImageForPhotoAnnotationCalled = true
        
        if self.delay == 0 {
            self.didDownloadImageForPhotoAnnotation(photoAnnotation, completion: completion)
        } else {
            DispatchQueue.global().asyncAfter(deadline: .now() + self.delay) {
                self.didDownloadImageForPhotoAnnotation(photoAnnotation, completion: completion)
            }
        }
    }
    
    private func didDownloadImageForPhotoAnnotation(_ photoAnnotation: PhotoAnnotation, completion: ((UIImage?) -> Void)? = nil) {
        if self.shouldFailDownloadImageForPhotoAnnotation {
            photoAnnotation.isLoading = false
            photoAnnotation.image = nil
            completion?(nil)
        } else {
            photoAnnotation.isLoading = false
            photoAnnotation.image = self.image
            completion?(self.image)
        }
    }
    
    // MARK: - Photo details for photo annotation
    
    override func getPhotoDetailsForPhotoAnnotation(_ photoAnnotation: PhotoAnnotation) {
        self.getPhotoDetailsForPhotoAnnotationCalled = true
        
        if self.delay == 0 {
            self.didGetPhotoDetailsForPhotoAnnotation(photoAnnotation)
        } else {
            DispatchQueue.global().asyncAfter(deadline: .now() + self.delay) {
                self.didGetPhotoDetailsForPhotoAnnotation(photoAnnotation)
            }
        }
    }
    
    private func didGetPhotoDetailsForPhotoAnnotation(_ photoAnnotation: PhotoAnnotation) {
        if self.shouldFailGetPhotoDetailsForPhotoAnnotation {
            self.delegate?.failureDidGetPhotoForPhotoAnnotation(photoAnnotation: photoAnnotation, error: OperationError.noDataAvailable)
        } else {
            self.delegate?.successDidGetPhotoForPhotoAnnotation(photoAnnotation: photoAnnotation, photo: self.photo)
        }
    }
    
    // MARK: - Geo entity for entity
    
    override func getGeoEntityForEntity(_ entityId: String, entityLevel: EntityLevel) {
        self.getGeoEntityForEntityCalled = true
        
        if self.delay == 0 {
            self.didGetGeoEntityForEntity(entityId, entityLevel: entityLevel)
        } else {
            DispatchQueue.global().asyncAfter(deadline: .now() + self.delay) {
                self.didGetGeoEntityForEntity(entityId, entityLevel: entityLevel)
            }
        }
    }
    
    private func didGetGeoEntityForEntity(_ entityId: String, entityLevel: EntityLevel) {
        if self.shouldFailGetGeoEntityForEntity {
            self.delegate?.failureDidGetGeoEntityForEntity(entityId: entityId, entityLevel: entityLevel, error: OperationError.noDataAvailable)
        } else {
            self.delegate?.successDidGetGeoEntityForEntity(entityId: entityId, entityLevel: entityLevel, geoEntity: self.geoEntity)
        }
    }
    
    // MARK: - Geojson for carousel selection
    
    override func getGeojsonTileForCarouselSelection(tileCoordinate: TileCoordinate, location: STLocation, keyUrl: String, downloadUrl: String) {
        self.getGeojsonTileForCarouselSelectionCalled = true
        
        if self.delay == 0 {
            self.didGetGeojsonTileForCarouselSelection(tileCoordinate: tileCoordinate, location: location, keyUrl: keyUrl, downloadUrl: downloadUrl)
        } else {
            DispatchQueue.global().asyncAfter(deadline: .now() + self.delay) {
                self.didGetGeojsonTileForCarouselSelection(tileCoordinate: tileCoordinate, location: location, keyUrl: keyUrl, downloadUrl: downloadUrl)
            }
        }
    }
    
    private func didGetGeojsonTileForCarouselSelection(tileCoordinate: TileCoordinate, location: STLocation, keyUrl: String, downloadUrl: String) {
        if self.shouldFailGetGeojsonTileForCarouselSelection {
            self.delegate?.failureDidGetGeojsonTileForCarouselSelection(tileCoordinate: tileCoordinate, location: location, keyUrl: keyUrl, downloadUrl: downloadUrl, error: OperationError.noDataAvailable)
        } else {
            self.delegate?.successDidGetGeojsonTileForCarouselSelection(tileCoordinate: tileCoordinate, location: location, keyUrl: keyUrl, downloadUrl: downloadUrl, geojsonObject: self.geojsonObject)
        }
    }
    
    // MARK: - Geojson for carousel determination
    
    override func getGeojsonTileForCarouselDetermination(tileCoordinate: TileCoordinate, keyUrl: String, downloadUrl: String) {
        self.getGeojsonTileForCarouselDeterminationCalled = true
        
        if self.delay == 0 {
            self.didGetGeojsonTileForCarouselDetermination(tileCoordinate: tileCoordinate, keyUrl: keyUrl, downloadUrl: downloadUrl)
        } else {
            DispatchQueue.global().asyncAfter(deadline: .now() + self.delay) {
                self.didGetGeojsonTileForCarouselDetermination(tileCoordinate: tileCoordinate, keyUrl: keyUrl, downloadUrl: downloadUrl)
            }
        }
    }
    
    private func didGetGeojsonTileForCarouselDetermination(tileCoordinate: TileCoordinate, keyUrl: String, downloadUrl: String) {
        if self.shouldFailGetGeojsonTileForCarouselDetermination {
            self.delegate?.failureDidGetGeojsonTileForCarouselDetermination(tileCoordinate: tileCoordinate, keyUrl: keyUrl, downloadUrl: downloadUrl, error: OperationError.noDataAvailable)
        } else {
            self.delegate?.successDidGetGeojsonTileForCarouselDetermination(tileCoordinate: tileCoordinate, keyUrl: keyUrl, downloadUrl: downloadUrl, geojsonObject: self.geojsonObject)
        }
    }
    
    // MARK: - Get image for photo
    
    override func getImageForPhoto(photo: STPhoto) {
        self.getImageForPhotoCalled = true
        
        if self.delay == 0 {
            self.didGetImageForPhoto(photo: photo)
        } else {
            DispatchQueue.global().asyncAfter(deadline: .now() + self.delay) {
                self.didGetImageForPhoto(photo: photo)
            }
        }
    }
    
    private func didGetImageForPhoto(photo: STPhoto) {
        if self.shouldFailGetImageForPhoto {
            self.delegate?.successDidGetImageForPhoto(photo: photo, image: nil)
        } else {
            self.delegate?.successDidGetImageForPhoto(photo: photo, image: self.image)
        }
    }
    
    // MARK: - Cancel operations
    
    override func cancelAllGeoEntityOperations() {
        self.cancelAllGeoEntityOperationsCalled = true
    }
    
    override func cancelAllGeojsonCarouselSelectionOperations() {
        self.cancelAllGeojsonCarouselSelectionOperationsCalled = true
    }
    
    override func cancelAllGeojsonTileForCarouselDeterminationOperations() {
        self.cancelAllGeojsonCarouselDeterminationOperationsCalled = true
    }
}
