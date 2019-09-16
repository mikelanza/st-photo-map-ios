//
//  STPhotoMapInteractorTests+PhotoAnnotationSelection.swift
//  STPhotoMapTests-iOS
//
//  Created by Dimitri Strauneanu on 13/09/2019.
//  Copyright © 2019 Streetography. All rights reserved.
//

@testable import STPhotoMap
import XCTest
import MapKit
import STPhotoCore

class STPhotoMapInteractorPhotoAnnotationSelectionTests: XCTestCase {
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
    
    func testShouldSelectPhotoAnnotationShouldAskThePresenterToPresentNavigateToPhotoDetailsWhenThePhotoAnnotationIsSelected() {
        let photoAnnotation = STPhotoMapSeeds().photoAnnotation()
        photoAnnotation.isSelected = true
        self.sut.shouldSelectPhotoAnnotation(request: STPhotoMapModels.PhotoAnnotationSelection.Request(photoAnnotation: photoAnnotation, previousPhotoAnnotation: nil))
        XCTAssertTrue(self.presenterSpy.presentNavigateToPhotoDetailsCalled)
    }
    
    func testShouldSelectPhotoAnnotationShouldAskThePresenterToPresentDeselectPhotoClusterAnnotationWhenEntityLevelIsLocationAndThePhotoAnnotationIsNotSelected() {
        self.sut.entityLevelHandler.entityLevel = .location
        self.workerSpy.photo = STPhotoMapSeeds().photo()
        let photoAnnotation = STPhotoMapSeeds().photoAnnotation()
        photoAnnotation.isSelected = false
        self.sut.shouldSelectPhotoAnnotation(request: STPhotoMapModels.PhotoAnnotationSelection.Request(photoAnnotation: photoAnnotation, previousPhotoAnnotation: nil))
        XCTAssertTrue(self.presenterSpy.presentDeselectPhotoClusterAnnotationCalled)
    }
    
    func testShouldSelectPhotoAnnotationShouldAskThePresenterToPresentDeselectPhotoAnnotationWhenEntityLevelIsLocationAndThePhotoAnnotationIsNotSelected() {
        self.sut.entityLevelHandler.entityLevel = .location
        self.workerSpy.photo = STPhotoMapSeeds().photo()
        let photoAnnotation = STPhotoMapSeeds().photoAnnotation()
        photoAnnotation.isSelected = false
        self.sut.shouldSelectPhotoAnnotation(request: STPhotoMapModels.PhotoAnnotationSelection.Request(photoAnnotation: photoAnnotation, previousPhotoAnnotation: nil))
        XCTAssertTrue(self.presenterSpy.presentDeselectPhotoAnnotationCalled)
    }
    
    func testShouldSelectPhotoAnnotationShouldAskThePresenterToPresentSelectPhotoAnnotationWhenEntityLevelIsLocationAndThePhotoAnnotationIsNotSelected() {
        self.sut.entityLevelHandler.entityLevel = .location
        self.workerSpy.photo = STPhotoMapSeeds().photo()
        let photoAnnotation = STPhotoMapSeeds().photoAnnotation()
        photoAnnotation.isSelected = false
        self.sut.shouldSelectPhotoAnnotation(request: STPhotoMapModels.PhotoAnnotationSelection.Request(photoAnnotation: photoAnnotation, previousPhotoAnnotation: nil))
        XCTAssertTrue(self.presenterSpy.presentSelectPhotoAnnotationCalled)
    }
    
    func testShouldSelectPhotoAnnotationShouldAskThePresenterToPresentLoadingStateWhenEntityLevelIsLocationAndThePhotoAnnotationIsNotSelected() {
        self.sut.entityLevelHandler.entityLevel = .location
        self.workerSpy.photo = STPhotoMapSeeds().photo()
        let photoAnnotation = STPhotoMapSeeds().photoAnnotation()
        photoAnnotation.isSelected = false
        self.sut.shouldSelectPhotoAnnotation(request: STPhotoMapModels.PhotoAnnotationSelection.Request(photoAnnotation: photoAnnotation, previousPhotoAnnotation: nil))
        XCTAssertTrue(self.presenterSpy.presentLoadingStateCalled)
    }
    
    func testShouldSelectPhotoAnnotationShouldAskTheWorkerToGetPhotoDetailsForPhotoAnnotationWhenEntityLevelIsLocationAndThePhotoAnnotationIsNotSelected() {
        self.sut.entityLevelHandler.entityLevel = .location
        self.workerSpy.photo = STPhotoMapSeeds().photo()
        let photoAnnotation = STPhotoMapSeeds().photoAnnotation()
        photoAnnotation.isSelected = false
        self.sut.shouldSelectPhotoAnnotation(request: STPhotoMapModels.PhotoAnnotationSelection.Request(photoAnnotation: photoAnnotation, previousPhotoAnnotation: nil))
        XCTAssertTrue(self.workerSpy.getPhotoDetailsForPhotoAnnotationCalled)
    }
    
    func testSuccessDidGetPhotoForPhotoAnnotationShouldAskThePresenterToPresentNotLoadingState() {
        self.sut.successDidGetPhotoForPhotoAnnotation(photoAnnotation: STPhotoMapSeeds().photoAnnotation(), photo: STPhotoMapSeeds().photo())
        XCTAssertTrue(self.presenterSpy.presentNotLoadingStateCalled)
    }
    
    func testSuccessDidGetPhotoForPhotoAnnotationShouldAskThePresenterToPresentLocationOverlayWhenEntityLevelIsLocation() {
        self.sut.entityLevelHandler.entityLevel = .location
        self.sut.successDidGetPhotoForPhotoAnnotation(photoAnnotation: STPhotoMapSeeds().photoAnnotation(), photo: STPhotoMapSeeds().photo())
        XCTAssertTrue(self.presenterSpy.presentLocationOverlayCalled)
    }
    
    func testFailureDidGetPhotoForPhotoAnnotationShouldAskThePresenterToPresentNotLoadingState() {
        self.sut.failureDidGetPhotoForPhotoAnnotation(photoAnnotation: STPhotoMapSeeds().photoAnnotation(), error: OperationError.noDataAvailable)
        XCTAssertTrue(self.presenterSpy.presentNotLoadingStateCalled)
    }
}
