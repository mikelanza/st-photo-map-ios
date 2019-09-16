//
//  STPhotoMapInteractorTests+CarouselReloading.swift
//  STPhotoMapTests-iOS
//
//  Created by Dimitri Strauneanu on 13/09/2019.
//  Copyright © 2019 Streetography. All rights reserved.
//

@testable import STPhotoMap
import XCTest
import MapKit
import STPhotoCore

class STPhotoMapInteractorCarouselReloadingTests: XCTestCase {
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
    
    func testShouldReloadCarouselShouldRemoveAllActiveDownloads() throws {
        self.workerSpy.geoEntity = try STPhotoMapSeeds().geoEntity()
        self.workerSpy.geojsonObject = try STPhotoMapSeeds().geojsonObject()
        
        let spy = STPhotoMapCarouselHandlerSpy()
        self.sut.carouselHandler = spy
        self.sut.shouldReloadCarousel()
        XCTAssertTrue(spy.removeAllActiveDownloadsCalled)
    }
    
    func testShouldReloadCarouselShouldResetCarousel() throws {
        self.workerSpy.geoEntity = try STPhotoMapSeeds().geoEntity()
        self.workerSpy.geojsonObject = try STPhotoMapSeeds().geojsonObject()
        
        let spy = STPhotoMapCarouselHandlerSpy()
        self.sut.carouselHandler = spy
        self.sut.shouldReloadCarousel()
        XCTAssertTrue(spy.resetCarouselCalled)
    }
    
    func testShouldReloadCarouselShouldAskThePresenterToPresentRemoveCarousel() throws {
        self.workerSpy.geoEntity = try STPhotoMapSeeds().geoEntity()
        self.workerSpy.geojsonObject = try STPhotoMapSeeds().geojsonObject()
        
        self.sut.shouldReloadCarousel()
        XCTAssertTrue(self.presenterSpy.presentRemoveCarouselCalled)
    }
    
    func testShouldReloadCarouselShouldAddActiveDownloadWhenCacheIsNotEmptyAndThereIsNoBestFeature() throws {
        self.sut.entityLevelHandler.entityLevel = .block
        
        let geojsonObject = try STPhotoMapSeeds().geojsonObject()
        self.workerSpy.geojsonObject = geojsonObject
        
        self.sut.cacheHandler.cache.addTile(tile: STPhotoMapGeojsonCache.Tile(keyUrl: "keyUrl", geojsonObject: geojsonObject))
        self.sut.visibleTiles = [STPhotoMapSeeds.tileCoordinate]
        
        let spy = STPhotoMapCarouselHandlerSpy()
        self.sut.carouselHandler = spy
        
        self.sut.shouldReloadCarousel()
        XCTAssertTrue(spy.addActiveDownloadCalled)
    }
    
    func testShouldReloadCarouselShouldAskTheWorkerToGetGeojsonTileForCarouselDeterminationWhenCacheIsNotEmptyAndThereIsNoBestFeature() throws {
        self.sut.entityLevelHandler.entityLevel = .block
        
        let geojsonObject = try STPhotoMapSeeds().geojsonObject()
        self.workerSpy.geojsonObject = geojsonObject
        
        self.sut.cacheHandler.cache.addTile(tile: STPhotoMapGeojsonCache.Tile(keyUrl: "keyUrl", geojsonObject: geojsonObject))
        self.sut.visibleTiles = [STPhotoMapSeeds.tileCoordinate]
        
        self.sut.shouldReloadCarousel()
        XCTAssertTrue(self.workerSpy.getGeojsonTileForCarouselDeterminationCalled)
    }
    
    func testShouldReloadCarouselShouldAskThePresenterToPresentLoadingStateWhenCacheIsNotEmptyAndThereIsBestFeature() throws {
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
        
        self.sut.shouldReloadCarousel()
        XCTAssertTrue(self.presenterSpy.presentLoadingStateCalled)
    }
    
    func testShouldReloadCarouselShouldAskTheWorkerToCancelAllGeoEntityOperationsWhenCacheIsNotEmptyAndThereIsBestFeature() throws {
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
        
        self.sut.shouldReloadCarousel()
        XCTAssertTrue(self.workerSpy.cancelAllGeoEntityOperationsCalled)
    }
    
    func testShouldReloadCarouselShouldAskTheWorkerToGetGeoEntityForEntityWhenCacheIsNotEmptyAndThereIsBestFeature() throws {
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
        
        self.sut.shouldReloadCarousel()
        XCTAssertTrue(self.workerSpy.getGeoEntityForEntityCalled)
    }
}
