//
//  STPhotoMapInteractorTests+EntityHandlerDelegate.swift
//  STPhotoMapTests-iOS
//
//  Created by Dimitri Strauneanu on 13/09/2019.
//  Copyright © 2019 Streetography. All rights reserved.
//

@testable import STPhotoMap
import XCTest
import MapKit
import STPhotoCore

class STPhotoMapInteractorEntityHandlerDelegateTests: XCTestCase {
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
    
    // MARK: - Tests for non location levels
    
    func testPhotoMapEntityLevelHandlerNewEntityLevelShouldAskTheWorkerToCancelAllGeojsonEntityLevelOperations() {
        self.sut.photoMapEntityLevelHandler(newEntityLevel: EntityLevel.block)
        XCTAssertTrue(self.workerSpy.cancelAllGeojsonEntityLevelOperationsCalled)
    }
    
    func testPhotoMapEntityLevelHandlerNewEntityLevelShouldAskTheWorkerToCancelAllGeojsonLocationLevelOperations() {
        self.sut.photoMapEntityLevelHandler(newEntityLevel: EntityLevel.block)
        XCTAssertTrue(self.workerSpy.cancelAllGeojsonLocationLevelOperationsCalled)
    }
    
    func testPhotoMapEntityLevelHandlerNewEntityLevelShouldAskThePresenterToPresentRemoveLocationAnnotations() {
        self.sut.worker = nil
        self.sut.photoMapEntityLevelHandler(newEntityLevel: EntityLevel.block)
        XCTAssertTrue(self.presenterSpy.presentRemoveLocationAnnotationsCalled)
    }
    
    func testPhotoMapEntityLevelHandlerNewEntityLevelShouldAskThePresenterToPresentRemoveLocationOverlay() {
        self.sut.worker = nil
        self.sut.photoMapEntityLevelHandler(newEntityLevel: EntityLevel.block)
        XCTAssertTrue(self.presenterSpy.presentRemoveLocationOverlayCalled)
    }
    
    func testPhotoMapEntityLevelHandlerNewEntityLevelShouldAskThePresenterToPresentRemoveCarousel() {
        self.sut.worker = nil
        self.sut.photoMapEntityLevelHandler(newEntityLevel: EntityLevel.block)
        XCTAssertTrue(self.presenterSpy.presentRemoveCarouselCalled)
    }
    
    func testPhotoMapEntityLevelHandlerNewEntityLevelShouldAskThePresenterToPresentEntityLevel() {
        self.sut.worker = nil
        self.sut.photoMapEntityLevelHandler(newEntityLevel: EntityLevel.block)
        XCTAssertTrue(self.presenterSpy.presentEntityLevelCalled)
    }
    
    func testPhotoMapEntityLevelHandlerNewEntityLevelShouldResetCarousel() {
        self.sut.worker = nil
        let spy = STPhotoMapCarouselHandlerSpy()
        self.sut.carouselHandler = spy
        self.sut.photoMapEntityLevelHandler(newEntityLevel: EntityLevel.block)
        XCTAssertTrue(spy.resetCarouselCalled)
    }
    
    func testPhotoMapEntityLevelHandlerNewEntityLevelShouldAddActiveDownloadWhenCacheIsNotEmptyAndThereIsNoBestFeature() throws {
        let geojsonObject = try STPhotoMapSeeds().geojsonObject()
        self.workerSpy.geojsonObject = geojsonObject
        
        self.sut.cacheHandler.cache.addTile(tile: STPhotoMapGeojsonCache.Tile(keyUrl: "keyUrl", geojsonObject: geojsonObject))
        self.sut.visibleTiles = [STPhotoMapSeeds.tileCoordinate]
        
        let spy = STPhotoMapCarouselHandlerSpy()
        self.sut.carouselHandler = spy
        
        self.sut.photoMapEntityLevelHandler(newEntityLevel: EntityLevel.block)
        XCTAssertTrue(spy.addActiveDownloadCalled)
    }
    
    func testPhotoMapEntityLevelHandlerNewEntityLevelShouldAskTheWorkerToGetGeojsonTileForCarouselDeterminationWhenCacheIsNotEmptyAndThereIsNoBestFeature() throws {
        let geojsonObject = try STPhotoMapSeeds().geojsonObject()
        self.workerSpy.geojsonObject = geojsonObject
        
        self.sut.cacheHandler.cache.addTile(tile: STPhotoMapGeojsonCache.Tile(keyUrl: "keyUrl", geojsonObject: geojsonObject))
        self.sut.visibleTiles = [STPhotoMapSeeds.tileCoordinate]
        
        self.sut.photoMapEntityLevelHandler(newEntityLevel: EntityLevel.block)
        XCTAssertTrue(self.workerSpy.getGeojsonTileForCarouselDeterminationCalled)
    }
    
    func testPhotoMapEntityLevelHandlerNewEntityLevelShouldAskThePresenterToPresentLoadingStateWhenCacheIsNotEmptyAndThereIsBestFeature() throws {
        let geoEntity = try STPhotoMapSeeds().geoEntity()
        self.sut.carouselHandler.updateCarouselFor(geoEntity: geoEntity)
        
        let coordinate = CLLocationCoordinate2D(latitude: 37.896175586962535, longitude: -122.5092990375)
        let tileCoordinate = TileCoordinate(coordinate: coordinate, zoom: 13)
        
        let keyUrl = STPhotoMapUrlBuilder().geojsonTileUrl(tileCoordinate: tileCoordinate).keyUrl
        let geojsonObject = try STPhotoMapSeeds().geojsonObject()
        
        self.workerSpy.geoEntity = geoEntity
        
        self.sut.cacheHandler.removeAllActiveDownloads()
        self.sut.cacheHandler.cache.addTile(tile: STPhotoMapGeojsonCache.Tile(keyUrl: keyUrl, geojsonObject: geojsonObject))
        self.sut.visibleTiles = [tileCoordinate]
        self.sut.visibleMapRect = geoEntity.boundingBox.mapRect().offsetBy(dx: 10000, dy: 10000)
        
        self.sut.photoMapEntityLevelHandler(newEntityLevel: EntityLevel.block)
        XCTAssertTrue(self.presenterSpy.presentLoadingStateCalled)
    }
    
    func testPhotoMapEntityLevelHandlerNewEntityLevelShouldAskTheWorkerToCancelAllGeoEntityOperationsWhenCacheIsNotEmptyAndThereIsBestFeature() throws {
        let geoEntity = try STPhotoMapSeeds().geoEntity()
        self.sut.carouselHandler.updateCarouselFor(geoEntity: geoEntity)
        
        let coordinate = CLLocationCoordinate2D(latitude: 37.896175586962535, longitude: -122.5092990375)
        let tileCoordinate = TileCoordinate(coordinate: coordinate, zoom: 13)
        
        let keyUrl = STPhotoMapUrlBuilder().geojsonTileUrl(tileCoordinate: tileCoordinate).keyUrl
        let geojsonObject = try STPhotoMapSeeds().geojsonObject()
        
        self.workerSpy.geoEntity = geoEntity
        
        self.sut.cacheHandler.removeAllActiveDownloads()
        self.sut.cacheHandler.cache.addTile(tile: STPhotoMapGeojsonCache.Tile(keyUrl: keyUrl, geojsonObject: geojsonObject))
        self.sut.visibleTiles = [tileCoordinate]
        self.sut.visibleMapRect = geoEntity.boundingBox.mapRect().offsetBy(dx: 10000, dy: 10000)
        
        self.sut.photoMapEntityLevelHandler(newEntityLevel: EntityLevel.block)
        XCTAssertTrue(self.workerSpy.cancelAllGeoEntityOperationsCalled)
    }
    
    func testPhotoMapEntityLevelHandlerNewEntityLevelShouldAskTheWorkerToGetGeoEntityForEntityWhenCacheIsNotEmptyAndThereIsBestFeature() throws {
        let geoEntity = try STPhotoMapSeeds().geoEntity()
        self.sut.carouselHandler.updateCarouselFor(geoEntity: geoEntity)
        
        let coordinate = CLLocationCoordinate2D(latitude: 37.896175586962535, longitude: -122.5092990375)
        let tileCoordinate = TileCoordinate(coordinate: coordinate, zoom: 13)
        
        let keyUrl = STPhotoMapUrlBuilder().geojsonTileUrl(tileCoordinate: tileCoordinate).keyUrl
        let geojsonObject = try STPhotoMapSeeds().geojsonObject()
        
        self.workerSpy.geoEntity = geoEntity
        
        self.sut.cacheHandler.removeAllActiveDownloads()
        self.sut.cacheHandler.cache.addTile(tile: STPhotoMapGeojsonCache.Tile(keyUrl: keyUrl, geojsonObject: geojsonObject))
        self.sut.visibleTiles = [tileCoordinate]
        self.sut.visibleMapRect = geoEntity.boundingBox.mapRect().offsetBy(dx: 10000, dy: 10000)
        
        self.sut.photoMapEntityLevelHandler(newEntityLevel: EntityLevel.block)
        XCTAssertTrue(self.workerSpy.getGeoEntityForEntityCalled)
    }
    
    // MARK: - Tests for location levels
    
    func testPhotoMapEntityLevelHandlerLocationLevelShouldAskTheWorkerToCancelAllGeojsonEntityLevelOperations() {
        self.sut.photoMapEntityLevelHandler(location: EntityLevel.location)
        XCTAssertTrue(self.workerSpy.cancelAllGeojsonEntityLevelOperationsCalled)
    }
    
    func testPhotoMapEntityLevelHandlerLocationLevelShouldAskThePresenterToPresentRemoveCarousel() {
        self.sut.worker = nil
        self.sut.photoMapEntityLevelHandler(location: EntityLevel.location)
        XCTAssertTrue(self.presenterSpy.presentRemoveCarouselCalled)
    }
    
    func testPhotoMapEntityLevelHandlerLocationLevelShouldAskThePresenterToPresentEntityLevel() {
        self.sut.worker = nil
        self.sut.photoMapEntityLevelHandler(location: EntityLevel.location)
        XCTAssertTrue(self.presenterSpy.presentEntityLevelCalled)
    }
    
    func testPhotoMapEntityLevelHandlerLocationLevelShouldAskThePresenterToPresentLocationAnnotationsWhenTheCacheIsNotEmpty() throws {
        self.sut.entityLevelHandler.entityLevel = .location
        
        let tileCoordinate = STPhotoMapSeeds.tileCoordinate
        let keyUrl = STPhotoMapUrlBuilder().geojsonTileUrl(tileCoordinate: tileCoordinate).keyUrl
        let geojsonObject = try STPhotoMapSeeds().locationGeojsonObject()
        
        self.workerSpy.geojsonObject = geojsonObject
        self.workerSpy.photo = STPhotoMapSeeds().photo()
        
        self.sut.cacheHandler.cache.addTile(tile: STPhotoMapGeojsonCache.Tile(keyUrl: keyUrl, geojsonObject: geojsonObject))
        self.sut.visibleTiles = [tileCoordinate]
        
        self.sut.photoMapEntityLevelHandler(location: EntityLevel.location)
        XCTAssertTrue(self.presenterSpy.presentLocationAnnotationsCalled)
    }
    
    func testPhotoMapEntityLevelHandlerLocationLevelShouldAddActiveDownloadWhenTheCacheIsEmptyAndThereAreNoActiveDownloads() throws {
        self.sut.entityLevelHandler.entityLevel = .location
        
        let geojsonObject = try STPhotoMapSeeds().locationGeojsonObject()
        self.workerSpy.geojsonObject = geojsonObject
        self.workerSpy.photo = STPhotoMapSeeds().photo()
        
        let locationLevelHandler = STPhotoMapLocationLevelHandlerSpy()
        self.sut.locationLevelHandler = locationLevelHandler
        
        self.sut.locationLevelHandler.removeAllActiveDownloads()
        self.sut.cacheHandler.cache.removeAllTiles()
        self.sut.visibleTiles = [STPhotoMapSeeds.tileCoordinate]
        
        self.sut.photoMapEntityLevelHandler(location: EntityLevel.location)
        XCTAssertTrue(locationLevelHandler.addActiveDownloadCalled)
    }
    
    func testPhotoMapEntityLevelHandlerLocationLevelShouldAskTheWorkerToGetGeojsonLocationLevelWhenTheCacheIsNotEmptyAndThereAreNoActiveDownloads() throws {
        self.sut.entityLevelHandler.entityLevel = .location
        
        let tileCoordinate = STPhotoMapSeeds.tileCoordinate
        let keyUrl = STPhotoMapUrlBuilder().geojsonTileUrl(tileCoordinate: tileCoordinate).keyUrl
        let geojsonObject = try STPhotoMapSeeds().locationGeojsonObject()
        self.workerSpy.geojsonObject = geojsonObject
        self.workerSpy.photo = STPhotoMapSeeds().photo()
        
        self.sut.locationLevelHandler.removeAllActiveDownloads()
        self.sut.cacheHandler.cache.addTile(tile: STPhotoMapGeojsonCache.Tile(keyUrl: keyUrl, geojsonObject: geojsonObject))
        self.sut.visibleTiles = [tileCoordinate]
        
        self.sut.photoMapEntityLevelHandler(location: EntityLevel.location)
        XCTAssertTrue(self.workerSpy.getGeojsonLocationLevelCalled)
    }
    
    func testPhotoMapEntityLevelHandlerLocationLevelShouldNotAskTheWorkerToGetGeojsonLocationLevelWhenThereAreActiveDownloads() throws {
        self.sut.entityLevelHandler.entityLevel = .location
        
        let tileCoordinate = STPhotoMapSeeds.tileCoordinate
        let keyUrl = STPhotoMapUrlBuilder().geojsonTileUrl(tileCoordinate: tileCoordinate).keyUrl
        self.sut.locationLevelHandler.addActiveDownload(keyUrl)
        self.sut.visibleTiles = [STPhotoMapSeeds.tileCoordinate]
        
        self.sut.photoMapEntityLevelHandler(location: EntityLevel.location)
        XCTAssertFalse(self.workerSpy.getGeojsonLocationLevelCalled)
    }
    
    func testPhotoMapEntityLevelHandlerLocationLevelShouldAskThePresenterToPresentDeselectPhotoAnnotation() throws {
        self.sut.entityLevelHandler.entityLevel = .location
        
        let tileCoordinate = STPhotoMapSeeds.tileCoordinate
        
        self.workerSpy.geojsonObject = try STPhotoMapSeeds().locationGeojsonObject()
        self.workerSpy.photo = STPhotoMapSeeds().photo()
        
        self.sut.cacheHandler.removeAllActiveDownloads()
        self.sut.locationLevelHandler.removeAllActiveDownloads()
        self.sut.visibleTiles = [tileCoordinate]
        
        self.sut.photoMapEntityLevelHandler(location: EntityLevel.location)
        XCTAssertTrue(self.presenterSpy.presentDeselectPhotoAnnotationCalled)
    }
    
    func testPhotoMapEntityLevelHandlerLocationLevelShouldAskThePresenterToPresentNewSelectedPhotoAnnotation() throws {
        self.sut.entityLevelHandler.entityLevel = .location
        
        let tileCoordinate = STPhotoMapSeeds.tileCoordinate
        
        self.workerSpy.geojsonObject = try STPhotoMapSeeds().locationGeojsonObject()
        self.workerSpy.photo = STPhotoMapSeeds().photo()
        
        self.sut.cacheHandler.removeAllActiveDownloads()
        self.sut.locationLevelHandler.removeAllActiveDownloads()
        self.sut.visibleTiles = [tileCoordinate]
        
        self.sut.photoMapEntityLevelHandler(location: EntityLevel.location)
        XCTAssertTrue(self.presenterSpy.presentNewSelectedPhotoAnnotationCalled)
    }
    
    func testPhotoMapEntityLevelHandlerLocationLevelShouldAskThePresenterToPresentLoadingState() throws {
        self.sut.entityLevelHandler.entityLevel = .location
        
        let tileCoordinate = STPhotoMapSeeds.tileCoordinate
        
        self.workerSpy.geojsonObject = try STPhotoMapSeeds().locationGeojsonObject()
        self.workerSpy.photo = STPhotoMapSeeds().photo()
        
        self.sut.cacheHandler.removeAllActiveDownloads()
        self.sut.locationLevelHandler.removeAllActiveDownloads()
        self.sut.visibleTiles = [tileCoordinate]
        
        self.sut.photoMapEntityLevelHandler(location: EntityLevel.location)
        XCTAssertTrue(self.presenterSpy.presentLoadingStateCalled)
    }
    
    func testPhotoMapEntityLevelHandlerLocationLevelShouldAskTheWorkerToGetPhotoDetailsForPhotoAnnotation() throws {
        self.sut.entityLevelHandler.entityLevel = .location
        
        let tileCoordinate = STPhotoMapSeeds.tileCoordinate
        
        self.workerSpy.geojsonObject = try STPhotoMapSeeds().locationGeojsonObject()
        self.workerSpy.photo = STPhotoMapSeeds().photo()
        
        self.sut.cacheHandler.removeAllActiveDownloads()
        self.sut.locationLevelHandler.removeAllActiveDownloads()
        self.sut.visibleTiles = [tileCoordinate]
        
        self.sut.photoMapEntityLevelHandler(location: EntityLevel.location)
        XCTAssertTrue(self.workerSpy.getPhotoDetailsForPhotoAnnotationCalled)
    }
}
