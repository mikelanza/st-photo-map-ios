//
//  STCarousel.swift
//  STPhotoMap-iOS
//
//  Created by Dimitri Strauneanu on 23/05/2019.
//  Copyright © 2019 mikelanza. All rights reserved.
//

import UIKit

class STCarousel {
    struct Photo {
        var id: String
        var image: UIImage?
    }
    
    struct Label {
        var latitude: Double
        var longitude: Double
        var radius: Double
    }
    
    var entityId: Int
    var name: String = ""
    var overlays: [STCarouselOverlay]
    var photoCount: Int = 0
    var titleLabel: Label?
    var entityLevel: EntityLevel
    
    var shouldDrawTutorialLabel: Bool
    var numberOfTutorialTextUpdates: Int = 1
    
    var photos: [Photo] = []
    var currentPhoto: Photo?
    
    init(entityId: Int, name: String, overlays: [STCarouselOverlay], photoCount: Int, titleLabel: Label?, entityLevel: EntityLevel, shouldDrawTutorialLabel: Bool) {
        self.entityId = entityId
        self.name = name
        self.overlays = overlays
        self.photoCount = photoCount
        self.titleLabel = titleLabel
        self.entityLevel = entityLevel
        self.shouldDrawTutorialLabel = shouldDrawTutorialLabel
        
        self.updateOverlays()
    }
    
    public func add(_ photo: Photo) {
        self.photos.append(photo)
    }
    
    private func updateOverlays() {
        guard let label = self.titleLabel else {
            return
        }
        
        let biggestOverlay = self.getBiggestOverlay()
        biggestOverlay?.model.shouldDrawEntityButton = true
        biggestOverlay?.model.shouldDrawTutorialLabel = self.shouldDrawTutorialLabel
        biggestOverlay?.model.tutorialText = ""
        
        for overlay in self.overlays {
            overlay.model.location = STLocation(latitude: label.latitude, longitude: label.longitude)
            overlay.model.radius = label.radius
            
            if self.photoCount == 1 {
                overlay.model.shouldDrawEntityButton = false
            }
            
            if self.shouldDrawTutorialLabel {
                overlay.model.shouldDrawLabel = false
            } else {
                overlay.model.shouldDrawLabel = self.entityLevel != .block
            }
        }
    }
    
    public func setOverlay(photo: Photo) {
        for overlay in overlays {
            overlay.model.photoId = photo.id
            overlay.model.photoImage = photo.image
        }
    }
    
    public func update() {
        self.updateTutorialText()
        self.updateImage()
    }
    
    private func updateTutorialText() {
        guard self.shouldDrawTutorialLabel else {
            return
        }
        
        let biggestOverlay = self.getBiggestOverlay()
        if self.numberOfTutorialTextUpdates == 1 {
            biggestOverlay?.model.tutorialText = ""
            self.numberOfTutorialTextUpdates -= 1
        } else if self.numberOfTutorialTextUpdates == 0 {
            biggestOverlay?.model.tutorialText = ""
            biggestOverlay?.model.shouldDrawTutorialLabel = false
            biggestOverlay?.model.shouldDrawLabel = true
            self.shouldDrawTutorialLabel = false
        }
    }
    
    private func updateImage() {
        guard self.photos.count > 0 else { return }
        
        let currentSelectedPhotoIndex = self.photos.firstIndex(where: { $0.id == self.currentPhoto?.id })
        
        guard let index = currentSelectedPhotoIndex, self.photos.count > index + 1 else {
            self.currentPhoto = self.photos[0]
            self.setOverlay(photo: self.photos[0])
            return
        }
        
        self.currentPhoto = self.photos[index + 1]
        self.setOverlay(photo: self.photos[index + 1])
    }
    
    public func getBiggestOverlay() -> STCarouselOverlay? {
        return self.overlays.max(by: { return $0.boundingMapRect.area() < $1.boundingMapRect.area() })
    }
}
