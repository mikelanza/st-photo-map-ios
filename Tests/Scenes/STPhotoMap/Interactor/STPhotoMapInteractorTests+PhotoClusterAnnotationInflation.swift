//
//  STPhotoMapInteractorTests+PhotoClusterAnnotationInflation.swift
//  STPhotoMapTests-iOS
//
//  Created by Dimitri Strauneanu on 13/09/2019.
//  Copyright © 2019 Streetography. All rights reserved.
//

@testable import STPhotoMap
import XCTest
import MapKit
import STPhotoCore

class STPhotoMapInteractorPhotoClusterAnnotationInflationTests: XCTestCase {
    var sut: STPhotoMapInteractor!
    var presenterSpy: STPhotoMapPresentationLogicSpy!
    var workerSpy: STPhotoMapWorkerSpy!
    
    // MARK: - Test lifecycle
    
    override func setUp() {
        super.setUp()
        self.setupSTPhotoMapInteractor()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    // MARK: - Test setup
    
    func setupSTPhotoMapInteractor() {
        self.sut = STPhotoMapInteractor()
        
        self.presenterSpy = STPhotoMapPresentationLogicSpy()
        self.sut.presenter = self.presenterSpy
        
        self.workerSpy = STPhotoMapWorkerSpy(delegate: self.sut)
        self.sut.worker = self.workerSpy
    }
    
    // MARK: - Tests
    
    func testShouldInflatePhotoClusterAnnotationShouldAskThePresenterToPresentNavigateToSpecificPhotosWhenZoomLevelIsMaximumAndThereAreOver15ClusterPhotos() {
        let zoomLevel = 20
        
        let clusterAnnotation = STPhotoMapSeeds().multiplePhotoClusterAnnotation(count: 20)
        let previousClusterAnnotation = STPhotoMapSeeds().multiplePhotoClusterAnnotation(count: 5)
        
        let request = STPhotoMapModels.PhotoClusterAnnotationInflation.Request(clusterAnnotation: clusterAnnotation, previousClusterAnnotation: previousClusterAnnotation, zoomLevel: zoomLevel)
        self.sut.shouldInflatePhotoClusterAnnotation(request: request)
        
        XCTAssertTrue(self.presenterSpy.presentNavigateToSpecificPhotosCalled)
    }
    
    func testShouldInflatePhotoClusterAnnotationShouldAskThePresenterToPresentZoomToCoordinateWhenZoomLevelIsNotMaximumAndClusterPhotosWithDifferentLocation() {
        let zoomLevel = 17
        
        let clusterAnnotation = STPhotoMapSeeds().multiplePhotoClusterAnnotation(count: 10, sameCoordinate: false)
        let previousClusterAnnotation = STPhotoMapSeeds().multiplePhotoClusterAnnotation(count: 5)
        
        let request = STPhotoMapModels.PhotoClusterAnnotationInflation.Request(clusterAnnotation: clusterAnnotation, previousClusterAnnotation: previousClusterAnnotation, zoomLevel: zoomLevel)
        self.sut.shouldInflatePhotoClusterAnnotation(request: request)
        
        XCTAssertTrue(self.presenterSpy.presentZoomToCoordinateCalled)
    }
    
    func testShouldInflatePhotoClusterAnnotationShouldDeflatePreviousClusterAnnotationWhenZoomLevelIsMaximumAndThereAreUnder15ClusterPhotosWithTheSameLocation() {
        self.sut.worker = nil
        let zoomLevel = 20
        
        let clusterAnnotationInterfaceSpy = MultiplePhotoClusterAnnotationInterfaceSpy()
        let clusterAnnotation = STPhotoMapSeeds().multiplePhotoClusterAnnotation(count: 10)
        clusterAnnotation.interface = clusterAnnotationInterfaceSpy
        
        let previousClusterAnnotationInterfaceSpy = MultiplePhotoClusterAnnotationInterfaceSpy()
        let previousClusterAnnotation = STPhotoMapSeeds().multiplePhotoClusterAnnotation(count: 5)
        previousClusterAnnotation.interface = previousClusterAnnotationInterfaceSpy
        
        let request = STPhotoMapModels.PhotoClusterAnnotationInflation.Request(clusterAnnotation: clusterAnnotation, previousClusterAnnotation: previousClusterAnnotation, zoomLevel: zoomLevel)
        self.sut.shouldInflatePhotoClusterAnnotation(request: request)
        XCTAssertTrue(previousClusterAnnotationInterfaceSpy.deflateCalled)
    }
    
    func testShouldInflatePhotoClusterAnnotationShouldInflateClusterAnnotationWhenZoomLevelIsMaximumAndThereAreUnder15ClusterPhotosWithTheSameLocation() {
        self.sut.worker = nil
        let zoomLevel = 20
        
        let clusterAnnotationInterfaceSpy = MultiplePhotoClusterAnnotationInterfaceSpy()
        let clusterAnnotation = STPhotoMapSeeds().multiplePhotoClusterAnnotation(count: 10)
        clusterAnnotation.interface = clusterAnnotationInterfaceSpy
        
        let previousClusterAnnotationInterfaceSpy = MultiplePhotoClusterAnnotationInterfaceSpy()
        let previousClusterAnnotation = STPhotoMapSeeds().multiplePhotoClusterAnnotation(count: 5)
        previousClusterAnnotation.interface = previousClusterAnnotationInterfaceSpy
        
        let request = STPhotoMapModels.PhotoClusterAnnotationInflation.Request(clusterAnnotation: clusterAnnotation, previousClusterAnnotation: previousClusterAnnotation, zoomLevel: zoomLevel)
        self.sut.shouldInflatePhotoClusterAnnotation(request: request)
        XCTAssertTrue(clusterAnnotationInterfaceSpy.inflateCalled)
    }
    
    func testShouldInflatePhotoClusterAnnotationShouldAskTheWorkerToGetImageForPhotoAnnotationWhenZoomLevelIsMaximumAndThereAreUnder15ClusterPhotosWithTheSameLocation() {
        let zoomLevel = 20
        
        let clusterAnnotationInterfaceSpy = MultiplePhotoClusterAnnotationInterfaceSpy()
        let clusterAnnotation = STPhotoMapSeeds().multiplePhotoClusterAnnotation(count: 10)
        clusterAnnotation.interface = clusterAnnotationInterfaceSpy
        
        let previousClusterAnnotationInterfaceSpy = MultiplePhotoClusterAnnotationInterfaceSpy()
        let previousClusterAnnotation = STPhotoMapSeeds().multiplePhotoClusterAnnotation(count: 5)
        previousClusterAnnotation.interface = previousClusterAnnotationInterfaceSpy
        
        let request = STPhotoMapModels.PhotoClusterAnnotationInflation.Request(clusterAnnotation: clusterAnnotation, previousClusterAnnotation: previousClusterAnnotation, zoomLevel: zoomLevel)
        self.sut.shouldInflatePhotoClusterAnnotation(request: request)
        
        XCTAssertTrue(self.workerSpy.getImageForPhotoAnnotationCalled)
    }
    
    func testShouldInflatePhotoClusterAnnotationShouldUpdateClusterAnnotationModelsBeforeGettingImagesWhenZoomLevelIsMaximumAndThereAreUnder15ClusterPhotosWithTheSameLocation() {
        self.sut.worker = nil
        let zoomLevel = 20
        
        let clusterAnnotationInterfaceSpy = MultiplePhotoClusterAnnotationInterfaceSpy()
        let clusterAnnotation = STPhotoMapSeeds().multiplePhotoClusterAnnotation(count: 10)
        clusterAnnotation.interface = clusterAnnotationInterfaceSpy
        
        let previousClusterAnnotationInterfaceSpy = MultiplePhotoClusterAnnotationInterfaceSpy()
        let previousClusterAnnotation = STPhotoMapSeeds().multiplePhotoClusterAnnotation(count: 5)
        previousClusterAnnotation.interface = previousClusterAnnotationInterfaceSpy
        
        let request = STPhotoMapModels.PhotoClusterAnnotationInflation.Request(clusterAnnotation: clusterAnnotation, previousClusterAnnotation: previousClusterAnnotation, zoomLevel: zoomLevel)
        self.sut.shouldInflatePhotoClusterAnnotation(request: request)
        
        XCTAssertTrue(clusterAnnotationInterfaceSpy.setIsLoadingCalled)
        clusterAnnotation.multipleAnnotationModels.forEach { (key, value) in
            XCTAssertTrue(value.isLoading)
            XCTAssertNil(value.image)
        }
    }
    
    func testShouldInflatePhotoClusterAnnotationShouldUpdateClusterAnnotationModelsAfterGettingImagesWhenZoomLevelIsMaximumAndThereAreUnder15ClusterPhotosWithTheSameLocation() {
        self.workerSpy.image = UIImage()
        let zoomLevel = 20
        
        let clusterAnnotationInterfaceSpy = MultiplePhotoClusterAnnotationInterfaceSpy()
        let clusterAnnotation = STPhotoMapSeeds().multiplePhotoClusterAnnotation(count: 10)
        clusterAnnotation.interface = clusterAnnotationInterfaceSpy
        
        let previousClusterAnnotationInterfaceSpy = MultiplePhotoClusterAnnotationInterfaceSpy()
        let previousClusterAnnotation = STPhotoMapSeeds().multiplePhotoClusterAnnotation(count: 5)
        previousClusterAnnotation.interface = previousClusterAnnotationInterfaceSpy
        
        let request = STPhotoMapModels.PhotoClusterAnnotationInflation.Request(clusterAnnotation: clusterAnnotation, previousClusterAnnotation: previousClusterAnnotation, zoomLevel: zoomLevel)
        self.sut.shouldInflatePhotoClusterAnnotation(request: request)
        
        XCTAssertTrue(clusterAnnotationInterfaceSpy.setIsLoadingCalled)
        clusterAnnotation.multipleAnnotationModels.forEach { (key, value) in
            XCTAssertFalse(value.isLoading)
            XCTAssertNotNil(value.image)
        }
    }
    
    func testShouldInflatePhotoClusterAnnotationShouldDeflatePreviousClusterAnnotationWhenZoomLevelIsNotMaximumAndThereAreUnder15ClusterPhotosWithTheSameLocation() {
        self.sut.worker = nil
        let zoomLevel = 17
        
        let clusterAnnotationInterfaceSpy = MultiplePhotoClusterAnnotationInterfaceSpy()
        let clusterAnnotation = STPhotoMapSeeds().multiplePhotoClusterAnnotation(count: 10)
        clusterAnnotation.interface = clusterAnnotationInterfaceSpy
        
        let previousClusterAnnotationInterfaceSpy = MultiplePhotoClusterAnnotationInterfaceSpy()
        let previousClusterAnnotation = STPhotoMapSeeds().multiplePhotoClusterAnnotation(count: 5)
        previousClusterAnnotation.interface = previousClusterAnnotationInterfaceSpy
        
        let request = STPhotoMapModels.PhotoClusterAnnotationInflation.Request(clusterAnnotation: clusterAnnotation, previousClusterAnnotation: previousClusterAnnotation, zoomLevel: zoomLevel)
        self.sut.shouldInflatePhotoClusterAnnotation(request: request)
        XCTAssertTrue(previousClusterAnnotationInterfaceSpy.deflateCalled)
    }
    
    func testShouldInflatePhotoClusterAnnotationShouldInflateClusterAnnotationWhenZoomLevelIsNotMaximumAndThereAreUnder15ClusterPhotosWithTheSameLocation() {
        self.sut.worker = nil
        let zoomLevel = 17
        
        let clusterAnnotationInterfaceSpy = MultiplePhotoClusterAnnotationInterfaceSpy()
        let clusterAnnotation = STPhotoMapSeeds().multiplePhotoClusterAnnotation(count: 10)
        clusterAnnotation.interface = clusterAnnotationInterfaceSpy
        
        let previousClusterAnnotationInterfaceSpy = MultiplePhotoClusterAnnotationInterfaceSpy()
        let previousClusterAnnotation = STPhotoMapSeeds().multiplePhotoClusterAnnotation(count: 5)
        previousClusterAnnotation.interface = previousClusterAnnotationInterfaceSpy
        
        let request = STPhotoMapModels.PhotoClusterAnnotationInflation.Request(clusterAnnotation: clusterAnnotation, previousClusterAnnotation: previousClusterAnnotation, zoomLevel: zoomLevel)
        self.sut.shouldInflatePhotoClusterAnnotation(request: request)
        XCTAssertTrue(clusterAnnotationInterfaceSpy.inflateCalled)
    }
    
    func testShouldInflatePhotoClusterAnnotationShouldAskTheWorkerToGetImageForPhotoAnnotationWhenZoomLevelIsNotMaximumAndThereAreUnder15ClusterPhotosWithTheSameLocation() {
        let zoomLevel = 17
        
        let clusterAnnotationInterfaceSpy = MultiplePhotoClusterAnnotationInterfaceSpy()
        let clusterAnnotation = STPhotoMapSeeds().multiplePhotoClusterAnnotation(count: 10)
        clusterAnnotation.interface = clusterAnnotationInterfaceSpy
        
        let previousClusterAnnotationInterfaceSpy = MultiplePhotoClusterAnnotationInterfaceSpy()
        let previousClusterAnnotation = STPhotoMapSeeds().multiplePhotoClusterAnnotation(count: 5)
        previousClusterAnnotation.interface = previousClusterAnnotationInterfaceSpy
        
        let request = STPhotoMapModels.PhotoClusterAnnotationInflation.Request(clusterAnnotation: clusterAnnotation, previousClusterAnnotation: previousClusterAnnotation, zoomLevel: zoomLevel)
        self.sut.shouldInflatePhotoClusterAnnotation(request: request)
        
        XCTAssertTrue(self.workerSpy.getImageForPhotoAnnotationCalled)
    }
    
    func testShouldInflatePhotoClusterAnnotationShouldUpdateClusterAnnotationModelsBeforeGettingImagesWhenZoomLevelIsNotMaximumAndThereAreUnder15ClusterPhotosWithTheSameLocation() {
        self.sut.worker = nil
        let zoomLevel = 17
        
        let clusterAnnotationInterfaceSpy = MultiplePhotoClusterAnnotationInterfaceSpy()
        let clusterAnnotation = STPhotoMapSeeds().multiplePhotoClusterAnnotation(count: 10)
        clusterAnnotation.interface = clusterAnnotationInterfaceSpy
        
        let previousClusterAnnotationInterfaceSpy = MultiplePhotoClusterAnnotationInterfaceSpy()
        let previousClusterAnnotation = STPhotoMapSeeds().multiplePhotoClusterAnnotation(count: 5)
        previousClusterAnnotation.interface = previousClusterAnnotationInterfaceSpy
        
        let request = STPhotoMapModels.PhotoClusterAnnotationInflation.Request(clusterAnnotation: clusterAnnotation, previousClusterAnnotation: previousClusterAnnotation, zoomLevel: zoomLevel)
        self.sut.shouldInflatePhotoClusterAnnotation(request: request)
        
        XCTAssertTrue(clusterAnnotationInterfaceSpy.setIsLoadingCalled)
        clusterAnnotation.multipleAnnotationModels.forEach { (key, value) in
            XCTAssertTrue(value.isLoading)
            XCTAssertNil(value.image)
        }
    }
    
    func testShouldInflatePhotoClusterAnnotationShouldUpdateClusterAnnotationModelsAfterGettingImagesWhenZoomLevelIsNotMaximumAndThereAreUnder15ClusterPhotosWithTheSameLocation() {
        self.workerSpy.image = UIImage()
        let zoomLevel = 17
        
        let clusterAnnotationInterfaceSpy = MultiplePhotoClusterAnnotationInterfaceSpy()
        let clusterAnnotation = STPhotoMapSeeds().multiplePhotoClusterAnnotation(count: 10)
        clusterAnnotation.interface = clusterAnnotationInterfaceSpy
        
        let previousClusterAnnotationInterfaceSpy = MultiplePhotoClusterAnnotationInterfaceSpy()
        let previousClusterAnnotation = STPhotoMapSeeds().multiplePhotoClusterAnnotation(count: 5)
        previousClusterAnnotation.interface = previousClusterAnnotationInterfaceSpy
        
        let request = STPhotoMapModels.PhotoClusterAnnotationInflation.Request(clusterAnnotation: clusterAnnotation, previousClusterAnnotation: previousClusterAnnotation, zoomLevel: zoomLevel)
        self.sut.shouldInflatePhotoClusterAnnotation(request: request)
        
        XCTAssertTrue(clusterAnnotationInterfaceSpy.setIsLoadingCalled)
        clusterAnnotation.multipleAnnotationModels.forEach { (key, value) in
            XCTAssertFalse(value.isLoading)
            XCTAssertNotNil(value.image)
        }
    }
}
