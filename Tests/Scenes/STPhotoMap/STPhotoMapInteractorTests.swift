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
    
    var workerDelay: Double = 0.1
    var delay: Double = 0.05
  
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
    
    private func waitForWorker(delay: Double) {
        let waitExpectation = expectation(description: "Waiting for the worker.")
        let queue = DispatchQueue.global()
        queue.asyncAfter(deadline: .now() + delay) {
            waitExpectation.fulfill()
        }
        waitForExpectations(timeout: 1.0)
    }
    
    private func wait(delay: Double) {
        let waitExpectation = expectation(description: "Waiting.")
        let queue = DispatchQueue.global()
        queue.asyncAfter(deadline: .now() + delay) {
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
    
    func testShouldNavigateToPhotoDetails() {
        let request = STPhotoMapModels.PhotoDetailsNavigation.Request(photoId: STPhotoMapSeeds.photoId)
        self.sut.shouldNavigateToPhotoDetails(request: request)
        
        XCTAssertTrue(self.presenterSpy.presentNavigateToPhotoDetailsCalled)
    }

    // MARK: - Download image for photo annotation

    func testShouldDownloadImageForPhotoAnnotationWhenThereIsNoImageForSuccessCase() {
        self.workerSpy.delay = self.workerDelay

        let photoAnnotation = STPhotoMapSeeds().photoAnnotation()
        photoAnnotation.image = nil
        let request = STPhotoMapModels.PhotoAnnotationImageDownload.Request(photoAnnotation: photoAnnotation)
        self.sut.shouldDownloadImageForPhotoAnnotation(request: request)

        XCTAssertNil(photoAnnotation.image)
        XCTAssertTrue(photoAnnotation.isLoading)
        XCTAssertTrue(self.workerSpy.downloadImageForPhotoAnnotationCalled)

        self.waitForWorker(delay: self.workerDelay)

        XCTAssertFalse(photoAnnotation.isLoading)
        XCTAssertNotNil(photoAnnotation.image)
    }

    func testShouldDownloadImageForPhotoAnnotationWhenThereIsNoImageForFailureCase() {
        let worker = STPhotoMapWorkerFailureSpy(delegate: self.sut)
        worker.delay = self.workerDelay
        self.sut.worker = worker

        let photoAnnotation = STPhotoMapSeeds().photoAnnotation()
        photoAnnotation.image = nil
        let request = STPhotoMapModels.PhotoAnnotationImageDownload.Request(photoAnnotation: photoAnnotation)
        self.sut.shouldDownloadImageForPhotoAnnotation(request: request)

        XCTAssertNil(photoAnnotation.image)
        XCTAssertTrue(photoAnnotation.isLoading)
        XCTAssertTrue(worker.downloadImageForPhotoAnnotationCalled)

        self.waitForWorker(delay: self.workerDelay)

        XCTAssertFalse(photoAnnotation.isLoading)
        XCTAssertNil(photoAnnotation.image)
    }

    func testShouldDownloadImageForPhotoAnnotationWhenThereIsAnImage() {
        let photoAnnotation = STPhotoMapSeeds().photoAnnotation()
        let request = STPhotoMapModels.PhotoAnnotationImageDownload.Request(photoAnnotation: photoAnnotation)
        self.sut.shouldDownloadImageForPhotoAnnotation(request: request)

        XCTAssertFalse(self.workerSpy.downloadImageForPhotoAnnotationCalled)
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
        self.workerSpy.delay = self.workerDelay
        self.sut.visibleTiles = [STPhotoMapSeeds.tileCoordinate]

        self.waitForSynchronization()

        self.sut.shouldDetermineEntityLevel()

        self.waitForWorker(delay: self.workerDelay)

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

    // MARK: - Location level

    func testShouldDetermineLocationLevelWhenCacheIsNotEmptyAndEntityLevelIsLocation() throws {
        let tileCoordinate = STPhotoMapSeeds.tileCoordinate
        let keyUrl = STPhotoMapUrlBuilder().geojsonTileUrl(tileCoordinate: tileCoordinate).keyUrl
        let geojsonObject = try STPhotoMapSeeds().locationGeojsonObject()

        self.sut.cacheHandler.removeAllActiveDownloads()
        self.sut.cacheHandler.cache.addTile(tile: STPhotoMapCache.Tile(keyUrl: keyUrl, geojsonObject: geojsonObject))
        self.sut.visibleTiles = [tileCoordinate]

        self.sut.entityLevelHandler.entityLevel = .location

        self.waitForSynchronization()

        self.sut.shouldDetermineLocationLevel()

        XCTAssertTrue(self.presenterSpy.presentLocationAnnotationsCalled)
    }

    func testShouldDetermineLocationLevelWhenCacheIsNotEmptyAndEntityLevelIsNotLocation() throws {
        let tileCoordinate = STPhotoMapSeeds.tileCoordinate
        let keyUrl = STPhotoMapUrlBuilder().geojsonTileUrl(tileCoordinate: tileCoordinate).keyUrl
        let geojsonObject = try STPhotoMapSeeds().locationGeojsonObject()

        self.sut.cacheHandler.removeAllActiveDownloads()
        self.sut.cacheHandler.cache.addTile(tile: STPhotoMapCache.Tile(keyUrl: keyUrl, geojsonObject: geojsonObject))
        self.sut.visibleTiles = [tileCoordinate]

        self.sut.entityLevelHandler.entityLevel = .city

        self.waitForSynchronization()

        self.sut.shouldDetermineLocationLevel()

        XCTAssertFalse(self.presenterSpy.presentLocationAnnotationsCalled)
    }

    func testShouldDetermineLocationLevelWhenCacheIsEmptyAndEntityLevelIsLocationAndThereAreActiveDownloads() throws {
        let tileCoordinate = STPhotoMapSeeds.tileCoordinate
        let keyUrl = STPhotoMapUrlBuilder().geojsonTileUrl(tileCoordinate: tileCoordinate).keyUrl

        self.sut.cacheHandler.removeAllActiveDownloads()
        self.sut.visibleTiles = [tileCoordinate]

        self.sut.locationLevelHandler.addActiveDownload(keyUrl)

        self.sut.entityLevelHandler.entityLevel = .location

        self.waitForSynchronization()

        self.sut.shouldDetermineLocationLevel()

        XCTAssertFalse(self.workerSpy.getGeojsonLocationLevelCalled)
        XCTAssertFalse(self.presenterSpy.presentLocationAnnotationsCalled)
    }

    func testShouldDetermineLocationLevelWhenCacheIsEmptyAndEntityLevelIsLocationAfterTileIsDownloadedForSuccessCase() {
        let tileCoordinate = STPhotoMapSeeds.tileCoordinate

        self.sut.cacheHandler.removeAllActiveDownloads()
        self.sut.locationLevelHandler.removeAllActiveDownloads()
        self.sut.visibleTiles = [tileCoordinate]

        self.sut.entityLevelHandler.entityLevel = .location

        self.waitForSynchronization()

        self.sut.shouldDetermineLocationLevel()

        XCTAssertTrue(self.workerSpy.getGeojsonLocationLevelCalled)

        self.waitForWorker(delay: self.workerDelay)

        XCTAssertTrue(self.presenterSpy.presentLocationAnnotationsCalled)
    }

    func testShouldDetermineLocationLevelWhenCacheIsEmptyAndEntityLevelIsNotLocationAfterTileDownload() {
        self.workerSpy.delay = self.workerDelay

        let tileCoordinate = STPhotoMapSeeds.tileCoordinate

        self.sut.cacheHandler.removeAllActiveDownloads()
        self.sut.locationLevelHandler.removeAllActiveDownloads()
        self.sut.visibleTiles = [tileCoordinate]

        self.sut.entityLevelHandler.entityLevel = .location

        self.waitForSynchronization()

        self.sut.shouldDetermineLocationLevel()

        self.sut.entityLevelHandler.entityLevel = .city

        self.waitForWorker(delay: self.workerDelay)

        XCTAssertTrue(self.workerSpy.getGeojsonLocationLevelCalled)
        XCTAssertFalse(self.presenterSpy.presentLocationAnnotationsCalled)
    }
    
    func testShouldRemoveLocationAnnotationWhenEntityLevelIsNotLocation() {
        self.sut.cacheHandler.cache.removeAllTiles()
        self.sut.cacheHandler.removeAllActiveDownloads()
        
        self.sut.entityLevelHandler.entityLevel = .unknown
        self.sut.visibleTiles = [STPhotoMapSeeds.tileCoordinate]
        
        self.waitForSynchronization()
        
        self.sut.shouldDetermineEntityLevel()
        
        XCTAssertFalse(self.presenterSpy.presentLocationAnnotationsCalled)
        XCTAssertTrue(self.presenterSpy.presentRemoveLocationAnnotationsCalled)
    }
    
    // MARK: - Photo annotation selection
    
    func testShouldSelectPhotoAnnotationWhenItIsAlreadySelected() {
        let annotations = STPhotoMapSeeds().photoAnnotations()
        let annotation = annotations.first!
        let previousAnnotation = annotations.last!
        
        annotation.isSelected = true
        
        let request = STPhotoMapModels.PhotoAnnotationSelection.Request(photoAnnotation: annotation, previousPhotoAnnotation: previousAnnotation, photoClusterAnnotation: nil)
        self.sut.shouldSelectPhotoAnnotation(request: request)
        
        XCTAssertTrue(self.presenterSpy.presentNavigateToPhotoDetailsCalled)
    }
    
    func testShouldSelectPhotoAnnotationWhenItIsNotSelectedAndEntityLevelIsLocationForSuccessCase() {
        self.sut.entityLevelHandler.entityLevel = .location
        self.workerSpy.delay = self.workerDelay
        
        let annotations = STPhotoMapSeeds().photoAnnotations()
        let annotation = annotations.first!
        let previousAnnotation = annotations.last!
        previousAnnotation.isSelected = true
        
        let request = STPhotoMapModels.PhotoAnnotationSelection.Request(photoAnnotation: annotation, previousPhotoAnnotation: previousAnnotation, photoClusterAnnotation: nil)
        self.sut.shouldSelectPhotoAnnotation(request: request)
        
        XCTAssertTrue(annotation.isSelected)
        XCTAssertFalse(previousAnnotation.isSelected)
        
        XCTAssertTrue(self.presenterSpy.presentLoadingStateCalled)
        XCTAssertTrue(self.workerSpy.getPhotoDetailsForPhotoAnnotationCalled)
        
        self.waitForWorker(delay: self.workerDelay)
        
        XCTAssertTrue(self.presenterSpy.presentNotLoadingStateCalled)
        XCTAssertTrue(self.presenterSpy.presentLocationOverlayCalled)
    }
    
    func testShouldSelectPhotoAnnotationFromClusterWhenItIsNotSelectedAndEntityLevelIsLocationForSuccessCase() {
        self.sut.entityLevelHandler.entityLevel = .location
        self.workerSpy.delay = self.workerDelay
        
        let clusterAnnotationSpy = MultiplePhotoClusterAnnotationInterfaceSpy()
        let clusterAnnotation = STPhotoMapSeeds().multiplePhotoClusterAnnotation(count: 10)
        clusterAnnotation.interface = clusterAnnotationSpy
        
        let annotations = clusterAnnotation.multipleAnnotationModels.map({ $0.value })
        let annotation = annotations.first!
        let previousAnnotation = annotations.last!
        previousAnnotation.isSelected = true
        
        let request = STPhotoMapModels.PhotoAnnotationSelection.Request(photoAnnotation: annotation, previousPhotoAnnotation: previousAnnotation, photoClusterAnnotation: clusterAnnotation)
        self.sut.shouldSelectPhotoAnnotation(request: request)
        
        XCTAssertTrue(annotation.isSelected)
        XCTAssertFalse(previousAnnotation.isSelected)
        XCTAssertTrue(clusterAnnotationSpy.setIsSelectedCalled)
        
        XCTAssertTrue(self.presenterSpy.presentLoadingStateCalled)
        XCTAssertTrue(self.workerSpy.getPhotoDetailsForPhotoAnnotationCalled)
        
        self.waitForWorker(delay: self.workerDelay)
        
        XCTAssertTrue(self.presenterSpy.presentNotLoadingStateCalled)
        XCTAssertTrue(self.presenterSpy.presentLocationOverlayCalled)
    }
    
    func testShouldSelectPhotoAnnotationWhenItIsNotSelectedAndEntityLevelIsLocationForFailureCase() {
        let worker = STPhotoMapWorkerFailureSpy(delegate: self.sut)
        worker.delay = self.workerDelay
        self.sut.worker = worker
        
        self.sut.entityLevelHandler.entityLevel = .location
        
        let annotations = STPhotoMapSeeds().photoAnnotations()
        let annotation = annotations.first!
        let previousAnnotation = annotations.last!
        previousAnnotation.isSelected = true
        
        let request = STPhotoMapModels.PhotoAnnotationSelection.Request(photoAnnotation: annotation, previousPhotoAnnotation: previousAnnotation, photoClusterAnnotation: nil)
        self.sut.shouldSelectPhotoAnnotation(request: request)
        
        XCTAssertTrue(annotation.isSelected)
        XCTAssertFalse(previousAnnotation.isSelected)
        
        XCTAssertTrue(self.presenterSpy.presentLoadingStateCalled)
        XCTAssertTrue(worker.getPhotoDetailsForPhotoAnnotationCalled)
        
        self.waitForWorker(delay: self.workerDelay)
        
        XCTAssertTrue(self.presenterSpy.presentNotLoadingStateCalled)
    }
    
    func testShouldSelectPhotoAnnotationFromClusterWhenItIsNotSelectedAndEntityLevelIsLocationForFailureCase() {
        let worker = STPhotoMapWorkerFailureSpy(delegate: self.sut)
        worker.delay = self.workerDelay
        self.sut.worker = worker
        
        self.sut.entityLevelHandler.entityLevel = .location
        
        let clusterAnnotationSpy = MultiplePhotoClusterAnnotationInterfaceSpy()
        let clusterAnnotation = STPhotoMapSeeds().multiplePhotoClusterAnnotation(count: 10)
        clusterAnnotation.interface = clusterAnnotationSpy
        
        let annotations = clusterAnnotation.multipleAnnotationModels.map({ $0.value })
        let annotation = annotations.first!
        let previousAnnotation = annotations.last!
        previousAnnotation.isSelected = true
        
        let request = STPhotoMapModels.PhotoAnnotationSelection.Request(photoAnnotation: annotation, previousPhotoAnnotation: previousAnnotation, photoClusterAnnotation: clusterAnnotation)
        self.sut.shouldSelectPhotoAnnotation(request: request)
        
        XCTAssertTrue(annotation.isSelected)
        XCTAssertFalse(previousAnnotation.isSelected)
        XCTAssertTrue(clusterAnnotationSpy.setIsSelectedCalled)
        
        XCTAssertTrue(self.presenterSpy.presentLoadingStateCalled)
        XCTAssertTrue(worker.getPhotoDetailsForPhotoAnnotationCalled)
        
        self.waitForWorker(delay: self.workerDelay)
        
        XCTAssertTrue(self.presenterSpy.presentNotLoadingStateCalled)
    }
    
    func testShouldSelectPhotoAnnotationWhenItIsNotSelectedAndEntityLevelIsNotLocation() {
        self.sut.entityLevelHandler.entityLevel = .block
        
        let annotations = STPhotoMapSeeds().photoAnnotations()
        let annotation = annotations.first!
        let previousAnnotation = annotations.last!
        previousAnnotation.isSelected = true
        
        let request = STPhotoMapModels.PhotoAnnotationSelection.Request(photoAnnotation: annotation, previousPhotoAnnotation: previousAnnotation, photoClusterAnnotation: nil)
        self.sut.shouldSelectPhotoAnnotation(request: request)
        
        XCTAssertFalse(annotation.isSelected)
        XCTAssertTrue(previousAnnotation.isSelected)
        
        XCTAssertFalse(self.presenterSpy.presentLoadingStateCalled)
        XCTAssertFalse(self.workerSpy.getPhotoDetailsForPhotoAnnotationCalled)
    }
    
    func testShouldSelectPhotoAnnotationFromClusterWhenItIsNotSelectedAndEntityLevelIsNotLocation() {
        self.sut.entityLevelHandler.entityLevel = .block
        
        let clusterAnnotationSpy = MultiplePhotoClusterAnnotationInterfaceSpy()
        let clusterAnnotation = STPhotoMapSeeds().multiplePhotoClusterAnnotation(count: 10)
        clusterAnnotation.interface = clusterAnnotationSpy
        
        let annotations = clusterAnnotation.multipleAnnotationModels.map({ $0.value })
        let annotation = annotations.first!
        let previousAnnotation = annotations.last!
        previousAnnotation.isSelected = true
        
        let request = STPhotoMapModels.PhotoAnnotationSelection.Request(photoAnnotation: annotation, previousPhotoAnnotation: previousAnnotation, photoClusterAnnotation: clusterAnnotation)
        self.sut.shouldSelectPhotoAnnotation(request: request)
        
        XCTAssertFalse(annotation.isSelected)
        XCTAssertTrue(previousAnnotation.isSelected)
        XCTAssertFalse(clusterAnnotationSpy.setIsSelectedCalled)
        
        XCTAssertFalse(self.presenterSpy.presentLoadingStateCalled)
        XCTAssertFalse(self.workerSpy.getPhotoDetailsForPhotoAnnotationCalled)
    }
    
    func testShouldSelectPhotoAnnotationWhenItIsNotSelectedAndEntityLevelWillChangeForSuccessCase() {
        self.sut.entityLevelHandler.entityLevel = .location
        self.workerSpy.delay = self.workerDelay
        
        let annotations = STPhotoMapSeeds().photoAnnotations()
        let annotation = annotations.first!
        let previousAnnotation = annotations.last!
        previousAnnotation.isSelected = true
        
        let request = STPhotoMapModels.PhotoAnnotationSelection.Request(photoAnnotation: annotation, previousPhotoAnnotation: previousAnnotation, photoClusterAnnotation: nil)
        self.sut.shouldSelectPhotoAnnotation(request: request)
        
        XCTAssertTrue(annotation.isSelected)
        XCTAssertFalse(previousAnnotation.isSelected)
        
        XCTAssertTrue(self.presenterSpy.presentLoadingStateCalled)
        XCTAssertTrue(self.workerSpy.getPhotoDetailsForPhotoAnnotationCalled)
        
        self.wait(delay: self.delay)
        
        self.sut.entityLevelHandler.entityLevel = .block
        
        XCTAssertFalse(self.presenterSpy.presentNotLoadingStateCalled)
        XCTAssertFalse(self.presenterSpy.presentLocationOverlayCalled)
    }
    
    func testShouldSelectPhotoAnnotationFromClusterWhenItIsNotSelectedAndEntityLevelWillChangeForSuccessCase() {
        self.sut.entityLevelHandler.entityLevel = .location
        self.workerSpy.delay = self.workerDelay
        
        let clusterAnnotationSpy = MultiplePhotoClusterAnnotationInterfaceSpy()
        let clusterAnnotation = STPhotoMapSeeds().multiplePhotoClusterAnnotation(count: 10)
        clusterAnnotation.interface = clusterAnnotationSpy
        
        let annotations = clusterAnnotation.multipleAnnotationModels.map({ $0.value })
        let annotation = annotations.first!
        let previousAnnotation = annotations.last!
        previousAnnotation.isSelected = true
        
        let request = STPhotoMapModels.PhotoAnnotationSelection.Request(photoAnnotation: annotation, previousPhotoAnnotation: previousAnnotation, photoClusterAnnotation: clusterAnnotation)
        self.sut.shouldSelectPhotoAnnotation(request: request)
        
        XCTAssertTrue(annotation.isSelected)
        XCTAssertFalse(previousAnnotation.isSelected)
        XCTAssertTrue(clusterAnnotationSpy.setIsSelectedCalled)
        
        XCTAssertTrue(self.presenterSpy.presentLoadingStateCalled)
        XCTAssertTrue(self.workerSpy.getPhotoDetailsForPhotoAnnotationCalled)
        
        self.wait(delay: self.delay)
        
        self.sut.entityLevelHandler.entityLevel = .block
        
        XCTAssertFalse(self.presenterSpy.presentNotLoadingStateCalled)
        XCTAssertFalse(self.presenterSpy.presentLocationOverlayCalled)
    }
    
    // MARK: - Photo cluster annotation selection
    
    func testShouldSelectPhotoClusterAnnotationWhenZoomLevelIsMaximumAndThereAreOver15ClusterPhotos() {
        let zoomLevel = 20
        
        let clusterAnnotation = STPhotoMapSeeds().multiplePhotoClusterAnnotation(count: 20)
        let previousClusterAnnotation = STPhotoMapSeeds().multiplePhotoClusterAnnotation(count: 5)
        
        let request = STPhotoMapModels.PhotoClusterAnnotationSelection.Request(clusterAnnotation: clusterAnnotation, previousClusterAnnotation: previousClusterAnnotation, zoomLevel: zoomLevel)
        self.sut.shouldSelectPhotoClusterAnnotation(request: request)
        
        XCTAssertTrue(self.presenterSpy.presentNavigateToSpecificPhotosCalled)
    }
    
    func testShouldSelectPhotoClusterAnnotationWhenZoomLevelIsMaximumAndThereAreUnder15ClusterPhotosWithTheSameLocation() {
        self.workerSpy.delay = self.workerDelay
        let zoomLevel = 20
        
        let clusterAnnotationInterfaceSpy = MultiplePhotoClusterAnnotationInterfaceSpy()
        let clusterAnnotation = STPhotoMapSeeds().multiplePhotoClusterAnnotation(count: 10)
        clusterAnnotation.interface = clusterAnnotationInterfaceSpy
        
        let previousClusterAnnotationInterfaceSpy = MultiplePhotoClusterAnnotationInterfaceSpy()
        let previousClusterAnnotation = STPhotoMapSeeds().multiplePhotoClusterAnnotation(count: 5)
        previousClusterAnnotation.interface = previousClusterAnnotationInterfaceSpy
        
        let request = STPhotoMapModels.PhotoClusterAnnotationSelection.Request(clusterAnnotation: clusterAnnotation, previousClusterAnnotation: previousClusterAnnotation, zoomLevel: zoomLevel)
        self.sut.shouldSelectPhotoClusterAnnotation(request: request)
        
        XCTAssertTrue(self.workerSpy.downloadImageForPhotoAnnotationCalled)
        
        XCTAssertTrue(previousClusterAnnotationInterfaceSpy.deflateCalled)
        XCTAssertTrue(clusterAnnotationInterfaceSpy.inflateCalled)
        
        clusterAnnotation.multipleAnnotationModels.forEach { (key, value) in
            XCTAssertTrue(value.isLoading)
            XCTAssertNil(value.image)
        }
        
        XCTAssertTrue(clusterAnnotationInterfaceSpy.setIsLoadingCalled)
        
        self.waitForWorker(delay: self.workerDelay)
        
        clusterAnnotation.multipleAnnotationModels.forEach { (key, value) in
            XCTAssertFalse(value.isLoading)
            XCTAssertNotNil(value.image)
        }
        
        XCTAssertTrue(clusterAnnotationInterfaceSpy.setImageCalled)
        XCTAssertTrue(clusterAnnotationInterfaceSpy.setIsLoadingCalled)
    }
    
    func testShouldSelectPhotoClusterAnnotationWhenZoomLevelIsNotMaximumAndThereAreUnder15ClusterPhotosWithTheSameLocation() {
        self.workerSpy.delay = self.workerDelay
        let zoomLevel = 17
        
        let clusterAnnotationInterfaceSpy = MultiplePhotoClusterAnnotationInterfaceSpy()
        let clusterAnnotation = STPhotoMapSeeds().multiplePhotoClusterAnnotation(count: 10)
        clusterAnnotation.interface = clusterAnnotationInterfaceSpy
        
        let previousClusterAnnotationInterfaceSpy = MultiplePhotoClusterAnnotationInterfaceSpy()
        let previousClusterAnnotation = STPhotoMapSeeds().multiplePhotoClusterAnnotation(count: 5)
        previousClusterAnnotation.interface = previousClusterAnnotationInterfaceSpy
        
        let request = STPhotoMapModels.PhotoClusterAnnotationSelection.Request(clusterAnnotation: clusterAnnotation, previousClusterAnnotation: previousClusterAnnotation, zoomLevel: zoomLevel)
        self.sut.shouldSelectPhotoClusterAnnotation(request: request)
        
        XCTAssertTrue(self.workerSpy.downloadImageForPhotoAnnotationCalled)
        
        XCTAssertTrue(previousClusterAnnotationInterfaceSpy.deflateCalled)
        XCTAssertTrue(clusterAnnotationInterfaceSpy.inflateCalled)
        
        clusterAnnotation.multipleAnnotationModels.forEach { (key, value) in
            XCTAssertTrue(value.isLoading)
            XCTAssertNil(value.image)
        }
        
        XCTAssertTrue(clusterAnnotationInterfaceSpy.setIsLoadingCalled)
        
        self.waitForWorker(delay: self.workerDelay)
        
        clusterAnnotation.multipleAnnotationModels.forEach { (key, value) in
            XCTAssertFalse(value.isLoading)
            XCTAssertNotNil(value.image)
        }
        
        XCTAssertTrue(clusterAnnotationInterfaceSpy.setImageCalled)
        XCTAssertTrue(clusterAnnotationInterfaceSpy.setIsLoadingCalled)
    }
    
    func testShouldSelectPhotoClusterAnnotationWhenZoomLevelIsNotMaximumAndClusterPhotosWithDifferentLocation() {
        let zoomLevel = 17
        
        let clusterAnnotation = STPhotoMapSeeds().multiplePhotoClusterAnnotation(count: 10, sameCoordinate: false)
        let previousClusterAnnotation = STPhotoMapSeeds().multiplePhotoClusterAnnotation(count: 5)
        
        let request = STPhotoMapModels.PhotoClusterAnnotationSelection.Request(clusterAnnotation: clusterAnnotation, previousClusterAnnotation: previousClusterAnnotation, zoomLevel: zoomLevel)
        self.sut.shouldSelectPhotoClusterAnnotation(request: request)
        
        XCTAssertTrue(self.presenterSpy.presentZoomToCoordinateCalled)
    }
}
