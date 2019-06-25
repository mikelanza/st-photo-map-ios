//
//  STPhotoMapBusinessLogicSpy.swift
//  STPhotoMapTests-iOS
//
//  Created by Dimitri Strauneanu on 10/05/2019.
//  Copyright © 2019 mikelanza. All rights reserved.
//

@testable import STPhotoMap

class STPhotoMapBusinessLogicSpy: STPhotoMapBusinessLogic {
    var shouldUpdateVisibleTilesCalled: Bool = false
    var shouldUpdateVisibleMapRect: Bool = false
    var shouldCacheGeojsonObjectsCalled: Bool = false
    var shouldDetermineEntityLevelCalled: Bool = false
    var shouldDetermineLocationLevelCalled: Bool = false
    var shouldDownloadImageForPhotoAnnotationCalled: Bool = false
    var shouldSelectPhotoAnnotationCalled: Bool = false
    var shouldNavigateToPhotoDetailsCalled: Bool = false
    var shouldInflatePhotoClusterAnnotationCalled: Bool = false
    var shouldSelectPhotoClusterAnnotationCalled: Bool = false
    var shouldNavigateToPhotoCollectionCalled: Bool = false
    var shouldSelectCarouselCalled: Bool = false
    var shouldDetermineCarouselCalled: Bool = false
    var shouldUpdateSelectedPhotoAnnotationCalled: Bool = false
    var shouldDetermineSelectedPhotoAnnotationCalled: Bool = false
    var shouldAskForLocationPermissionsCalled: Bool = false
    var shouldOpenDataSourcesLinkCalled: Bool = false
    var shouldOpenSettingsApplicationCalled: Bool = false
    var shouldReloadCarouselCalled: Bool = false

    func shouldUpdateVisibleTiles(request: STPhotoMapModels.VisibleTiles.Request) {
        self.shouldUpdateVisibleTilesCalled = true
    }
    
    func shouldUpdateVisibleMapRect(request: STPhotoMapModels.VisibleMapRect.Request) {
        self.shouldUpdateVisibleMapRect = true
    }
    
    func shouldCacheGeojsonObjects() {
        self.shouldCacheGeojsonObjectsCalled = true
    }
    
    func shouldDetermineEntityLevel() {
        self.shouldDetermineEntityLevelCalled = true
    }
    
    func shouldDownloadImageForPhotoAnnotation(request: STPhotoMapModels.PhotoAnnotationImageDownload.Request) {
        self.shouldDownloadImageForPhotoAnnotationCalled = true
    }
    
    func shouldDetermineLocationLevel() {
        self.shouldDetermineLocationLevelCalled = true
    }
    
    func shouldSelectPhotoAnnotation(request: STPhotoMapModels.PhotoAnnotationSelection.Request) {
        self.shouldSelectPhotoAnnotationCalled = true
    }
    
    func shouldNavigateToPhotoDetails(request: STPhotoMapModels.PhotoDetailsNavigation.Request) {
        self.shouldNavigateToPhotoDetailsCalled = true
    }
    
    func shouldInflatePhotoClusterAnnotation(request: STPhotoMapModels.PhotoClusterAnnotationInflation.Request) {
        self.shouldInflatePhotoClusterAnnotationCalled = true
    }
    
    func shouldSelectPhotoClusterAnnotation(request: STPhotoMapModels.PhotoClusterAnnotationSelection.Request) {
        self.shouldSelectPhotoClusterAnnotationCalled = true
    }
    
    func shouldNavigateToPhotoCollection(request: STPhotoMapModels.PhotoCollectionNavigation.Request) {
        self.shouldNavigateToPhotoCollectionCalled = true
    }
    
    func shouldSelectCarousel(request: STPhotoMapModels.CarouselSelection.Request) {
        self.shouldSelectCarouselCalled = true
    }
    
    func shouldDetermineCarousel() {
        self.shouldDetermineCarouselCalled = true
    }
    
    func shouldUpdateSelectedPhotoAnnotation(request: STPhotoMapModels.SelectedPhotoAnnotation.Request) {
        self.shouldUpdateSelectedPhotoAnnotationCalled = true
    }
    
    func shouldDetermineSelectedPhotoAnnotation() {
        self.shouldDetermineSelectedPhotoAnnotationCalled = true
    }
    
    func shouldAskForLocationPermissions() {
        self.shouldAskForLocationPermissionsCalled = true
    }
    
    func shouldOpenDataSourcesLink() {
        self.shouldOpenDataSourcesLinkCalled = true
    }
    
    func shouldOpenSettingsApplication() {
        self.shouldOpenSettingsApplicationCalled = true
    }
    
    func shouldReloadCarousel() {
        self.shouldReloadCarouselCalled = true
    }
}
