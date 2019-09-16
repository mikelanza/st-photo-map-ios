//
//  STPhotoMapInteractorTests+LocationLevel.swift
//  STPhotoMapTests-iOS
//
//  Created by Dimitri Strauneanu on 12/09/2019.
//  Copyright © 2019 Streetography. All rights reserved.
//

@testable import STPhotoMap
import XCTest
import MapKit
import STPhotoCore

class STPhotoMapInteractorLocationLevelTests: XCTestCase {
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
    
    func testShouldDetermineLocationLevelShouldAskThePresenterToPresentLocationAnnotationsWhenTheCacheIsNotEmpty() throws {
        self.sut.entityLevelHandler.entityLevel = .location
        
        let tileCoordinate = STPhotoMapSeeds.tileCoordinate
        let keyUrl = STPhotoMapUrlBuilder().geojsonTileUrl(tileCoordinate: tileCoordinate).keyUrl
        let geojsonObject = try STPhotoMapSeeds().locationGeojsonObject()
        
        self.workerSpy.geojsonObject = geojsonObject
        self.workerSpy.photo = STPhotoMapSeeds().photo()
        
        self.sut.cacheHandler.cache.addTile(tile: STPhotoMapGeojsonCache.Tile(keyUrl: keyUrl, geojsonObject: geojsonObject))
        self.sut.visibleTiles = [tileCoordinate]
        
        self.sut.shouldDetermineLocationLevel()
        XCTAssertTrue(self.presenterSpy.presentLocationAnnotationsCalled)
    }
    
    func testShouldDetermineLocationLevelShouldAddActiveDownloadWhenTheCacheIsEmptyAndThereAreNoActiveDownloads() throws {
        self.sut.entityLevelHandler.entityLevel = .location
        
        let geojsonObject = try STPhotoMapSeeds().locationGeojsonObject()
        self.workerSpy.geojsonObject = geojsonObject
        self.workerSpy.photo = STPhotoMapSeeds().photo()
        
        let locationLevelHandler = STPhotoMapLocationLevelHandlerSpy()
        self.sut.locationLevelHandler = locationLevelHandler
        
        self.sut.locationLevelHandler.removeAllActiveDownloads()
        self.sut.cacheHandler.cache.removeAllTiles()
        self.sut.visibleTiles = [STPhotoMapSeeds.tileCoordinate]
        
        self.sut.shouldDetermineLocationLevel()
        XCTAssertTrue(locationLevelHandler.addActiveDownloadCalled)
    }
    
    func testShouldDetermineLocationLevelShouldAskTheWorkerToGetGeojsonLocationLevelWhenTheCacheIsNotEmptyAndThereAreNoActiveDownloads() throws {
        self.sut.entityLevelHandler.entityLevel = .location
        
        let tileCoordinate = STPhotoMapSeeds.tileCoordinate
        let keyUrl = STPhotoMapUrlBuilder().geojsonTileUrl(tileCoordinate: tileCoordinate).keyUrl
        let geojsonObject = try STPhotoMapSeeds().locationGeojsonObject()
        self.workerSpy.geojsonObject = geojsonObject
        self.workerSpy.photo = STPhotoMapSeeds().photo()
        
        self.sut.locationLevelHandler.removeAllActiveDownloads()
        self.sut.cacheHandler.cache.addTile(tile: STPhotoMapGeojsonCache.Tile(keyUrl: keyUrl, geojsonObject: geojsonObject))
        self.sut.visibleTiles = [tileCoordinate]
        
        self.sut.shouldDetermineLocationLevel()
        XCTAssertTrue(self.workerSpy.getGeojsonLocationLevelCalled)
    }
    
    func testShouldDetermineLocationLevelShouldNotAskTheWorkerToGetGeojsonLocationLevelWhenThereAreActiveDownloads() throws {
        self.sut.entityLevelHandler.entityLevel = .location
        
        let tileCoordinate = STPhotoMapSeeds.tileCoordinate
        let keyUrl = STPhotoMapUrlBuilder().geojsonTileUrl(tileCoordinate: tileCoordinate).keyUrl
        self.sut.locationLevelHandler.addActiveDownload(keyUrl)
        self.sut.visibleTiles = [STPhotoMapSeeds.tileCoordinate]
        
        self.sut.shouldDetermineLocationLevel()
        XCTAssertFalse(self.workerSpy.getGeojsonLocationLevelCalled)
    }
    
    func testShouldDetermineLocationLevelShouldAskThePresenterToPresentDeselectPhotoAnnotation() throws {
        self.sut.entityLevelHandler.entityLevel = .location
        
        let tileCoordinate = STPhotoMapSeeds.tileCoordinate
        
        self.workerSpy.geojsonObject = try STPhotoMapSeeds().locationGeojsonObject()
        self.workerSpy.photo = STPhotoMapSeeds().photo()
        
        self.sut.cacheHandler.removeAllActiveDownloads()
        self.sut.locationLevelHandler.removeAllActiveDownloads()
        self.sut.visibleTiles = [tileCoordinate]
        
        self.sut.shouldDetermineLocationLevel()
        XCTAssertTrue(self.presenterSpy.presentDeselectPhotoAnnotationCalled)
    }
    
    func testShouldDetermineLocationLevelShouldAskThePresenterToPresentNewSelectedPhotoAnnotation() throws {
        self.sut.entityLevelHandler.entityLevel = .location
        
        let tileCoordinate = STPhotoMapSeeds.tileCoordinate
        
        self.workerSpy.geojsonObject = try STPhotoMapSeeds().locationGeojsonObject()
        self.workerSpy.photo = STPhotoMapSeeds().photo()
        
        self.sut.cacheHandler.removeAllActiveDownloads()
        self.sut.locationLevelHandler.removeAllActiveDownloads()
        self.sut.visibleTiles = [tileCoordinate]
        
        self.sut.shouldDetermineLocationLevel()
        XCTAssertTrue(self.presenterSpy.presentNewSelectedPhotoAnnotationCalled)
    }
    
    func testShouldDetermineLocationLevelShouldAskThePresenterToPresentLoadingState() throws {
        self.sut.entityLevelHandler.entityLevel = .location
        
        let tileCoordinate = STPhotoMapSeeds.tileCoordinate
        
        self.workerSpy.geojsonObject = try STPhotoMapSeeds().locationGeojsonObject()
        self.workerSpy.photo = STPhotoMapSeeds().photo()
        
        self.sut.cacheHandler.removeAllActiveDownloads()
        self.sut.locationLevelHandler.removeAllActiveDownloads()
        self.sut.visibleTiles = [tileCoordinate]
        
        self.sut.shouldDetermineLocationLevel()
        XCTAssertTrue(self.presenterSpy.presentLoadingStateCalled)
    }
    
    func testShouldDetermineLocationLevelShouldAskTheWorkerToGetPhotoDetailsForPhotoAnnotation() throws {
        self.sut.entityLevelHandler.entityLevel = .location
        
        let tileCoordinate = STPhotoMapSeeds.tileCoordinate
        
        self.workerSpy.geojsonObject = try STPhotoMapSeeds().locationGeojsonObject()
        self.workerSpy.photo = STPhotoMapSeeds().photo()
        
        self.sut.cacheHandler.removeAllActiveDownloads()
        self.sut.locationLevelHandler.removeAllActiveDownloads()
        self.sut.visibleTiles = [tileCoordinate]
        
        self.sut.shouldDetermineLocationLevel()
        XCTAssertTrue(self.workerSpy.getPhotoDetailsForPhotoAnnotationCalled)
    }
    
    func testSuccessDidGetGeojsonTileForLocationLevelShouldRemoveLocationLevelActiveDownload() throws {
        self.sut.locationLevelHandler.removeAllActiveDownloads()
        
        let tileCoordinate = STPhotoMapSeeds.tileCoordinate
        let keyUrl = "keyUrl"
        let downloadUrl = "downloadUrl"
        let geojsonObject = try STPhotoMapSeeds().locationGeojsonObject()
        self.sut.locationLevelHandler.addActiveDownload(keyUrl)
        self.sut.successDidGetGeojsonTileForLocationLevel(tileCoordinate: tileCoordinate, keyUrl: keyUrl, downloadUrl: downloadUrl, geojsonObject: geojsonObject)
        
        XCTAssertEqual(self.sut.locationLevelHandler.activeDownloads.count, 0)
    }
    
    func testSuccessDidGetGeojsonTileForLocationLevelShouldAskThePresenterToPresentLocationAnnotations() throws {
        self.sut.entityLevelHandler.entityLevel = .location
        
        self.workerSpy.photo = STPhotoMapSeeds().photo()
        
        let tileCoordinate = STPhotoMapSeeds.tileCoordinate
        let keyUrl = "keyUrl"
        let downloadUrl = "downloadUrl"
        let geojsonObject = try STPhotoMapSeeds().locationGeojsonObject()
        self.sut.successDidGetGeojsonTileForLocationLevel(tileCoordinate: tileCoordinate, keyUrl: keyUrl, downloadUrl: downloadUrl, geojsonObject: geojsonObject)
        
        XCTAssertTrue(self.presenterSpy.presentLocationAnnotationsCalled)
    }
    
    func testSuccessDidGetGeojsonTileForLocationLevelShouldAskThePresenterToPresentDeselectPhotoAnnotationWhenCacheIsNotEmptyAndCurrentSelectedPhotoAnnotationIsNotVisible() throws {
        self.workerSpy.photo = STPhotoMapSeeds().photo()
        
        let tileCoordinate = STPhotoMapSeeds.tileCoordinate
        let keyUrl = STPhotoMapUrlBuilder().geojsonTileUrl(tileCoordinate: tileCoordinate).keyUrl
        let geojsonObject = try STPhotoMapSeeds().locationGeojsonObject()
        
        self.sut.cacheHandler.removeAllActiveDownloads()
        self.sut.cacheHandler.cache.addTile(tile: STPhotoMapGeojsonCache.Tile(keyUrl: keyUrl, geojsonObject: geojsonObject))
        self.sut.visibleTiles = [tileCoordinate]
        
        self.sut.entityLevelHandler.entityLevel = .location
        self.sut.selectedPhotoAnnotation = STPhotoMapSeeds().photoAnnotations().first
        self.sut.visibleMapRect = geojsonObject.objectBoundingBox!.mapRect()
        
        self.sut.successDidGetGeojsonTileForLocationLevel(tileCoordinate: tileCoordinate, keyUrl: keyUrl, downloadUrl: "downloadUrl", geojsonObject: geojsonObject)
        XCTAssertTrue(self.presenterSpy.presentDeselectPhotoAnnotationCalled)
    }
    
    func testSuccessDidGetGeojsonTileForLocationLevelShouldAskThePresenterToPresentNewSelectedPhotoAnnotationWhenCacheIsNotEmptyAndCurrentSelectedPhotoAnnotationIsNotVisible() throws {
        self.workerSpy.photo = STPhotoMapSeeds().photo()
        
        let tileCoordinate = STPhotoMapSeeds.tileCoordinate
        let keyUrl = STPhotoMapUrlBuilder().geojsonTileUrl(tileCoordinate: tileCoordinate).keyUrl
        let geojsonObject = try STPhotoMapSeeds().locationGeojsonObject()
        
        self.sut.cacheHandler.removeAllActiveDownloads()
        self.sut.cacheHandler.cache.addTile(tile: STPhotoMapGeojsonCache.Tile(keyUrl: keyUrl, geojsonObject: geojsonObject))
        self.sut.visibleTiles = [tileCoordinate]
        
        self.sut.entityLevelHandler.entityLevel = .location
        self.sut.selectedPhotoAnnotation = STPhotoMapSeeds().photoAnnotations().first
        self.sut.visibleMapRect = geojsonObject.objectBoundingBox!.mapRect()
        
        self.sut.successDidGetGeojsonTileForLocationLevel(tileCoordinate: tileCoordinate, keyUrl: keyUrl, downloadUrl: "downloadUrl", geojsonObject: geojsonObject)
        XCTAssertTrue(self.presenterSpy.presentNewSelectedPhotoAnnotationCalled)
    }
    
    func testSuccessDidGetGeojsonTileForLocationLevelShouldAskThePresenterToPresentLoadingStateWhenCacheIsNotEmptyAndCurrentSelectedPhotoAnnotationIsNotVisible() throws {
        self.workerSpy.photo = STPhotoMapSeeds().photo()
        
        let tileCoordinate = STPhotoMapSeeds.tileCoordinate
        let keyUrl = STPhotoMapUrlBuilder().geojsonTileUrl(tileCoordinate: tileCoordinate).keyUrl
        let geojsonObject = try STPhotoMapSeeds().locationGeojsonObject()
        
        self.sut.cacheHandler.removeAllActiveDownloads()
        self.sut.cacheHandler.cache.addTile(tile: STPhotoMapGeojsonCache.Tile(keyUrl: keyUrl, geojsonObject: geojsonObject))
        self.sut.visibleTiles = [tileCoordinate]
        
        self.sut.entityLevelHandler.entityLevel = .location
        self.sut.selectedPhotoAnnotation = STPhotoMapSeeds().photoAnnotations().first
        self.sut.visibleMapRect = geojsonObject.objectBoundingBox!.mapRect()
        
        self.sut.successDidGetGeojsonTileForLocationLevel(tileCoordinate: tileCoordinate, keyUrl: keyUrl, downloadUrl: "downloadUrl", geojsonObject: geojsonObject)
        XCTAssertTrue(self.presenterSpy.presentLoadingStateCalled)
    }
    
    func testSuccessDidGetGeojsonTileForLocationLevelShouldAskTheWorkerToGetPhotoDetailsForPhotoAnnotationWhenCacheIsNotEmptyAndCurrentSelectedPhotoAnnotationIsNotVisible() throws {
        self.workerSpy.photo = STPhotoMapSeeds().photo()
        
        let tileCoordinate = STPhotoMapSeeds.tileCoordinate
        let keyUrl = STPhotoMapUrlBuilder().geojsonTileUrl(tileCoordinate: tileCoordinate).keyUrl
        let geojsonObject = try STPhotoMapSeeds().locationGeojsonObject()
        
        self.sut.cacheHandler.removeAllActiveDownloads()
        self.sut.cacheHandler.cache.addTile(tile: STPhotoMapGeojsonCache.Tile(keyUrl: keyUrl, geojsonObject: geojsonObject))
        self.sut.visibleTiles = [tileCoordinate]
        
        self.sut.entityLevelHandler.entityLevel = .location
        self.sut.selectedPhotoAnnotation = STPhotoMapSeeds().photoAnnotations().first
        self.sut.visibleMapRect = geojsonObject.objectBoundingBox!.mapRect()
        
        self.sut.successDidGetGeojsonTileForLocationLevel(tileCoordinate: tileCoordinate, keyUrl: keyUrl, downloadUrl: "downloadUrl", geojsonObject: geojsonObject)
        XCTAssertTrue(self.workerSpy.getPhotoDetailsForPhotoAnnotationCalled)
    }
    
    func testFailureDidGetGeojsonTileForLocationLevelShouldRemoveLocationLevelActiveDownload() throws {
        self.sut.locationLevelHandler.removeAllActiveDownloads()
        
        let tileCoordinate = STPhotoMapSeeds.tileCoordinate
        let keyUrl = "keyUrl"
        let downloadUrl = "downloadUrl"
        self.sut.locationLevelHandler.addActiveDownload(keyUrl)
        self.sut.failureDidGetGeojsonTileForLocationLevel(tileCoordinate: tileCoordinate, keyUrl: keyUrl, downloadUrl: downloadUrl, error: OperationError.noDataAvailable)
        
        XCTAssertEqual(self.sut.locationLevelHandler.activeDownloads.count, 0)
    }
}
