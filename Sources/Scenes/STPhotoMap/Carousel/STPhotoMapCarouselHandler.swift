//
//  STPhotoMapCarouselHandler.swift
//  STPhotoMap-iOS
//
//  Created by Dimitri Strauneanu on 23/05/2019.
//  Copyright © 2019 mikelanza. All rights reserved.
//

import Foundation

class STPhotoMapCarouselHandler {
    var carousel: STCarousel
    var timer: RepeatingTimer
    
    var activeDownloads: SynchronizedArray<String>
    
    init() {
        self.carousel = STCarousel()
        self.timer = RepeatingTimer(timeInterval: 3)
        self.activeDownloads = SynchronizedArray<String>()
        self.timer.eventHandler = {
            self.reloadCarousel()
        }
    }
    
    func updateCarouselFor(geoEntity: GeoEntity) {
        self.carousel = geoEntity.toCarousel()
        
        self.updateBiggestCarouselOverlay()
        self.updateCarouselOverlays()
    }
    
    func addDownloadedCarouselPhoto(_ photo: STCarousel.Photo) {
        self.carousel.downloadedPhotos.append(photo)
    }
    
    private func reloadCarousel() {
        self.updateCarouselTutorialText()
        self.updateCarouselPhoto()
    }
    
    func hasActiveDownload(_ url: String) -> Bool {
        return self.activeDownloads.contains(url)
    }
    
    func addActiveDownload(_ url: String) {
        self.activeDownloads.append(url)
    }
    
    func removeActiveDownload(_ url: String) {
        self.activeDownloads.remove(where: { $0 == url })
    }
    
    func removeAllActiveDownloads() {
        self.activeDownloads.removeAll()
    }
}

// MARK: - Update biggest carousel overlay

extension STPhotoMapCarouselHandler {
    private func updateBiggestCarouselOverlay() {
        let biggestOverlay = self.carousel.overlays.max(by: { return $0.boundingMapRect.area() < $1.boundingMapRect.area() })
        biggestOverlay?.model.shouldDrawEntityButton = true
        biggestOverlay?.model.shouldDrawTutorialLabel = self.carousel.shouldDrawTutorialLabel
        biggestOverlay?.model.tutorialText = "" // TODO: - Add localized text!
    }
}

// MARK: - Update carousel overlays

extension STPhotoMapCarouselHandler {
    private func updateCarouselOverlays() {
        guard let titleLabel = self.carousel.titleLabel else {
            return
        }
        let location = titleLabel.location()
        
        self.carousel.overlays.forEach { overlay in
            overlay.model.location = location
            overlay.model.radius = titleLabel.radius
            
            if self.carousel.photoCount == 1 {
                overlay.model.shouldDrawEntityButton = false
            }
            
            if self.carousel.shouldDrawTutorialLabel {
                overlay.model.shouldDrawLabel = false
            } else {
                overlay.model.shouldDrawLabel = self.carousel.entityLevel != .block
            }
        }
    }
}

// MARK: - Update carousel tutorial text

extension STPhotoMapCarouselHandler {
    private func updateCarouselTutorialText() {
        guard self.carousel.shouldDrawTutorialLabel else {
            return
        }
        
        let biggestOverlay = self.carousel.overlays.max(by: { return $0.boundingMapRect.area() < $1.boundingMapRect.area() })
        if self.carousel.numberOfTutorialTextUpdates == 1 {
            biggestOverlay?.model.tutorialText = ""
            self.carousel.numberOfTutorialTextUpdates -= 1
        } else if self.carousel.numberOfTutorialTextUpdates == 0 {
            biggestOverlay?.model.tutorialText = ""
            biggestOverlay?.model.shouldDrawTutorialLabel = false
            biggestOverlay?.model.shouldDrawLabel = true
            self.carousel.shouldDrawTutorialLabel = false
        }
    }
}

// MARK: - Update carousel photo

extension STPhotoMapCarouselHandler {
    private func updateCarouselPhoto() {
        guard self.carousel.downloadedPhotos.count > 0 else {
            return
        }
        
        var photo = self.carousel.downloadedPhotos.first
        if let index = self.carousel.downloadedPhotos.firstIndex(where: { $0.id == self.carousel.currentPhoto?.id }) {
            photo = self.carousel.downloadedPhotos[optional: index + 1]
        }
        
        if let photo = photo {
            self.carousel.currentPhoto = photo
            self.updateCarouselOverlaysWith(photo)
        }
    }
    
    private func updateCarouselOverlaysWith(_ photo: STCarousel.Photo) {
        self.carousel.overlays.forEach { overlay in
            overlay.model.photoId = photo.id
            overlay.model.photoImage = photo.image
        }
    }
}

private extension Collection {
    subscript(optional i: Index) -> Iterator.Element? {
        return self.indices.contains(i) ? self[i] : nil
    }
}
