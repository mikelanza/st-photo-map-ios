//
//  STPhotoMapViewDelegateSpy.swift
//  STPhotoMapTests-iOS
//
//  Created by Dimitri Strauneanu on 18/05/2019.
//  Copyright © 2019 Streetography. All rights reserved.
//

@testable import STPhotoMap
import STPhotoCore

class STPhotoMapViewDelegateSpy: NSObject, STPhotoMapViewDelegate {
    var photoMapViewNavigateToPhotoDetailsForPhotoIdCalled: Bool = false
    var photoMapViewNavigateToSpecificPhotosForPhotoIdsCalled: Bool = false
    var photoMapViewNavigateToPhotoCollectionForLocationEntityLevelCalled: Bool = false
    
    func photoMapView(_ view: STPhotoMapView?, navigateToPhotoDetailsFor photoId: String?) {
        self.photoMapViewNavigateToPhotoDetailsForPhotoIdCalled = true
    }
    
    func photoMapView(_ view: STPhotoMapView?, navigateToSpecificPhotosFor photoIds: [String]) {
        self.photoMapViewNavigateToSpecificPhotosForPhotoIdsCalled = true
    }
    
    func photoMapView(_ view: STPhotoMapView?, navigateToPhotoCollectionFor location: STLocation, entityLevel: EntityLevel) {
        self.photoMapViewNavigateToPhotoCollectionForLocationEntityLevelCalled = true
    }
}
