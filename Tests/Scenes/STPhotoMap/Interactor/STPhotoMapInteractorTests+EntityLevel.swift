//
//  STPhotoMapInteractorTests+EntityLevel.swift
//  STPhotoMapTests-iOS
//
//  Created by Dimitri Strauneanu on 12/09/2019.
//  Copyright © 2019 Streetography. All rights reserved.
//

@testable import STPhotoMap
import XCTest
import MapKit
import STPhotoCore

class STPhotoMapInteractorEntityLevelTests: XCTestCase {
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
    
    func testShouldDetermineEntityLevelShouldAskTheWorkerToCancelAllGeojsonEntityLevelOperations() {
        self.sut.shouldDetermineEntityLevel()
        XCTAssertTrue(self.workerSpy.cancelAllGeojsonEntityLevelOperationsCalled)
    }
    
    func testShouldDetermineEntityLevelShouldAskThePresenterToPresentLoadingStateWhenThereAreActiveDownloads() {
        self.sut.entityLevelHandler.addActiveDownload("keyUrl")
        self.sut.shouldDetermineEntityLevel()
        XCTAssertTrue(self.presenterSpy.presentLoadingStateCalled)
    }
    
    func testShouldDetermineEntityLevelShouldAskThePresenterToPresentNotLoadingStateWhenThereAreNoActiveDownloads() {
        self.sut.entityLevelHandler.removeAllActiveDownloads()
        self.sut.shouldDetermineEntityLevel()
        XCTAssertTrue(self.presenterSpy.presentNotLoadingStateCalled)
    }
    
    func testShouldDetermineEntityLevelShouldAskTheEntityLevelHandlerToChangeEntityLevelWhenTheCacheIsNotEmpty() throws {
        let tileCoordinate = STPhotoMapSeeds.tileCoordinate
        let keyUrl = "keyUrl"
        let geojsonObject = try STPhotoMapSeeds().geojsonObject()
        self.workerSpy.geojsonObject = geojsonObject
        
        self.sut.entityLevelHandler.removeAllActiveDownloads()
        self.sut.cacheHandler.cache.addTile(tile: STPhotoMapGeojsonCache.Tile(keyUrl: keyUrl, geojsonObject: geojsonObject))
        self.sut.visibleTiles = [tileCoordinate]
        
        let spy = STPhotoMapEntityLevelHandlerSpy()
        self.sut.entityLevelHandler = spy
        self.sut.shouldDetermineEntityLevel()
        XCTAssertTrue(spy.changeEntityLevelCalled)
    }
    
    func testShouldDetermineEntityLevelShouldAddActiveDownloadWhenCacheIsEmptyAndThereAreNoActiveDownloads() throws {
        let geojsonObject = try STPhotoMapSeeds().geojsonObject()
        self.workerSpy.geojsonObject = geojsonObject
        
        self.sut.entityLevelHandler.removeAllActiveDownloads()
        self.sut.cacheHandler.cache.removeAllTiles()
        self.sut.visibleTiles = [STPhotoMapSeeds.tileCoordinate]
        
        let spy = STPhotoMapEntityLevelHandlerSpy()
        self.sut.entityLevelHandler = spy
        self.sut.shouldDetermineEntityLevel()
        XCTAssertTrue(spy.addActiveDownloadCalled)
    }
    
    func testShouldDetermineEntityLevelShouldAskTheWorkerToGetGeojsonEntityLevelWhenCacheIsEmptyAndThereAreNoActiveDownloads() throws {
        let geojsonObject = try STPhotoMapSeeds().geojsonObject()
        self.workerSpy.geojsonObject = geojsonObject
        
        self.sut.entityLevelHandler.removeAllActiveDownloads()
        self.sut.cacheHandler.cache.removeAllTiles()
        self.sut.visibleTiles = [STPhotoMapSeeds.tileCoordinate]
        
        self.sut.shouldDetermineEntityLevel()
        XCTAssertTrue(self.workerSpy.getGeojsonTileForEntityLevelCalled)
    }
    
    func testSuccessDidGetGeojsonTileForEntityLevelShouldRemoveActiveDownload() throws {
        let geojsonObject = try STPhotoMapSeeds().geojsonObject()
        let spy = STPhotoMapEntityLevelHandlerSpy()
        self.sut.entityLevelHandler = spy
        self.sut.successDidGetGeojsonTileForEntityLevel(tileCoordinate: STPhotoMapSeeds.tileCoordinate, keyUrl: "keyUrl", downloadUrl: "downloadUrl", geojsonObject: geojsonObject)
        XCTAssertTrue(spy.removeActiveDownloadCalled)
    }
    
    func testSuccessDidGetGeojsonTileForEntityLevelShouldAskTheEntityLevelHandlerToChangeEntityLevelWhenTheTileIsStillVisible() throws {
        let geoEntity = try STPhotoMapSeeds().geoEntity()
        let geojsonObject = try STPhotoMapSeeds().geojsonObject()
        let tileCoordinate = STPhotoMapSeeds.tileCoordinate
        
        self.sut.visibleTiles = [tileCoordinate]
        self.sut.visibleMapRect = geoEntity.boundingBox.mapRect()
        
        let spy = STPhotoMapEntityLevelHandlerSpy()
        self.sut.entityLevelHandler = spy
        self.sut.successDidGetGeojsonTileForEntityLevel(tileCoordinate: tileCoordinate, keyUrl: "keyUrl", downloadUrl: "downloadUrl", geojsonObject: geojsonObject)
        XCTAssertTrue(spy.changeEntityLevelCalled)
    }
    
    func testSuccessDidGetGeojsonTileForEntityLevelShouldAskTheWorkerToCancelAllGeojsonEntityLevelOperationsWhenTheTileIsStillVisible() throws {
        let geoEntity = try STPhotoMapSeeds().geoEntity()
        let geojsonObject = try STPhotoMapSeeds().geojsonObject()
        let tileCoordinate = STPhotoMapSeeds.tileCoordinate
        
        let spy = STPhotoMapEntityLevelHandlerSpy()
        self.sut.entityLevelHandler = spy
        self.sut.visibleTiles = [tileCoordinate]
        self.sut.visibleMapRect = geoEntity.boundingBox.mapRect()
        
        self.sut.successDidGetGeojsonTileForEntityLevel(tileCoordinate: tileCoordinate, keyUrl: "keyUrl", downloadUrl: "downloadUrl", geojsonObject: geojsonObject)
        XCTAssertTrue(self.workerSpy.cancelAllGeojsonEntityLevelOperationsCalled)
    }
    
    func testSuccessDidGetGeojsonTileForEntityLevelShouldAskThePresenterToPresentLoadingStateWhenThereAreActiveDownloads() throws {
        let geojsonObject = try STPhotoMapSeeds().geojsonObject()
        let tileCoordinate = STPhotoMapSeeds.tileCoordinate
        self.sut.entityLevelHandler.addActiveDownload("keyUrl")
        self.sut.successDidGetGeojsonTileForEntityLevel(tileCoordinate: tileCoordinate, keyUrl: "newKeyUrl", downloadUrl: "downloadUrl", geojsonObject: geojsonObject)
        XCTAssertTrue(self.presenterSpy.presentLoadingStateCalled)
    }
    
    func testSuccessDidGetGeojsonTileForEntityLevelShouldAskThePresenterToPresentNotLoadingStateWhenThereAreNoActiveDownloads() throws {
        let geojsonObject = try STPhotoMapSeeds().geojsonObject()
        let tileCoordinate = STPhotoMapSeeds.tileCoordinate
        self.sut.entityLevelHandler.removeAllActiveDownloads()
        self.sut.successDidGetGeojsonTileForEntityLevel(tileCoordinate: tileCoordinate, keyUrl: "keyUrl", downloadUrl: "downloadUrl", geojsonObject: geojsonObject)
        XCTAssertTrue(self.presenterSpy.presentNotLoadingStateCalled)
    }
    
    func testFailureDidGetGeojsonTileForEntityLevelShouldRemoveActiveDownload() {
        let spy = STPhotoMapEntityLevelHandlerSpy()
        self.sut.entityLevelHandler = spy
        self.sut.failureDidGetGeojsonTileForEntityLevel(tileCoordinate: STPhotoMapSeeds.tileCoordinate, keyUrl: "keyUrl", downloadUrl: "downloadUrl", error: OperationError.noDataAvailable)
        XCTAssertTrue(spy.removeActiveDownloadCalled)
    }
    
    func testFailureDidGetGeojsonTileForEntityLevelShouldAskThePresenterToPresentLoadingStateWhenThereAreActiveDownloads() {
        let tileCoordinate = STPhotoMapSeeds.tileCoordinate
        self.sut.entityLevelHandler.addActiveDownload("keyUrl")
        self.sut.failureDidGetGeojsonTileForEntityLevel(tileCoordinate: tileCoordinate, keyUrl: "newKeyUrl", downloadUrl: "downloadUrl", error: OperationError.noDataAvailable)
        XCTAssertTrue(self.presenterSpy.presentLoadingStateCalled)
    }
    
    func testFailureDidGetGeojsonTileForEntityLevelShouldAskThePresenterToPresentNotLoadingStateWhenThereAreNoActiveDownloads() {
        let tileCoordinate = STPhotoMapSeeds.tileCoordinate
        self.sut.entityLevelHandler.removeAllActiveDownloads()
        self.sut.failureDidGetGeojsonTileForEntityLevel(tileCoordinate: tileCoordinate, keyUrl: "keyUrl", downloadUrl: "downloadUrl", error: OperationError.noDataAvailable)
        XCTAssertTrue(self.presenterSpy.presentNotLoadingStateCalled)
    }
}
