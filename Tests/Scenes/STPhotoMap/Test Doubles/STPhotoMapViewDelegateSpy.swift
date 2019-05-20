//
//  STPhotoMapViewDelegateSpy.swift
//  STPhotoMapTests-iOS
//
//  Created by Dimitri Strauneanu on 18/05/2019.
//  Copyright © 2019 mikelanza. All rights reserved.
//

@testable import STPhotoMap

class STPhotoMapViewDelegateSpy: NSObject, STPhotoMapViewDelegate {
    var photoMapViewNavigateToPhotoDetailsForPhotoIdCalled: Bool = false
    
    func photoMapView(_ view: STPhotoMapView?, navigateToPhotoDetailsFor photoId: String?) {
        self.photoMapViewNavigateToPhotoDetailsForPhotoIdCalled = true
    }
}
