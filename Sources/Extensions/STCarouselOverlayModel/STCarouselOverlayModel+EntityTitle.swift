//
//  STCarouselOverlayModel+EntityTitle.swift
//  STPhotoMap-iOS
//
//  Created by Dimitri Strauneanu on 05/08/2019.
//  Copyright © 2019 mikelanza. All rights reserved.
//

import Foundation
import STPhotoCore

extension STCarouselOverlayModel {
    func entityTitle() -> String {
        let photoCountTitle = STPhotoMapLocalization.shared.photoCountTitle(self.photoCount)
        if self.type == EntityLevel.block.rawValue {
            return STPhotoMapLocalization.shared.carouselBlockEntityTitle(photoCountTitle: photoCountTitle)
        }
        return STPhotoMapLocalization.shared.carouselEntityTitle(photoCountTitle: photoCountTitle, entityName: self.name)
    }
}
