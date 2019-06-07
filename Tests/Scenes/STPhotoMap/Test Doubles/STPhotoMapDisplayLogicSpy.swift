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
    var displayRemoveLocationOverlayCalled: Bool = false
    var displayNavigateToSpecificPhotosCalled: Bool = false
    var displayZoomToCoordinateCalled: Bool = false
    var displaySelectPhotoAnnotationCalled: Bool = false
    var displayDeselectPhotoAnnotationCalled: Bool = false
    var displayDeselectPhotoClusterAnnotationCalled: Bool = false
    var displaySelectPhotoClusterAnnotationCalled: Bool = false
    var displayRemoveCarouselCalled: Bool = false
    var displayNavigateToPhotoCollectionCalled: Bool = false
    var displayNewCarouselCalled: Bool = false
    var displayReloadCarouselCalled: Bool = false
    var displayNewSelectedPhotoAnnotationCalled: Bool = false
    var displayCenterToCoordinateCalled: Bool = false
    var displayOpenDataSourcesLinkCalled: Bool = false
    var displayLocationAccessDeniedAlertCalled: Bool = false
    var displayOpenApplicationCalled: Bool = false
    
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
    
    func displayRemoveLocationOverlay() {
        self.displayRemoveLocationOverlayCalled = true
    }
    
    func displayNavigateToSpecificPhotos(viewModel: STPhotoMapModels.SpecificPhotosNavigation.ViewModel) {
        self.displayNavigateToSpecificPhotosCalled = true
    }
    
    func displayZoomToCoordinate(viewModel: STPhotoMapModels.CoordinateZoom.ViewModel) {
        self.displayZoomToCoordinateCalled = true
    }
    
    func displaySelectPhotoAnnotation(viewModel: STPhotoMapModels.PhotoAnnotationSelection.ViewModel) {
        self.displaySelectPhotoAnnotationCalled = true
    }
    
    func displayDeselectPhotoAnnotation(viewModel: STPhotoMapModels.PhotoAnnotationDeselection.ViewModel) {
        self.displayDeselectPhotoAnnotationCalled = true
    }
    
    func displayDeselectPhotoClusterAnnotation(viewModel: STPhotoMapModels.PhotoClusterAnnotationDeselection.ViewModel) {
        self.displayDeselectPhotoClusterAnnotationCalled = true
    }
    
    func displaySelectPhotoClusterAnnotation(viewModel: STPhotoMapModels.PhotoClusterAnnotationSelection.ViewModel) {
        self.displaySelectPhotoClusterAnnotationCalled = true
    }
    
    func displayRemoveCarousel() {
        self.displayRemoveCarouselCalled = true
    }
    
    func displayNavigateToPhotoCollection(viewModel: STPhotoMapModels.PhotoCollectionNavigation.ViewModel) {
        self.displayNavigateToPhotoCollectionCalled = true
    }
    
    func displayNewCarousel(viewModel: STPhotoMapModels.NewCarousel.ViewModel) {
        self.displayNewCarouselCalled = true
    }
    
    func displayReloadCarousel() {
        self.displayReloadCarouselCalled = true
    }
    
    func displayNewSelectedPhotoAnnotation(viewModel: STPhotoMapModels.PhotoAnnotationSelection.ViewModel) {
        self.displayNewSelectedPhotoAnnotationCalled = true
    }
    
    func displayCenterToCoordinate(viewModel: STPhotoMapModels.CoordinateCenter.ViewModel) {
        self.displayCenterToCoordinateCalled = true
    }
    
    func displayOpenDataSourcesLink(viewModel: STPhotoMapModels.OpenApplication.ViewModel) {
        self.displayOpenDataSourcesLinkCalled = true
    }
    
    func displayLocationAccessDeniedAlert(viewModel: STPhotoMapModels.LocationAccessDeniedAlert.ViewModel) {
        self.displayLocationAccessDeniedAlertCalled = true
    }
    
    func displayOpenApplication(viewModel: STPhotoMapModels.OpenApplication.ViewModel) {
        self.displayOpenApplicationCalled = true
    }
}
