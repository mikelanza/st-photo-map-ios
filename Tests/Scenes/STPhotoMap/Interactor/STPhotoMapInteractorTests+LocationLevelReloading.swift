//
//  STPhotoMapInteractorTests+LocationLevelReloading.swift
//  STPhotoMapTests-iOS
//
//  Created by Dimitri Strauneanu on 13/09/2019.
//  Copyright © 2019 Streetography. All rights reserved.
//

@testable import STPhotoMap
import XCTest
import MapKit
import STPhotoCore

class STPhotoMapInteractorLocationLevelReloadingTests: XCTestCase {
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
    
    func testShouldReloadLocationLevelShouldRemoveCurrentSelectedPhotoAnnotation() {
        self.sut.selectedPhotoAnnotation = STPhotoMapSeeds().photoAnnotation()
        self.sut.shouldReloadLocationLevel()
        XCTAssertNil(self.sut.selectedPhotoAnnotation)
    }
    
    func testShouldReloadLocationLevelShouldAskThePresenterToPresentRemoveLocationOverlay() {
        self.sut.selectedPhotoAnnotation = STPhotoMapSeeds().photoAnnotation()
        self.sut.shouldReloadLocationLevel()
        XCTAssertTrue(self.presenterSpy.presentRemoveLocationOverlayCalled)
    }
    
    func testShouldReloadLocationLevelShouldAskThePresenterToPresentRemoveLocationAnnotations() {
        self.sut.selectedPhotoAnnotation = STPhotoMapSeeds().photoAnnotation()
        self.sut.shouldReloadLocationLevel()
        XCTAssertTrue(self.presenterSpy.presentRemoveLocationAnnotationsCalled)
    }
    
    func testShouldReloadLocationLevelShouldAskThePresenterToPresentLocationAnnotationsWhenTheCacheIsNotEmpty() throws {
        self.sut.entityLevelHandler.entityLevel = .location
        
        let tileCoordinate = STPhotoMapSeeds.tileCoordinate
        let keyUrl = STPhotoMapUrlBuilder().geojsonTileUrl(tileCoordinate: tileCoordinate).keyUrl
        let geojsonObject = try STPhotoMapSeeds().locationGeojsonObject()
        
        self.workerSpy.geojsonObject = geojsonObject
        self.workerSpy.photo = STPhotoMapSeeds().photo()
        
        self.sut.cacheHandler.cache.addTile(tile: STPhotoMapGeojsonCache.Tile(keyUrl: keyUrl, geojsonObject: geojsonObject))
        self.sut.visibleTiles = [tileCoordinate]
        
        self.sut.shouldReloadLocationLevel()
        XCTAssertTrue(self.presenterSpy.presentLocationAnnotationsCalled)
    }
    
    func testShouldReloadLocationLevelShouldAddActiveDownloadWhenTheCacheIsEmptyAndThereAreNoActiveDownloads() throws {
        self.sut.entityLevelHandler.entityLevel = .location
        
        let geojsonObject = try STPhotoMapSeeds().locationGeojsonObject()
        self.workerSpy.geojsonObject = geojsonObject
        self.workerSpy.photo = STPhotoMapSeeds().photo()
        
        let locationLevelHandler = STPhotoMapLocationLevelHandlerSpy()
        self.sut.locationLevelHandler = locationLevelHandler
        
        self.sut.locationLevelHandler.removeAllActiveDownloads()
        self.sut.cacheHandler.cache.removeAllTiles()
        self.sut.visibleTiles = [STPhotoMapSeeds.tileCoordinate]
        
        self.sut.shouldReloadLocationLevel()
        XCTAssertTrue(locationLevelHandler.addActiveDownloadCalled)
    }
    
    func testShouldReloadLocationLevelShouldAskTheWorkerToGetGeojsonLocationLevelWhenTheCacheIsNotEmptyAndThereAreNoActiveDownloads() throws {
        self.sut.entityLevelHandler.entityLevel = .location
        
        let tileCoordinate = STPhotoMapSeeds.tileCoordinate
        let keyUrl = STPhotoMapUrlBuilder().geojsonTileUrl(tileCoordinate: tileCoordinate).keyUrl
        let geojsonObject = try STPhotoMapSeeds().locationGeojsonObject()
        self.workerSpy.geojsonObject = geojsonObject
        self.workerSpy.photo = STPhotoMapSeeds().photo()
        
        self.sut.locationLevelHandler.removeAllActiveDownloads()
        self.sut.cacheHandler.cache.addTile(tile: STPhotoMapGeojsonCache.Tile(keyUrl: keyUrl, geojsonObject: geojsonObject))
        self.sut.visibleTiles = [tileCoordinate]
        
        self.sut.shouldReloadLocationLevel()
        XCTAssertTrue(self.workerSpy.getGeojsonLocationLevelCalled)
    }
    
    func testShouldReloadLocationLevelShouldNotAskTheWorkerToGetGeojsonLocationLevelWhenThereAreActiveDownloads() throws {
        self.sut.entityLevelHandler.entityLevel = .location
        
        let tileCoordinate = STPhotoMapSeeds.tileCoordinate
        let keyUrl = STPhotoMapUrlBuilder().geojsonTileUrl(tileCoordinate: tileCoordinate).keyUrl
        self.sut.locationLevelHandler.addActiveDownload(keyUrl)
        self.sut.visibleTiles = [STPhotoMapSeeds.tileCoordinate]
        
        self.sut.shouldReloadLocationLevel()
        XCTAssertFalse(self.workerSpy.getGeojsonLocationLevelCalled)
    }
    
    func testShouldReloadLocationLevelShouldAskThePresenterToPresentDeselectPhotoAnnotation() throws {
        self.sut.entityLevelHandler.entityLevel = .location
        
        let tileCoordinate = STPhotoMapSeeds.tileCoordinate
        
        self.workerSpy.geojsonObject = try STPhotoMapSeeds().locationGeojsonObject()
        self.workerSpy.photo = STPhotoMapSeeds().photo()
        
        self.sut.cacheHandler.removeAllActiveDownloads()
        self.sut.locationLevelHandler.removeAllActiveDownloads()
        self.sut.visibleTiles = [tileCoordinate]
        
        self.sut.shouldReloadLocationLevel()
        XCTAssertTrue(self.presenterSpy.presentDeselectPhotoAnnotationCalled)
    }
    
    func testShouldReloadLocationLevelShouldAskThePresenterToPresentNewSelectedPhotoAnnotation() throws {
        self.sut.entityLevelHandler.entityLevel = .location
        
        let tileCoordinate = STPhotoMapSeeds.tileCoordinate
        
        self.workerSpy.geojsonObject = try STPhotoMapSeeds().locationGeojsonObject()
        self.workerSpy.photo = STPhotoMapSeeds().photo()
        
        self.sut.cacheHandler.removeAllActiveDownloads()
        self.sut.locationLevelHandler.removeAllActiveDownloads()
        self.sut.visibleTiles = [tileCoordinate]
        
        self.sut.shouldReloadLocationLevel()
        XCTAssertTrue(self.presenterSpy.presentNewSelectedPhotoAnnotationCalled)
    }
    
    func testShouldReloadLocationLevelShouldAskThePresenterToPresentLoadingState() throws {
        self.sut.entityLevelHandler.entityLevel = .location
        
        let tileCoordinate = STPhotoMapSeeds.tileCoordinate
        
        self.workerSpy.geojsonObject = try STPhotoMapSeeds().locationGeojsonObject()
        self.workerSpy.photo = STPhotoMapSeeds().photo()
        
        self.sut.cacheHandler.removeAllActiveDownloads()
        self.sut.locationLevelHandler.removeAllActiveDownloads()
        self.sut.visibleTiles = [tileCoordinate]
        
        self.sut.shouldReloadLocationLevel()
        XCTAssertTrue(self.presenterSpy.presentLoadingStateCalled)
    }
    
    func testShouldReloadLocationLevelShouldAskTheWorkerToGetPhotoDetailsForPhotoAnnotation() throws {
        self.sut.entityLevelHandler.entityLevel = .location
        
        let tileCoordinate = STPhotoMapSeeds.tileCoordinate
        
        self.workerSpy.geojsonObject = try STPhotoMapSeeds().locationGeojsonObject()
        self.workerSpy.photo = STPhotoMapSeeds().photo()
        
        self.sut.cacheHandler.removeAllActiveDownloads()
        self.sut.locationLevelHandler.removeAllActiveDownloads()
        self.sut.visibleTiles = [tileCoordinate]
        
        self.sut.shouldReloadLocationLevel()
        XCTAssertTrue(self.workerSpy.getPhotoDetailsForPhotoAnnotationCalled)
    }
    
    func testShouldReloadLocationLevelShouldAskThePresenterToPresentDeselectPhotoAnnotationWhenCacheIsNotEmptyAndCurrentSelectedPhotoAnnotationIsNotVisible() throws {
        let tileCoordinate = STPhotoMapSeeds.tileCoordinate
        let keyUrl = STPhotoMapUrlBuilder().geojsonTileUrl(tileCoordinate: tileCoordinate).keyUrl
        let geojsonObject = try STPhotoMapSeeds().locationGeojsonObject()
        
        self.workerSpy.photo = STPhotoMapSeeds().photo()
        self.workerSpy.geojsonObject = geojsonObject
        
        self.sut.cacheHandler.removeAllActiveDownloads()
        self.sut.cacheHandler.cache.addTile(tile: STPhotoMapGeojsonCache.Tile(keyUrl: keyUrl, geojsonObject: geojsonObject))
        self.sut.visibleTiles = [tileCoordinate]
        
        self.sut.entityLevelHandler.entityLevel = .location
        self.sut.selectedPhotoAnnotation = STPhotoMapSeeds().photoAnnotations().first
        self.sut.visibleMapRect = geojsonObject.objectBoundingBox!.mapRect()
        
        self.sut.shouldReloadLocationLevel()
        XCTAssertTrue(self.presenterSpy.presentDeselectPhotoAnnotationCalled)
    }
    
    func testShouldReloadLocationLevelShouldAskThePresenterToPresentNewSelectedPhotoAnnotationWhenCacheIsNotEmptyAndCurrentSelectedPhotoAnnotationIsNotVisible() throws {
        let tileCoordinate = STPhotoMapSeeds.tileCoordinate
        let keyUrl = STPhotoMapUrlBuilder().geojsonTileUrl(tileCoordinate: tileCoordinate).keyUrl
        let geojsonObject = try STPhotoMapSeeds().locationGeojsonObject()
        
        self.workerSpy.photo = STPhotoMapSeeds().photo()
        self.workerSpy.geojsonObject = geojsonObject
        
        self.sut.cacheHandler.removeAllActiveDownloads()
        self.sut.cacheHandler.cache.addTile(tile: STPhotoMapGeojsonCache.Tile(keyUrl: keyUrl, geojsonObject: geojsonObject))
        self.sut.visibleTiles = [tileCoordinate]
        
        self.sut.entityLevelHandler.entityLevel = .location
        self.sut.selectedPhotoAnnotation = STPhotoMapSeeds().photoAnnotations().first
        self.sut.visibleMapRect = geojsonObject.objectBoundingBox!.mapRect()
        
        self.sut.shouldReloadLocationLevel()
        XCTAssertTrue(self.presenterSpy.presentNewSelectedPhotoAnnotationCalled)
    }
    
    func testShouldReloadLocationLevelShouldAskThePresenterToPresentLoadingStateWhenCacheIsNotEmptyAndCurrentSelectedPhotoAnnotationIsNotVisible() throws {
        let tileCoordinate = STPhotoMapSeeds.tileCoordinate
        let keyUrl = STPhotoMapUrlBuilder().geojsonTileUrl(tileCoordinate: tileCoordinate).keyUrl
        let geojsonObject = try STPhotoMapSeeds().locationGeojsonObject()
        
        self.workerSpy.photo = STPhotoMapSeeds().photo()
        self.workerSpy.geojsonObject = geojsonObject
        
        self.sut.cacheHandler.removeAllActiveDownloads()
        self.sut.cacheHandler.cache.addTile(tile: STPhotoMapGeojsonCache.Tile(keyUrl: keyUrl, geojsonObject: geojsonObject))
        self.sut.visibleTiles = [tileCoordinate]
        
        self.sut.entityLevelHandler.entityLevel = .location
        self.sut.selectedPhotoAnnotation = STPhotoMapSeeds().photoAnnotations().first
        self.sut.visibleMapRect = geojsonObject.objectBoundingBox!.mapRect()
        
        self.sut.shouldReloadLocationLevel()
        XCTAssertTrue(self.presenterSpy.presentLoadingStateCalled)
    }
    
    func testShouldReloadLocationLevelShouldAskTheWorkerToGetPhotoDetailsForPhotoAnnotationWhenCacheIsNotEmptyAndCurrentSelectedPhotoAnnotationIsNotVisible() throws {
        let tileCoordinate = STPhotoMapSeeds.tileCoordinate
        let keyUrl = STPhotoMapUrlBuilder().geojsonTileUrl(tileCoordinate: tileCoordinate).keyUrl
        let geojsonObject = try STPhotoMapSeeds().locationGeojsonObject()
        
        self.workerSpy.photo = STPhotoMapSeeds().photo()
        self.workerSpy.geojsonObject = geojsonObject
        
        self.sut.cacheHandler.removeAllActiveDownloads()
        self.sut.cacheHandler.cache.addTile(tile: STPhotoMapGeojsonCache.Tile(keyUrl: keyUrl, geojsonObject: geojsonObject))
        self.sut.visibleTiles = [tileCoordinate]
        
        self.sut.entityLevelHandler.entityLevel = .location
        self.sut.selectedPhotoAnnotation = STPhotoMapSeeds().photoAnnotations().first
        self.sut.visibleMapRect = geojsonObject.objectBoundingBox!.mapRect()
        
        self.sut.shouldReloadLocationLevel()
        XCTAssertTrue(self.workerSpy.getPhotoDetailsForPhotoAnnotationCalled)
    }
}
