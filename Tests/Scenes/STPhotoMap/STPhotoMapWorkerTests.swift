//
//  STPhotoMapWorkerTests.swift
//  STPhotoMap
//
//  Created by Dimitri Strauneanu on 12/04/2019.
//  Copyright (c) 2019 Streetography. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

@testable import STPhotoMap
import XCTest
import STPhotoCore

class STPhotoMapWorkerTests: XCTestCase {
    // MARK: Subject under test
    
    var sut: STPhotoMapWorker!
    
    // MARK: Test lifecycle
    
    override func setUp() {
        super.setUp()
        self.setupSTPhotoMapWorker()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    // MARK: Test setup
    
    func setupSTPhotoMapWorker() {
        self.sut = STPhotoMapWorker()
    }
    
    // MARK: Tests
    
    func testGetGeojsonTileForCaching() {
        self.sut.getGeojsonTileForCaching(tileCoordinate: STPhotoMapSeeds.tileCoordinate, keyUrl: STPhotoMapSeeds.imageUrl, downloadUrl: STPhotoMapSeeds.imageUrl)
        XCTAssertEqual(self.sut.geojsonTileCachingQueue.operationCount, 1)
    }
    
    func testGetGeojsonEntityLevel() {
        self.sut.getGeojsonEntityLevel(tileCoordinate: STPhotoMapSeeds.tileCoordinate, keyUrl: STPhotoMapSeeds.imageUrl, downloadUrl: STPhotoMapSeeds.imageUrl)
        XCTAssertEqual(self.sut.geojsonEntityLevelQueue.operationCount, 1)
    }
    
    func testCancelAllGeojsonEntityLevelOperations() {
        let operationQueueSpy = OperationQueueSpy()
        self.sut.geojsonEntityLevelQueue = operationQueueSpy
        
        self.sut.cancelAllGeojsonEntityLevelOperations()
        XCTAssertTrue(operationQueueSpy.cancelAllOperationsCalled)
    }
    
    func testGetGeojsonLocationLevel() {
        self.sut.getGeojsonLocationLevel(tileCoordinate: STPhotoMapSeeds.tileCoordinate, keyUrl: STPhotoMapSeeds.imageUrl, downloadUrl: STPhotoMapSeeds.imageUrl)
        XCTAssertEqual(self.sut.geojsonLocationLevelQueue.operationCount, 1)
    }
    
    func testCancelAllGeojsonLocationLevelOperations() {
        let operationQueueSpy = OperationQueueSpy()
        self.sut.geojsonLocationLevelQueue = operationQueueSpy
        
        self.sut.cancelAllGeojsonLocationLevelOperations()
        XCTAssertTrue(operationQueueSpy.cancelAllOperationsCalled)
    }
    
    func testGetGeojsonTileForCarouselSelection() {
        self.sut.getGeojsonTileForCarouselSelection(tileCoordinate: STPhotoMapSeeds.tileCoordinate, location: STPhotoMapSeeds.location, keyUrl: STPhotoMapSeeds.imageUrl, downloadUrl: STPhotoMapSeeds.imageUrl)
        XCTAssertEqual(self.sut.geojsonTileCarouselSelectionQueue.operationCount, 1)
    }
    
    func testCancelAllGeojsonCarouselSelectionOperations() {
        let operationQueueSpy = OperationQueueSpy()
        self.sut.geojsonTileCarouselSelectionQueue = operationQueueSpy
        
        self.sut.cancelAllGeojsonCarouselSelectionOperations()
        XCTAssertTrue(operationQueueSpy.cancelAllOperationsCalled)
    }
    
    func testGetGeoEntityForEntity() {
        self.sut.getGeoEntityForEntity("blockId", entityLevel: EntityLevel.block)
        XCTAssertEqual(self.sut.geoEntityQueue.operationCount, 1)
    }
    
    func testCancelAllGeoEntityOperations() {
        let operationQueueSpy = OperationQueueSpy()
        self.sut.geoEntityQueue = operationQueueSpy
        
        self.sut.cancelAllGeoEntityOperations()
        XCTAssertTrue(operationQueueSpy.cancelAllOperationsCalled)
    }
    
    func testGetGeojsonTileForCarouselDetermination() {
        self.sut.getGeojsonTileForCarouselDetermination(tileCoordinate: STPhotoMapSeeds.tileCoordinate, keyUrl: STPhotoMapSeeds.imageUrl, downloadUrl: STPhotoMapSeeds.imageUrl)
        XCTAssertEqual(self.sut.geojsonTileCarouselDeterminationQueue.operationCount, 1)
    }
    
    func testCancelAllGeojsonTileForCarouselDeterminationOperations() {
        let operationQueueSpy = OperationQueueSpy()
        self.sut.geojsonTileCarouselDeterminationQueue = operationQueueSpy
        
        self.sut.cancelAllGeojsonTileForCarouselDeterminationOperations()
        XCTAssertTrue(operationQueueSpy.cancelAllOperationsCalled)
    }
    
    func testGetImageForPhoto() {
        self.sut.getImageForPhoto(photo: STPhotoMapSeeds().photo())
        XCTAssertEqual(self.sut.getImageForPhotoQueue.operationCount, 1)
    }
    
    func testGetPhotoDetailsForPhotoAnnotation() {
        self.sut.getPhotoDetailsForPhotoAnnotation(STPhotoMapSeeds().photoAnnotation())
        XCTAssertEqual(self.sut.photoDetailsQueue.operationCount, 1)
    }
}
