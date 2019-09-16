//
//  STPhotoMapInteractorTests+PhotoClusterAnnotationSelection.swift
//  STPhotoMapTests-iOS
//
//  Created by Dimitri Strauneanu on 13/09/2019.
//  Copyright © 2019 Streetography. All rights reserved.
//

@testable import STPhotoMap
import XCTest
import MapKit
import STPhotoCore

class STPhotoMapInteractorPhotoClusterAnnotationSelectionTests: XCTestCase {
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
    
    func testShouldSelectPhotoClusterAnnotationShouldAskThePresenterToPresentNavigateToPhotoDetailsWhenTheAnnotationIsSelected() {
        let clusterAnnotation = STPhotoMapSeeds().multiplePhotoClusterAnnotation(count: 10)
        let annotations = STPhotoMapSeeds().photoAnnotations()
        let annotation = annotations.first!
        annotation.isSelected = true
        
        let previousAnnotation = annotations.last!
        
        let request = STPhotoMapModels.PhotoClusterAnnotationSelection.Request(clusterAnnotation: clusterAnnotation, photoAnnotation: annotation, previousPhotoAnnotation: previousAnnotation)
        self.sut.shouldSelectPhotoClusterAnnotation(request: request)
        
        XCTAssertTrue(self.presenterSpy.presentNavigateToPhotoDetailsCalled)
    }
    
    func testShouldSelectPhotoClusterAnnotationShouldAskThePresenterToPresentDeselectPhotoClusterAnnotationWhenTheAnnotationIsNotSelectedAndEntityLevelIsLocation() {
        self.sut.entityLevelHandler.entityLevel = .location
        self.workerSpy.photo = STPhotoMapSeeds().photo()
        
        let clusterAnnotation = STPhotoMapSeeds().multiplePhotoClusterAnnotation(count: 10)
        let annotations = STPhotoMapSeeds().photoAnnotations()
        let annotation = annotations.first!
        annotation.isSelected = false
        
        let previousAnnotation = annotations.last!
        
        let request = STPhotoMapModels.PhotoClusterAnnotationSelection.Request(clusterAnnotation: clusterAnnotation, photoAnnotation: annotation, previousPhotoAnnotation: previousAnnotation)
        self.sut.shouldSelectPhotoClusterAnnotation(request: request)
        
        XCTAssertTrue(self.presenterSpy.presentDeselectPhotoClusterAnnotationCalled)
    }
    
    func testShouldSelectPhotoClusterAnnotationShouldAskThePresenterToPresentDeselectPhotoAnnotationWhenTheAnnotationIsNotSelectedAndEntityLevelIsLocation() {
        self.sut.entityLevelHandler.entityLevel = .location
        self.workerSpy.photo = STPhotoMapSeeds().photo()
        
        let clusterAnnotation = STPhotoMapSeeds().multiplePhotoClusterAnnotation(count: 10)
        let annotations = STPhotoMapSeeds().photoAnnotations()
        let annotation = annotations.first!
        annotation.isSelected = false
        
        let previousAnnotation = annotations.last!
        
        let request = STPhotoMapModels.PhotoClusterAnnotationSelection.Request(clusterAnnotation: clusterAnnotation, photoAnnotation: annotation, previousPhotoAnnotation: previousAnnotation)
        self.sut.shouldSelectPhotoClusterAnnotation(request: request)
        
        XCTAssertTrue(self.presenterSpy.presentDeselectPhotoAnnotationCalled)
    }
    
    func testShouldSelectPhotoClusterAnnotationShouldAskThePresenterToPresentSelectPhotoAnnotationWhenTheAnnotationIsNotSelectedAndEntityLevelIsLocation() {
        self.sut.entityLevelHandler.entityLevel = .location
        self.workerSpy.photo = STPhotoMapSeeds().photo()
        
        let clusterAnnotation = STPhotoMapSeeds().multiplePhotoClusterAnnotation(count: 10)
        let annotations = STPhotoMapSeeds().photoAnnotations()
        let annotation = annotations.first!
        annotation.isSelected = false
        
        let previousAnnotation = annotations.last!
        
        let request = STPhotoMapModels.PhotoClusterAnnotationSelection.Request(clusterAnnotation: clusterAnnotation, photoAnnotation: annotation, previousPhotoAnnotation: previousAnnotation)
        self.sut.shouldSelectPhotoClusterAnnotation(request: request)
        
        XCTAssertTrue(self.presenterSpy.presentSelectPhotoAnnotationCalled)
    }
    
    func testShouldSelectPhotoClusterAnnotationShouldAskThePresenterToPresentSelectPhotoClusterAnnotationWhenTheAnnotationIsNotSelectedAndEntityLevelIsLocation() {
        self.sut.entityLevelHandler.entityLevel = .location
        self.workerSpy.photo = STPhotoMapSeeds().photo()
        
        let clusterAnnotation = STPhotoMapSeeds().multiplePhotoClusterAnnotation(count: 10)
        let annotations = STPhotoMapSeeds().photoAnnotations()
        let annotation = annotations.first!
        annotation.isSelected = false
        
        let previousAnnotation = annotations.last!
        
        let request = STPhotoMapModels.PhotoClusterAnnotationSelection.Request(clusterAnnotation: clusterAnnotation, photoAnnotation: annotation, previousPhotoAnnotation: previousAnnotation)
        self.sut.shouldSelectPhotoClusterAnnotation(request: request)
        
        XCTAssertTrue(self.presenterSpy.presentSelectPhotoClusterAnnotationCalled)
    }
    
    func testShouldSelectPhotoClusterAnnotationShouldAskThePresenterToPresentLoadingStateWhenTheAnnotationIsNotSelectedAndEntityLevelIsLocation() {
        self.sut.entityLevelHandler.entityLevel = .location
        self.workerSpy.photo = STPhotoMapSeeds().photo()
        
        let clusterAnnotation = STPhotoMapSeeds().multiplePhotoClusterAnnotation(count: 10)
        let annotations = STPhotoMapSeeds().photoAnnotations()
        let annotation = annotations.first!
        annotation.isSelected = false
        
        let previousAnnotation = annotations.last!
        
        let request = STPhotoMapModels.PhotoClusterAnnotationSelection.Request(clusterAnnotation: clusterAnnotation, photoAnnotation: annotation, previousPhotoAnnotation: previousAnnotation)
        self.sut.shouldSelectPhotoClusterAnnotation(request: request)
        
        XCTAssertTrue(self.presenterSpy.presentLoadingStateCalled)
    }
    
    func testShouldSelectPhotoClusterAnnotationShouldAskTheWorkerToGetPhotoDetailsForPhotoAnnotationWhenTheAnnotationIsNotSelectedAndEntityLevelIsLocation() {
        self.sut.entityLevelHandler.entityLevel = .location
        self.workerSpy.photo = STPhotoMapSeeds().photo()
        
        let clusterAnnotation = STPhotoMapSeeds().multiplePhotoClusterAnnotation(count: 10)
        let annotations = STPhotoMapSeeds().photoAnnotations()
        let annotation = annotations.first!
        annotation.isSelected = false
        
        let previousAnnotation = annotations.last!
        
        let request = STPhotoMapModels.PhotoClusterAnnotationSelection.Request(clusterAnnotation: clusterAnnotation, photoAnnotation: annotation, previousPhotoAnnotation: previousAnnotation)
        self.sut.shouldSelectPhotoClusterAnnotation(request: request)
        
        XCTAssertTrue(self.workerSpy.getPhotoDetailsForPhotoAnnotationCalled)
    }
}
