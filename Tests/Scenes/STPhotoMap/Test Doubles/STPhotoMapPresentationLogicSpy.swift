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
    var presentNavigateToSpecificPhotosCalled: Bool = false
    var presentZoomToCoordinateCalled: Bool = false
    var presentSelectPhotoAnnotationCalled: Bool = false
    var presentDeselectPhotoAnnotationCalled: Bool = false
    var presentDeselectPhotoClusterAnnotationCalled: Bool = false
    var presentSelectPhotoClusterAnnotationCalled: Bool = false
    var presentRemoveCarouselCalled: Bool = false
    
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
    
    func presentNavigateToSpecificPhotos(response: STPhotoMapModels.SpecificPhotosNavigation.Response) {
        self.presentNavigateToSpecificPhotosCalled = true
    }
    
    func presentZoomToCoordinate(response: STPhotoMapModels.CoordinateZoom.Response) {
        self.presentZoomToCoordinateCalled = true
    }
    
    func presentSelectPhotoAnnotation(response: STPhotoMapModels.PhotoAnnotationSelection.Response) {
        self.presentSelectPhotoAnnotationCalled = true
    }
    
    func presentDeselectPhotoAnnotation(response: STPhotoMapModels.PhotoAnnotationDeselection.Response) {
        self.presentDeselectPhotoAnnotationCalled = true
    }
    
    func presentDeselectPhotoClusterAnnotation(response: STPhotoMapModels.PhotoClusterAnnotationDeselection.Response) {
        self.presentDeselectPhotoClusterAnnotationCalled = true
    }
    
    func presentSelectPhotoClusterAnnotation(response: STPhotoMapModels.PhotoClusterAnnotationSelection.Response) {
        self.presentSelectPhotoClusterAnnotationCalled = true
    }
    
    func presentRemoveCarousel() {
        self.presentRemoveCarouselCalled = true
    }
}
