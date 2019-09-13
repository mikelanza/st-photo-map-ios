//
//  STPhotoMapInteractorTests+CarouselDetermination.swift
//  STPhotoMapTests-iOS
//
//  Created by Dimitri Strauneanu on 13/09/2019.
//  Copyright © 2019 mikelanza. All rights reserved.
//

@testable import STPhotoMap
import XCTest
import MapKit
import STPhotoCore

class STPhotoMapInteractorCarouselDeterminationTests: XCTestCase {
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
    
    func testShouldDetermineCarouselShouldAddActiveDownloadWhenCacheIsNotEmptyAndThereIsNoBestFeature() throws {
        self.sut.entityLevelHandler.entityLevel = .block
        
        let geojsonObject = try STPhotoMapSeeds().geojsonObject()
        self.workerSpy.geojsonObject = geojsonObject
        
        self.sut.cacheHandler.cache.addTile(tile: STPhotoMapGeojsonCache.Tile(keyUrl: "keyUrl", geojsonObject: geojsonObject))
        self.sut.visibleTiles = [STPhotoMapSeeds.tileCoordinate]
        
        let spy = STPhotoMapCarouselHandlerSpy()
        self.sut.carouselHandler = spy
        
        self.sut.shouldDetermineCarousel()
        XCTAssertTrue(spy.addActiveDownloadCalled)
    }
    
    func testShouldDetermineCarouselShouldAskTheWorkerToGetGeojsonTileForCarouselDeterminationWhenCacheIsNotEmptyAndThereIsNoBestFeature() throws {
        self.sut.entityLevelHandler.entityLevel = .block
        
        let geojsonObject = try STPhotoMapSeeds().geojsonObject()
        self.workerSpy.geojsonObject = geojsonObject
        
        self.sut.cacheHandler.cache.addTile(tile: STPhotoMapGeojsonCache.Tile(keyUrl: "keyUrl", geojsonObject: geojsonObject))
        self.sut.visibleTiles = [STPhotoMapSeeds.tileCoordinate]
        
        self.sut.shouldDetermineCarousel()
        XCTAssertTrue(self.workerSpy.getGeojsonTileForCarouselDeterminationCalled)
    }
    
    func testShouldDetermineCarouselShouldAskThePresenterToPresentLoadingStateWhenCacheIsNotEmptyAndThereIsBestFeature() throws {
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
        
        self.sut.shouldDetermineCarousel()
        XCTAssertTrue(self.presenterSpy.presentLoadingStateCalled)
    }
    
    func testShouldDetermineCarouselShouldAskTheWorkerToCancelAllGeoEntityOperationsWhenCacheIsNotEmptyAndThereIsBestFeature() throws {
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
        
        self.sut.shouldDetermineCarousel()
        XCTAssertTrue(self.workerSpy.cancelAllGeoEntityOperationsCalled)
    }
    
    func testShouldDetermineCarouselShouldAskTheWorkerToGetGeoEntityForEntityWhenCacheIsNotEmptyAndThereIsBestFeature() throws {
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
        
        self.sut.shouldDetermineCarousel()
        XCTAssertTrue(self.workerSpy.getGeoEntityForEntityCalled)
    }
    
    func testSuccessDidGetGeojsonTileForCarouselDeterminationShouldRemoveActiveDownload() throws {
        let geojsonObject = try STPhotoMapSeeds().geojsonObject()
        let spy = STPhotoMapCarouselHandlerSpy()
        self.sut.carouselHandler = spy
        self.sut.successDidGetGeojsonTileForCarouselDetermination(tileCoordinate: STPhotoMapSeeds.tileCoordinate, keyUrl: "keyUrl", downloadUrl: "downloadUrl", geojsonObject: geojsonObject)
        XCTAssertTrue(spy.removeActiveDownloadCalled)
    }
    
    func testSuccessDidGetGeojsonTileForCarouselDeterminationShouldAskTheWorkerToCancelAllGeojsonTileForCarouselDeterminationOperationsWhenFeatureFulfillsOverlayConditions() throws {
        let geojsonObject = try STPhotoMapSeeds().geojsonObject()
        
        self.workerSpy.geojsonObject = geojsonObject
        self.workerSpy.geoEntity = try STPhotoMapSeeds().geoEntity()
        
        let tileCoordinate = STPhotoMapSeeds.tileCoordinate
        self.sut.cacheHandler.removeAllActiveDownloads()
        self.sut.visibleTiles = [tileCoordinate]
        self.sut.visibleMapRect = geojsonObject.objectBoundingBox!.mapRect()
        
        self.sut.successDidGetGeojsonTileForCarouselDetermination(tileCoordinate: STPhotoMapSeeds.tileCoordinate, keyUrl: "keyUrl", downloadUrl: "downloadUrl", geojsonObject: geojsonObject)
        XCTAssertTrue(self.workerSpy.cancelAllGeojsonCarouselDeterminationOperationsCalled)
    }
    
    func testSuccessDidGetGeojsonTileForCarouselDeterminationShouldRemoveAllActiveDownloadsWhenFeatureFulfillsOverlayConditions() throws {
        let geojsonObject = try STPhotoMapSeeds().geojsonObject()
        
        self.workerSpy.geojsonObject = geojsonObject
        self.workerSpy.geoEntity = try STPhotoMapSeeds().geoEntity()
        
        let tileCoordinate = STPhotoMapSeeds.tileCoordinate
        self.sut.cacheHandler.removeAllActiveDownloads()
        self.sut.visibleTiles = [tileCoordinate]
        self.sut.visibleMapRect = geojsonObject.objectBoundingBox!.mapRect()
        
        let spy = STPhotoMapCarouselHandlerSpy()
        self.sut.carouselHandler = spy
        self.sut.successDidGetGeojsonTileForCarouselDetermination(tileCoordinate: STPhotoMapSeeds.tileCoordinate, keyUrl: "keyUrl", downloadUrl: "downloadUrl", geojsonObject: geojsonObject)
        XCTAssertTrue(spy.removeAllActiveDownloadsCalled)
    }
    
    func testSuccessDidGetGeojsonTileForCarouselDeterminationShouldAskThePresenterToPresentLoadingStateWhenFeatureFulfillsOverlayConditions() throws {
        let geojsonObject = try STPhotoMapSeeds().geojsonObject()
        
        self.workerSpy.geojsonObject = geojsonObject
        self.workerSpy.geoEntity = try STPhotoMapSeeds().geoEntity()
        
        let tileCoordinate = STPhotoMapSeeds.tileCoordinate
        self.sut.cacheHandler.removeAllActiveDownloads()
        self.sut.visibleTiles = [tileCoordinate]
        self.sut.visibleMapRect = geojsonObject.objectBoundingBox!.mapRect()
        
        self.sut.successDidGetGeojsonTileForCarouselDetermination(tileCoordinate: STPhotoMapSeeds.tileCoordinate, keyUrl: "keyUrl", downloadUrl: "downloadUrl", geojsonObject: geojsonObject)
        XCTAssertTrue(self.presenterSpy.presentLoadingStateCalled)
    }
    
    func testSuccessDidGetGeojsonTileForCarouselDeterminationShouldAskTheWorkerToCancelAllGeoEntityOperationsWhenFeatureFulfillsOverlayConditions() throws {
        let geojsonObject = try STPhotoMapSeeds().geojsonObject()
        
        self.workerSpy.geojsonObject = geojsonObject
        self.workerSpy.geoEntity = try STPhotoMapSeeds().geoEntity()
        
        let tileCoordinate = STPhotoMapSeeds.tileCoordinate
        self.sut.cacheHandler.removeAllActiveDownloads()
        self.sut.visibleTiles = [tileCoordinate]
        self.sut.visibleMapRect = geojsonObject.objectBoundingBox!.mapRect()
        
        self.sut.successDidGetGeojsonTileForCarouselDetermination(tileCoordinate: STPhotoMapSeeds.tileCoordinate, keyUrl: "keyUrl", downloadUrl: "downloadUrl", geojsonObject: geojsonObject)
        XCTAssertTrue(self.workerSpy.cancelAllGeoEntityOperationsCalled)
    }
    
    func testSuccessDidGetGeojsonTileForCarouselDeterminationShouldAskTheWorkerToGetGeoEntityForEntityWhenFeatureFulfillsOverlayConditions() throws {
        let geojsonObject = try STPhotoMapSeeds().geojsonObject()
        
        self.workerSpy.geojsonObject = geojsonObject
        self.workerSpy.geoEntity = try STPhotoMapSeeds().geoEntity()
        
        let tileCoordinate = STPhotoMapSeeds.tileCoordinate
        self.sut.cacheHandler.removeAllActiveDownloads()
        self.sut.visibleTiles = [tileCoordinate]
        self.sut.visibleMapRect = geojsonObject.objectBoundingBox!.mapRect()
        
        self.sut.successDidGetGeojsonTileForCarouselDetermination(tileCoordinate: STPhotoMapSeeds.tileCoordinate, keyUrl: "keyUrl", downloadUrl: "downloadUrl", geojsonObject: geojsonObject)
        XCTAssertTrue(self.workerSpy.getGeoEntityForEntityCalled)
    }
    
    func testFailureDidGetGeojsonTileForCarouselDeterminationShouldRemoveActiveDownload() {
        let spy = STPhotoMapCarouselHandlerSpy()
        self.sut.carouselHandler = spy
        self.sut.failureDidGetGeojsonTileForCarouselDetermination(tileCoordinate: STPhotoMapSeeds.tileCoordinate, keyUrl: "keyUrl", downloadUrl: "downloadUrl", error: OperationError.noDataAvailable)
        XCTAssertTrue(spy.removeActiveDownloadCalled)
    }
}
