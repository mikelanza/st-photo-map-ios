//
//  STPhotoMapInteractorTests+CarouselSelection.swift
//  STPhotoMapTests-iOS
//
//  Created by Dimitri Strauneanu on 13/09/2019.
//  Copyright © 2019 mikelanza. All rights reserved.
//

@testable import STPhotoMap
import XCTest
import MapKit
import STPhotoCore

class STPhotoMapInteractorCarouselSelectionTests: XCTestCase {
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
    
    func testShouldSelectCarouselShouldAskThePresenterToPresentLoadingStateWhenCacheIsNotEmpty() throws {
        self.workerSpy.geoEntity = try STPhotoMapSeeds().geoEntity()
        self.workerSpy.image = UIImage()
        
        let coordinate = CLLocationCoordinate2D(latitude: 37.896175586962535, longitude: -122.5092990375)
        let tileCoordinate = TileCoordinate(coordinate: coordinate, zoom: 13)
        
        let keyUrl = STPhotoMapUrlBuilder().geojsonTileUrl(tileCoordinate: tileCoordinate).keyUrl
        let geojsonObject = try STPhotoMapSeeds().geojsonObject()
        
        self.sut.cacheHandler.removeAllActiveDownloads()
        self.sut.cacheHandler.cache.addTile(tile: STPhotoMapGeojsonCache.Tile(keyUrl: keyUrl, geojsonObject: geojsonObject))
        self.sut.visibleTiles = [tileCoordinate]
        
        self.sut.shouldSelectCarousel(request: STPhotoMapModels.CarouselSelection.Request(tileCoordinate: tileCoordinate, location: STLocation.from(coordinate: coordinate)))
        XCTAssertTrue(self.presenterSpy.presentLoadingStateCalled)
    }
    
    func testShouldSelectCarouselShouldAskTheWorkerToCancelAllGeoEntityOperationsWhenCacheIsNotEmpty() throws {
        self.workerSpy.geoEntity = try STPhotoMapSeeds().geoEntity()
        self.workerSpy.image = UIImage()
        
        let coordinate = CLLocationCoordinate2D(latitude: 37.896175586962535, longitude: -122.5092990375)
        let tileCoordinate = TileCoordinate(coordinate: coordinate, zoom: 13)
        
        let keyUrl = STPhotoMapUrlBuilder().geojsonTileUrl(tileCoordinate: tileCoordinate).keyUrl
        let geojsonObject = try STPhotoMapSeeds().geojsonObject()
        
        self.sut.cacheHandler.removeAllActiveDownloads()
        self.sut.cacheHandler.cache.addTile(tile: STPhotoMapGeojsonCache.Tile(keyUrl: keyUrl, geojsonObject: geojsonObject))
        self.sut.visibleTiles = [tileCoordinate]
        
        self.sut.shouldSelectCarousel(request: STPhotoMapModels.CarouselSelection.Request(tileCoordinate: tileCoordinate, location: STLocation.from(coordinate: coordinate)))
        XCTAssertTrue(self.workerSpy.cancelAllGeoEntityOperationsCalled)
    }
    
    func testShouldSelectCarouselShouldAskTheWorkerToGetGeoEntityForEntityWhenCacheIsNotEmpty() throws {
        self.workerSpy.geoEntity = try STPhotoMapSeeds().geoEntity()
        self.workerSpy.image = UIImage()
        
        let coordinate = CLLocationCoordinate2D(latitude: 37.896175586962535, longitude: -122.5092990375)
        let tileCoordinate = TileCoordinate(coordinate: coordinate, zoom: 13)
        
        let keyUrl = STPhotoMapUrlBuilder().geojsonTileUrl(tileCoordinate: tileCoordinate).keyUrl
        let geojsonObject = try STPhotoMapSeeds().geojsonObject()
        
        self.sut.cacheHandler.removeAllActiveDownloads()
        self.sut.cacheHandler.cache.addTile(tile: STPhotoMapGeojsonCache.Tile(keyUrl: keyUrl, geojsonObject: geojsonObject))
        self.sut.visibleTiles = [tileCoordinate]
        
        self.sut.shouldSelectCarousel(request: STPhotoMapModels.CarouselSelection.Request(tileCoordinate: tileCoordinate, location: STLocation.from(coordinate: coordinate)))
        XCTAssertTrue(self.workerSpy.getGeoEntityForEntityCalled)
    }
    
    func testShouldSelectCarouselShouldAskThePresenterToPresentLoadingStateWhenCacheIsEmpty() throws {
        self.workerSpy.geojsonObject = try STPhotoMapSeeds().geojsonObject()
        self.workerSpy.geoEntity = try STPhotoMapSeeds().geoEntity()
        self.workerSpy.image = UIImage()
        
        let coordinate = CLLocationCoordinate2D(latitude: 37.896175586962535, longitude: -122.5092990375)
        let tileCoordinate = TileCoordinate(coordinate: coordinate, zoom: 13)
        
        let request = STPhotoMapModels.CarouselSelection.Request(tileCoordinate: tileCoordinate, location: STLocation.from(coordinate: coordinate))
        self.sut.shouldSelectCarousel(request: request)
        XCTAssertTrue(self.presenterSpy.presentLoadingStateCalled)
    }
    
    func testShouldSelectCarouselShouldAskTheWorkerToCancelAllGeojsonCarouselSelectionOperationsWhenCacheIsEmpty() throws {
        self.workerSpy.geojsonObject = try STPhotoMapSeeds().geojsonObject()
        self.workerSpy.geoEntity = try STPhotoMapSeeds().geoEntity()
        self.workerSpy.image = UIImage()
        
        let coordinate = CLLocationCoordinate2D(latitude: 37.896175586962535, longitude: -122.5092990375)
        let tileCoordinate = TileCoordinate(coordinate: coordinate, zoom: 13)
        
        let request = STPhotoMapModels.CarouselSelection.Request(tileCoordinate: tileCoordinate, location: STLocation.from(coordinate: coordinate))
        self.sut.shouldSelectCarousel(request: request)
        XCTAssertTrue(self.workerSpy.cancelAllGeojsonCarouselSelectionOperationsCalled)
    }
    
    func testShouldSelectCarouselShouldAskTheWorkerToGetGeojsonTileForCarouselSelectionWhenCacheIsEmpty() throws {
        self.workerSpy.geojsonObject = try STPhotoMapSeeds().geojsonObject()
        self.workerSpy.geoEntity = try STPhotoMapSeeds().geoEntity()
        self.workerSpy.image = UIImage()
        
        let coordinate = CLLocationCoordinate2D(latitude: 37.896175586962535, longitude: -122.5092990375)
        let tileCoordinate = TileCoordinate(coordinate: coordinate, zoom: 13)
        
        let request = STPhotoMapModels.CarouselSelection.Request(tileCoordinate: tileCoordinate, location: STLocation.from(coordinate: coordinate))
        self.sut.shouldSelectCarousel(request: request)
        XCTAssertTrue(self.workerSpy.getGeojsonTileForCarouselSelectionCalled)
    }
}
