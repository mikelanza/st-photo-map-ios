//
//  GeoEntity+Carousel.swift
//  STPhotoMap-iOS
//
//  Created by Dimitri Strauneanu on 28/05/2019.
//  Copyright © 2019 mikelanza. All rights reserved.
//

import Foundation
import STPhotoCore

extension GeoEntity {
    func toCarousel() -> STCarousel {
        let carousel = STCarousel()
        carousel.entityId = self.id
        carousel.name = self.name ?? ""
        carousel.entityLevel = self.entityLevel
        carousel.photoCount = self.photoCount
        carousel.photos = self.photos
        carousel.currentPhoto = self.photos.map({ STCarousel.Photo(id: $0.id, image: nil) }).first
        carousel.downloadedPhotos = []
        carousel.overlays = self.carouselOverlays()
        carousel.titleLabel = self.carouselTitleLabel()
        return carousel
    }
    
    private func carouselTitleLabel() -> STCarousel.Label? {
        if let label = self.label {
            return STCarousel.Label(latitude: label.latitude, longitude: label.longitude, radius: label.radius)
        }
        return nil
    }
    
    private func carouselOverlays() -> [STCarouselOverlay] {
        if let object = self.geoJSONObject {
            return STCarouselOverlayGenerator().carouselOverlaysForGeoJSONObject(geoJSONObject: object)
        }
        return []
    }
}
