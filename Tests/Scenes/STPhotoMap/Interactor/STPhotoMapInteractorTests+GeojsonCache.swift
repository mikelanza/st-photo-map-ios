//
//  STPhotoMapInteractorTests+GeojsonCache.swift
//  STPhotoMapTests-iOS
//
//  Created by Dimitri Strauneanu on 12/09/2019.
//  Copyright © 2019 Streetography. All rights reserved.
//

@testable import STPhotoMap
import XCTest
import MapKit
import STPhotoCore

class STPhotoMapInteractorGeojsonCacheTests: XCTestCase {
    var sut: STPhotoMapInteractor!
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
        
        self.workerSpy = STPhotoMapWorkerSpy(delegate: self.sut)
        self.sut.worker = self.workerSpy
    }
    
    // MARK: - Tests
    
    func testShouldCacheGeojsonObjectsShouldAddActiveDownloadWhenTheCacheIsEmptyAndThereAreNoActiveDownloads() throws {
        let geojsonObject = try STPhotoMapSeeds().geojsonObject()
        self.workerSpy.geojsonObject = geojsonObject
        
        let cacheHandlerSpy = STPhotoMapGeojsonCacheHandlerSpy()
        self.sut.cacheHandler = cacheHandlerSpy
        self.sut.visibleTiles = [STPhotoMapSeeds.tileCoordinate]
        
        self.sut.shouldCacheGeojsonObjects()
        XCTAssertTrue(cacheHandlerSpy.addActiveDownloadCalled)
    }
    
    func testShouldCacheGeojsonObjectsShouldAskTheWorkerToGetGeojsonTileForCachingWhenTheCacheIsNotEmptyAndThereAreNoActiveDownloads() throws {
        let geojsonObject = try STPhotoMapSeeds().geojsonObject()
        self.workerSpy.geojsonObject = geojsonObject
        
        self.sut.cacheHandler.removeAllActiveDownloads()
        self.sut.visibleTiles = [STPhotoMapSeeds.tileCoordinate]
        
        self.sut.shouldCacheGeojsonObjects()
        XCTAssertTrue(self.workerSpy.getGeojsonTileForCachingCalled)
    }
    
    func testShouldCacheGeojsonObjectsShouldNotAskTheWorkerToGetGeojsonTileForCachingWhenTheCacheIsNotEmptyAndThereAreActiveDownloads() throws {
        let tileCoordinate = STPhotoMapSeeds.tileCoordinate
        let keyUrl = STPhotoMapUrlBuilder().geojsonTileUrl(tileCoordinate: tileCoordinate).keyUrl
        self.sut.cacheHandler.addActiveDownload(keyUrl)
        self.sut.visibleTiles = [STPhotoMapSeeds.tileCoordinate]
        
        self.sut.shouldCacheGeojsonObjects()
        XCTAssertFalse(self.workerSpy.getGeojsonTileForCachingCalled)
    }
    
    func testShouldCacheGeojsonObjectsShouldNotAskTheWorkerToGetGeojsonTileForCachingWhenTheCacheIsEmpty() {
        self.sut.cacheHandler.cache.removeAllTiles()
        self.sut.cacheHandler.removeAllActiveDownloads()
        self.sut.shouldCacheGeojsonObjects()
        XCTAssertFalse(self.workerSpy.getGeojsonTileForCachingCalled)
    }
    
    func testSuccessDidGetGeojsonTileForCachingShouldAddCacheTile() throws {
        self.sut.cacheHandler.cache.removeAllTiles()
        self.sut.cacheHandler.removeAllActiveDownloads()
        
        let tileCoordinate = STPhotoMapSeeds.tileCoordinate
        let keyUrl = "keyUrl"
        let downloadUrl = "downloadUrl"
        let geojsonObject = try STPhotoMapSeeds().geojsonObject()
        self.sut.successDidGetGeojsonTileForCaching(tileCoordinate: tileCoordinate, keyUrl: keyUrl, downloadUrl: downloadUrl, geojsonObject: geojsonObject)
        
        XCTAssertEqual(self.sut.cacheHandler.cache.tiles.count, 1)
        
        let tile = self.sut.cacheHandler.cache.tiles.first
        XCTAssertEqual(tile?.keyUrl, keyUrl)
        XCTAssertEqual(tile?.geojsonObject.type, geojsonObject.type)
        XCTAssertEqual(tile?.geojsonObject.entityLevel, geojsonObject.entityLevel)
    }
    
    func testSuccessDidGetGeojsonTileForCachingShouldRemoveCacheActiveDownload() throws {
        self.sut.cacheHandler.cache.removeAllTiles()
        self.sut.cacheHandler.removeAllActiveDownloads()
        
        let tileCoordinate = STPhotoMapSeeds.tileCoordinate
        let keyUrl = "keyUrl"
        let downloadUrl = "downloadUrl"
        let geojsonObject = try STPhotoMapSeeds().geojsonObject()
        self.sut.cacheHandler.addActiveDownload(keyUrl)
        self.sut.successDidGetGeojsonTileForCaching(tileCoordinate: tileCoordinate, keyUrl: keyUrl, downloadUrl: downloadUrl, geojsonObject: geojsonObject)
        
        XCTAssertEqual(self.sut.cacheHandler.activeDownloadCount(), 0)
    }
    
    func testFailureDidGetGeojsonTileForCachingShouldRemoveCacheActiveDownload() {
        self.sut.cacheHandler.cache.removeAllTiles()
        self.sut.cacheHandler.removeAllActiveDownloads()
        
        let tileCoordinate = STPhotoMapSeeds.tileCoordinate
        let keyUrl = "keyUrl"
        let downloadUrl = "downloadUrl"
        self.sut.cacheHandler.addActiveDownload(keyUrl)
        self.sut.failureDidGetGeojsonTileForCaching(tileCoordinate: tileCoordinate, keyUrl: keyUrl, downloadUrl: downloadUrl, error: OperationError.noDataAvailable)
        
        XCTAssertEqual(self.sut.cacheHandler.activeDownloadCount(), 0)
    }
}
