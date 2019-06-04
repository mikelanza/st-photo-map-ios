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
        
        func location() -> STLocation {
            return STLocation(latitude: self.latitude, longitude: self.longitude)
        }
    }
    
    var entityId: Int = -1
    var name: String = ""
    var overlays: [STCarouselOverlay] = []
    var photoCount: Int = 0
    var titleLabel: Label?
    var entityLevel: EntityLevel = .unknown
    
    var shouldDrawTutorialLabel: Bool = false
    var numberOfTutorialTextUpdates: Int = 1
    
    var photos: [STPhoto] = []
    var downloadedPhotos: [Photo] = []
    var currentPhoto: Photo?
    
    init() {
        
    }
}
