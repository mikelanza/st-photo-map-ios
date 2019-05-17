//
//  STPhotoMapInteractorTests.swift
//  STPhotoMap
//
//  Created by Dimitri Strauneanu on 12/04/2019.
//  Copyright (c) 2019 mikelanza. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

@testable import STPhotoMap
import XCTest

class STPhotoMapInteractorTests: XCTestCase {
    var sut: STPhotoMapInteractor!
    var presenterSpy: STPhotoMapPresentationLogicSpy!
    var workerSpy: STPhotoMapWorkerSuccessSpy!
  
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
        
        self.workerSpy = STPhotoMapWorkerSuccessSpy(delegate: self.sut)
        self.sut.worker = self.workerSpy
    }
    
    private func waitForSynchronization() {
        let waitExpectation = expectation(description: "Waiting for the synchronization.")
        let queue = DispatchQueue(label: "queue", attributes: .concurrent)
        queue.async {
            waitExpectation.fulfill()
        }
        waitForExpectations(timeout: 1.0)
    }
    
    // MARK: - Tests
      
    func testShouldUpdateVisibleTiles() {
        let tiles: [TileCoordinate] = STPhotoMapSeeds.tileCoordinates
        
        let request = STPhotoMapModels.VisibleTiles.Request(tiles: tiles)
        self.sut.shouldUpdateVisibleTiles(request: request)
        
        XCTAssertEqual(self.sut.visibleTiles.count, tiles.count)
    }
    
    // MARK: - Caching geojson objects
    
    func testShouldCacheGeojsonObjectsWhenCacheIsEmptyForSuccessCase() {
        let tileCoordinates = STPhotoMapSeeds.tileCoordinates
        self.sut.cacheHandler.cache.removeAllTiles()
        self.sut.cacheHandler.removeAllActiveDownloads()
        self.sut.visibleTiles = tileCoordinates
        
        self.waitForSynchronization()
        
        self.sut.shouldCacheGeojsonObjects()
        
        XCTAssertTrue(self.workerSpy.getGeojsonTileForCachingCalled)
        
        XCTAssertEqual(self.sut.cacheHandler.activeDownloadCount(), 0)
        XCTAssertEqual(self.sut.cacheHandler.cache.tileCount(), tileCoordinates.count)
    }
    
    func testShouldCacheGeojsonObjectsWhenCacheIsEmptyForFailureCase() {
        let worker = STPhotoMapWorkerFailureSpy(delegate: self.sut)
        self.sut.worker = worker
        
        let tileCoordinates = STPhotoMapSeeds.tileCoordinates
        self.sut.cacheHandler.cache.removeAllTiles()
        self.sut.cacheHandler.removeAllActiveDownloads()
        self.sut.visibleTiles = tileCoordinates
        
        self.waitForSynchronization()
        
        self.sut.shouldCacheGeojsonObjects()
        
        XCTAssertTrue(worker.getGeojsonTileForCachingCalled)
        
        XCTAssertEqual(self.sut.cacheHandler.activeDownloadCount(), 0)
        XCTAssertEqual(self.sut.cacheHandler.cache.tileCount(), 0)
    }
    
    func testShouldCacheGeojsonObjectsWhenCacheIsNotEmptyForSuccessCase() throws {
        let tileCoordinate = STPhotoMapSeeds.tileCoordinate
        let keyUrl = STPhotoMapUrlBuilder().geojsonTileUrl(tileCoordinate: tileCoordinate).keyUrl
        let geojsonObject = try STPhotoMapSeeds().geojsonObject()
        
        self.sut.cacheHandler.removeAllActiveDownloads()
        self.sut.cacheHandler.cache.addTile(tile: STPhotoMapCache.Tile(keyUrl: keyUrl, geojsonObject: geojsonObject))
        self.sut.visibleTiles = [tileCoordinate]
        
        self.waitForSynchronization()
        
        self.sut.shouldCacheGeojsonObjects()
        
        XCTAssertFalse(self.workerSpy.getGeojsonTileForCachingCalled)
        
        XCTAssertEqual(self.sut.cacheHandler.cache.tileCount(), 1)
        XCTAssertEqual(self.sut.cacheHandler.activeDownloadCount(), 0)
    }
    
    func testShouldCacheGeojsonObjectsWhenCacheIsNotEmptyForFailureCase() throws {
        let worker = STPhotoMapWorkerFailureSpy(delegate: self.sut)
        self.sut.worker = worker
        
        let tileCoordinate = STPhotoMapSeeds.tileCoordinate
        let keyUrl = STPhotoMapUrlBuilder().geojsonTileUrl(tileCoordinate: tileCoordinate).keyUrl
        let geojsonObject = try STPhotoMapSeeds().geojsonObject()
        
        self.sut.cacheHandler.removeAllActiveDownloads()
        self.sut.cacheHandler.cache.addTile(tile: STPhotoMapCache.Tile(keyUrl: keyUrl, geojsonObject: geojsonObject))
        self.sut.visibleTiles = [tileCoordinate]
        
        self.waitForSynchronization()
        
        self.sut.shouldCacheGeojsonObjects()
        
        XCTAssertFalse(worker.getGeojsonTileForCachingCalled)
        
        XCTAssertEqual(self.sut.cacheHandler.cache.tileCount(), 1)
        XCTAssertEqual(self.sut.cacheHandler.activeDownloadCount(), 0)
    }
    
    func testShouldCacheGeojsonObjectsWhenCacheIsEmptyAndThereAreActiveDownloadsForSuccessCase() {
        let tileCoordinate = STPhotoMapSeeds.tileCoordinate
        let keyUrl = STPhotoMapUrlBuilder().geojsonTileUrl(tileCoordinate: tileCoordinate).keyUrl
        
        self.sut.cacheHandler.cache.removeAllTiles()
        self.sut.cacheHandler.addActiveDownload(keyUrl)
        self.sut.visibleTiles = [tileCoordinate]
        
        self.waitForSynchronization()
        
        self.sut.shouldCacheGeojsonObjects()
        
        XCTAssertFalse(self.workerSpy.getGeojsonTileForCachingCalled)
        
        XCTAssertEqual(self.sut.cacheHandler.cache.tileCount(), 0)
        XCTAssertEqual(self.sut.cacheHandler.activeDownloadCount(), 1)
    }
    
    func testShouldCacheGeojsonObjectsWhenCacheIsEmptyAndThereAreActiveDownloadsForFailureCase() {
        let tileCoordinate = STPhotoMapSeeds.tileCoordinate
        let keyUrl = STPhotoMapUrlBuilder().geojsonTileUrl(tileCoordinate: tileCoordinate).keyUrl
        
        self.sut.cacheHandler.cache.removeAllTiles()
        self.sut.cacheHandler.addActiveDownload(keyUrl)
        self.sut.visibleTiles = [tileCoordinate]
        
        self.waitForSynchronization()
        
        self.sut.shouldCacheGeojsonObjects()
        
        XCTAssertFalse(self.workerSpy.getGeojsonTileForCachingCalled)
        
        XCTAssertEqual(self.sut.cacheHandler.cache.tileCount(), 0)
        XCTAssertEqual(self.sut.cacheHandler.activeDownloadCount(), 1)
    }
    
    func testShouldCacheGeojsonObjectsWhenCacheIsNotEmptyAndThereAreActiveDownloadsForSuccessCase() throws {
        let tileCoordinates = STPhotoMapSeeds.tileCoordinates
        let keyUrl = STPhotoMapUrlBuilder().geojsonTileUrl(tileCoordinate: tileCoordinates.first!).keyUrl
        let activeDownloadUrl = STPhotoMapUrlBuilder().geojsonTileUrl(tileCoordinate: tileCoordinates.last!).keyUrl
        let geojsonObject = try STPhotoMapSeeds().geojsonObject()
        
        self.sut.cacheHandler.addActiveDownload(activeDownloadUrl)
        self.sut.cacheHandler.cache.addTile(tile: STPhotoMapCache.Tile(keyUrl: keyUrl, geojsonObject: geojsonObject))
        self.sut.visibleTiles = tileCoordinates
        
        self.waitForSynchronization()
        
        self.sut.shouldCacheGeojsonObjects()
        
        XCTAssertTrue(self.workerSpy.getGeojsonTileForCachingCalled)
        
        XCTAssertEqual(self.sut.cacheHandler.cache.tileCount(), 2)
        XCTAssertEqual(self.sut.cacheHandler.activeDownloadCount(), 1)
    }
    
    func testShouldCacheGeojsonObjectsWhenCacheIsNotEmptyAndThereAreActiveDownloadsForFailureCase() throws {
        let worker = STPhotoMapWorkerFailureSpy(delegate: self.sut)
        self.sut.worker = worker
        
        let tileCoordinates = STPhotoMapSeeds.tileCoordinates
        let keyUrl = STPhotoMapUrlBuilder().geojsonTileUrl(tileCoordinate: tileCoordinates.first!).keyUrl
        let activeDownloadUrl = STPhotoMapUrlBuilder().geojsonTileUrl(tileCoordinate: tileCoordinates.last!).keyUrl
        let geojsonObject = try STPhotoMapSeeds().geojsonObject()
        
        self.sut.cacheHandler.addActiveDownload(activeDownloadUrl)
        self.sut.cacheHandler.cache.addTile(tile: STPhotoMapCache.Tile(keyUrl: keyUrl, geojsonObject: geojsonObject))
        self.sut.visibleTiles = tileCoordinates
        
        self.waitForSynchronization()
        
        self.sut.shouldCacheGeojsonObjects()
        
        XCTAssertTrue(worker.getGeojsonTileForCachingCalled)
        
        XCTAssertEqual(self.sut.cacheHandler.cache.tileCount(), 1)
        XCTAssertEqual(self.sut.cacheHandler.activeDownloadCount(), 1)
    }
    
    // MARK: - Entity level
    
    func testShouldDetermineEntityLevelWhenCacheIsEmptyAndThereAreNoActiveDownloadsForSuccessCase() {
        self.sut.cacheHandler.cache.removeAllTiles()
        self.sut.cacheHandler.removeAllActiveDownloads()
        self.sut.visibleTiles = [STPhotoMapSeeds.tileCoordinate]
        
        self.waitForSynchronization()
        
        self.sut.shouldDetermineEntityLevel()
        
        XCTAssertTrue(self.workerSpy.getGeojsonTileForEntityLevelCalled)
        XCTAssertFalse(self.presenterSpy.presentLoadingStateCalled)
        XCTAssertTrue(self.presenterSpy.presentNotLoadingStateCalled)
        
        XCTAssertTrue(self.presenterSpy.presentEntityLevelCalled)
    }
    
    func testShouldDetermineEntityLevelWhenCacheIsEmptyAndThereAreNoActiveDownloadsForFailureCase() {
        let worker = STPhotoMapWorkerFailureSpy(delegate: self.sut)
        self.sut.worker = worker
        
        self.sut.cacheHandler.cache.removeAllTiles()
        self.sut.cacheHandler.removeAllActiveDownloads()
        self.sut.visibleTiles = [STPhotoMapSeeds.tileCoordinate]
        
        self.waitForSynchronization()
        
        self.sut.shouldDetermineEntityLevel()
        
        XCTAssertTrue(worker.getGeojsonTileForEntityLevelCalled)
        XCTAssertFalse(self.presenterSpy.presentLoadingStateCalled)
        XCTAssertTrue(self.presenterSpy.presentNotLoadingStateCalled)
        
        XCTAssertFalse(self.presenterSpy.presentEntityLevelCalled)
    }
    
    func testShouldDetermineEntityLevelWhenCacheIsEmptyAndThereAreActiveDownloads() {
        let tileCoordinate = STPhotoMapSeeds.tileCoordinate
        let keyUrl = STPhotoMapUrlBuilder().geojsonTileUrl(tileCoordinate: tileCoordinate).keyUrl
        
        self.sut.cacheHandler.cache.removeAllTiles()
        self.sut.cacheHandler.removeAllActiveDownloads()
        
        self.sut.entityLevelHandler.addActiveDownload(keyUrl)
        self.sut.visibleTiles = [tileCoordinate]
        
        self.waitForSynchronization()
        
        self.sut.shouldDetermineEntityLevel()
        
        XCTAssertFalse(self.workerSpy.getGeojsonTileForEntityLevelCalled)
        XCTAssertTrue(self.presenterSpy.presentLoadingStateCalled)
        XCTAssertFalse(self.presenterSpy.presentNotLoadingStateCalled)
        XCTAssertFalse(self.presenterSpy.presentEntityLevelCalled)
    }
    
    func testShouldDetermineEntityLevelWhenCacheIsNotEmptyAndNoActiveDownloads() throws {
        let tileCoordinate = STPhotoMapSeeds.tileCoordinate
        let keyUrl = STPhotoMapUrlBuilder().geojsonTileUrl(tileCoordinate: tileCoordinate).keyUrl
        let geojsonObject = try STPhotoMapSeeds().geojsonObject()
        
        self.sut.cacheHandler.removeAllActiveDownloads()
        self.sut.cacheHandler.cache.addTile(tile: STPhotoMapCache.Tile(keyUrl: keyUrl, geojsonObject: geojsonObject))
        self.sut.visibleTiles = [tileCoordinate]
        
        self.waitForSynchronization()
        
        self.sut.shouldDetermineEntityLevel()
        
        XCTAssertFalse(self.workerSpy.getGeojsonTileForCachingCalled)
        XCTAssertTrue(self.presenterSpy.presentNotLoadingStateCalled)
        XCTAssertFalse(self.presenterSpy.presentLoadingStateCalled)
        XCTAssertTrue(self.presenterSpy.presentEntityLevelCalled)
    }
    
    func testShouldDetermineEntityLevelWhenNewEntityLevelIsNotChanged() {
        self.sut.cacheHandler.cache.removeAllTiles()
        self.sut.cacheHandler.removeAllActiveDownloads()
        
        self.sut.entityLevelHandler.entityLevel = .city
        self.sut.visibleTiles = [STPhotoMapSeeds.tileCoordinate]
        
        self.waitForSynchronization()
        
        self.sut.shouldDetermineEntityLevel()
        
        XCTAssertTrue(self.workerSpy.getGeojsonTileForEntityLevelCalled)
        XCTAssertFalse(self.presenterSpy.presentLoadingStateCalled)
        XCTAssertTrue(self.presenterSpy.presentNotLoadingStateCalled)
        
        XCTAssertFalse(self.presenterSpy.presentEntityLevelCalled)
    }
    
    func testShouldDetermineEntityLevelWhenNewEntityLevelIsChanged() {
        self.sut.cacheHandler.cache.removeAllTiles()
        self.sut.cacheHandler.removeAllActiveDownloads()
        
        self.sut.entityLevelHandler.entityLevel = .unknown
        self.sut.visibleTiles = [STPhotoMapSeeds.tileCoordinate]
        
        self.waitForSynchronization()
        
        self.sut.shouldDetermineEntityLevel()
        
        XCTAssertTrue(self.workerSpy.getGeojsonTileForEntityLevelCalled)
        XCTAssertFalse(self.presenterSpy.presentLoadingStateCalled)
        XCTAssertTrue(self.presenterSpy.presentNotLoadingStateCalled)
        
        XCTAssertTrue(self.presenterSpy.presentEntityLevelCalled)
    }
    
    func testShouldDetermineEntityLevelWhenDownloadedTileIsNotStillVisible() {
        self.workerSpy.delay = 1
        self.sut.visibleTiles = [STPhotoMapSeeds.tileCoordinate]
        
        self.waitForSynchronization()
        
        self.sut.shouldDetermineEntityLevel()
        self.sut.visibleTiles.removeAll()
        
        XCTAssertTrue(self.workerSpy.getGeojsonTileForEntityLevelCalled)
        XCTAssertFalse(self.presenterSpy.presentEntityLevelCalled)
    }
    
    func testShouldDetermineEntityLevelWhenDownloadedTileIsStillVisible() {
        self.sut.visibleTiles = [STPhotoMapSeeds.tileCoordinate]
        
        self.waitForSynchronization()
        
        self.sut.shouldDetermineEntityLevel()
        
        XCTAssertTrue(self.workerSpy.getGeojsonTileForEntityLevelCalled)
        XCTAssertTrue(self.presenterSpy.presentEntityLevelCalled)
    }
    
    func testShouldDetermineLocationWhenEntityLevelIsNotLocation() throws {
        let tileCoordinate = STPhotoMapSeeds.tileCoordinate
        let keyUrl = STPhotoMapUrlBuilder().geojsonTileUrl(tileCoordinate: tileCoordinate).keyUrl
        let geojsonObject = try STPhotoMapSeeds().geojsonObject()
        
        self.sut.cacheHandler.removeAllActiveDownloads()
        self.sut.cacheHandler.cache.addTile(tile: STPhotoMapCache.Tile(keyUrl: keyUrl, geojsonObject: geojsonObject))
        self.sut.visibleTiles = [tileCoordinate]
        
        self.sut.entityLevelHandler.entityLevel = .city
        
        self.waitForSynchronization()
        
        self.sut.shouldDetermineLocation()
        
        XCTAssertFalse(self.presenterSpy.presentLocationAnnotationsCalled)
    }
    
    func testShouldDetermineLocationWhenEntityLevelIsLocation() throws {
        let tileCoordinate = STPhotoMapSeeds.tileCoordinate
        let keyUrl = STPhotoMapUrlBuilder().geojsonTileUrl(tileCoordinate: tileCoordinate).keyUrl
        let geojsonObject = try STPhotoMapSeeds().locationGeojsonObject()
        
        self.sut.cacheHandler.removeAllActiveDownloads()
        self.sut.cacheHandler.cache.addTile(tile: STPhotoMapCache.Tile(keyUrl: keyUrl, geojsonObject: geojsonObject))
        self.sut.visibleTiles = [tileCoordinate]
        
        self.sut.entityLevelHandler.entityLevel = .location
        
        self.waitForSynchronization()
        
        self.sut.shouldDetermineLocation()
        
        XCTAssertTrue(self.presenterSpy.presentLocationAnnotationsCalled)
    }
}
