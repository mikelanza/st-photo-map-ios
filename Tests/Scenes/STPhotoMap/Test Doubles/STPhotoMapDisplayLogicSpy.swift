//
//  STPhotoMapDisplayLogicSpy.swift
//  STPhotoMapTests-iOS
//
//  Created by Dimitri Strauneanu on 10/05/2019.
//  Copyright © 2019 mikelanza. All rights reserved.
//

@testable import STPhotoMap

class STPhotoMapDisplayLogicSpy: STPhotoMapDisplayLogic {
    var displayLoadingStateCalled: Bool = false
    var displayNotLoadingStateCalled: Bool = false
    var displayEntityLevelCalled: Bool = false
    var displayLocationAnnotationsCalled: Bool = false
    var displayNavigateToPhotoDetailsCalled: Bool = false
    var displayRemoveLocationAnnotationsCalled: Bool = false
    var displayLocationOverlayCalled: Bool = false
    
    func displayLoadingState() {
        self.displayLoadingStateCalled = true
    }
    
    func displayNotLoadingState() {
        self.displayNotLoadingStateCalled = true
    }
    
    func displayEntityLevel(viewModel: STPhotoMapModels.EntityZoomLevel.ViewModel) {
        self.displayEntityLevelCalled = true
    }
    
    func displayLocationAnnotations(viewModel: STPhotoMapModels.LocationAnnotations.ViewModel) {
        self.displayLocationAnnotationsCalled = true
    }
    
    func displayNavigateToPhotoDetails(viewModel: STPhotoMapModels.PhotoDetailsNavigation.ViewModel) {
        self.displayNavigateToPhotoDetailsCalled = true
    }
    
    func displayRemoveLocationAnnotations() {
        self.displayRemoveLocationAnnotationsCalled = true
    }
    
    func displayLocationOverlay(viewModel: STPhotoMapModels.LocationOverlay.ViewModel) {
        self.displayLocationOverlayCalled = true
    }
}
