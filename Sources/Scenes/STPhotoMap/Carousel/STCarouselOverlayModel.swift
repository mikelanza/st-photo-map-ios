//
//  STCarouselOverlayModel.swift
//  STPhotoMap-iOS
//
//  Created by Dimitri Strauneanu on 23/05/2019.
//  Copyright © 2019 mikelanza. All rights reserved.
//

import UIKit

struct STCarouselOverlayModel {
    var photoId: String = ""
    var photoImage: UIImage?
    var photoCount: Int = 0
    
    var location: STLocation
    var radius: Double = 0
    
    var name: String = ""
    var type: String = ""
    
    var lineWidth: CGFloat
    var strokeColor: UIColor
    var fillColor: UIColor
    var alpha: CGFloat
    
    var tutorialText: String = ""
    
    var shouldDrawLabel: Bool = false
    var shouldDrawEntityButton: Bool = false
    var shouldDrawTutorialLabel: Bool = false
    
    init() {
        self.location = STLocation(latitude: 0, longitude: 0)
        self.lineWidth = 15.0
        self.strokeColor = UIColor(red: 73/255, green: 175/255, blue: 253/255, alpha: 1.0)
        self.fillColor = UIColor.black.withAlphaComponent(0.0)
        self.alpha = 1.0
    }
    
    func entityTitle() -> NSString {
        let photosTitle = "\(self.photoCount) Photos" // STPhotoMapLocalization.shared.photoCountString(count: numberOfPhotos)
        let preposition = self.type == EntityLevel.block.rawValue ? "on" : "in"
        let title: String
        if self.type != EntityLevel.block.rawValue {
            title = self.name
        } else {
            title = String(format: "this %@", self.type)
        }
        
        return NSString(format: "%@ %@\n%@", photosTitle, preposition, title)
    }
}
