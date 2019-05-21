//
//  STPhotoMapPresentationLogicSpy.swift
//  STPhotoMapTests-iOS
//
//  Created by Dimitri Strauneanu on 10/05/2019.
//  Copyright © 2019 mikelanza. All rights reserved.
//

@testable import STPhotoMap

class STPhotoMapPresentationLogicSpy: STPhotoMapPresentationLogic {
    var presentLoadingStateCalled: Bool = false
    var presentNotLoadingStateCalled: Bool = false
    var presentEntityLevelCalled: Bool = false
    var presentLocationAnnotationsCalled: Bool = false
    var presentNavigateToPhotoDetailsCalled: Bool = false
    var presentRemoveLocationAnnotationsCalled: Bool = false
    var presentLocationOverlayCalled: Bool = false
    var presentRemoveLocationOverlayCalled: Bool = false
    
    func presentLoadingState() {
        self.presentLoadingStateCalled = true
    }
    
    func presentNotLoadingState() {
        self.presentNotLoadingStateCalled = true
    }
    
    func presentEntityLevel(response: STPhotoMapModels.EntityZoomLevel.Response) {
        self.presentEntityLevelCalled = true
    }
    
    func presentLocationAnnotations(response: STPhotoMapModels.LocationAnnotations.Response) {
        self.presentLocationAnnotationsCalled = true
    }
    
    func presentNavigateToPhotoDetails(response: STPhotoMapModels.PhotoDetailsNavigation.Response) {
        self.presentNavigateToPhotoDetailsCalled = true
    }
    
    func presentRemoveLocationAnnotations() {
        self.presentRemoveLocationAnnotationsCalled = true
    }
    
    func presentLocationOverlay(response: STPhotoMapModels.LocationOverlay.Response) {
        self.presentLocationOverlayCalled = true
    }
    
    func presentRemoveLocationOverlay() {
        self.presentRemoveLocationOverlayCalled = true
    }
}
