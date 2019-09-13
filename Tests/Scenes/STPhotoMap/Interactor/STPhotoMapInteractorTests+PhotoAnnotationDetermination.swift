//
//  STPhotoMapInteractorTests+PhotoAnnotationDetermination.swift
//  STPhotoMapTests-iOS
//
//  Created by Dimitri Strauneanu on 13/09/2019.
//  Copyright © 2019 mikelanza. All rights reserved.
//

@testable import STPhotoMap
import XCTest
import MapKit
import STPhotoCore

class STPhotoMapInteractorPhotoAnnotationDeterminationTests: XCTestCase {
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
    
    func testShouldDetermineSelectedPhotoAnnotationShouldAskThePresenterToPresentDeselectPhotoAnnotationWhenCacheIsNotEmptyAndCurrentSelectedPhotoAnnotationIsNotVisible() throws {
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
        
        self.sut.shouldDetermineSelectedPhotoAnnotation()
        XCTAssertTrue(self.presenterSpy.presentDeselectPhotoAnnotationCalled)
    }
    
    func testShouldDetermineSelectedPhotoAnnotationShouldAskThePresenterToPresentNewSelectedPhotoAnnotationWhenCacheIsNotEmptyAndCurrentSelectedPhotoAnnotationIsNotVisible() throws {
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
        
        self.sut.shouldDetermineSelectedPhotoAnnotation()
        XCTAssertTrue(self.presenterSpy.presentNewSelectedPhotoAnnotationCalled)
    }
    
    func testShouldDetermineSelectedPhotoAnnotationShouldAskThePresenterToPresentLoadingStateWhenCacheIsNotEmptyAndCurrentSelectedPhotoAnnotationIsNotVisible() throws {
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
        
        self.sut.shouldDetermineSelectedPhotoAnnotation()
        XCTAssertTrue(self.presenterSpy.presentLoadingStateCalled)
    }
    
    func testShouldDetermineSelectedPhotoAnnotationShouldAskTheWorkerToGetPhotoDetailsForPhotoAnnotationWhenCacheIsNotEmptyAndCurrentSelectedPhotoAnnotationIsNotVisible() throws {
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
        
        self.sut.shouldDetermineSelectedPhotoAnnotation()
        XCTAssertTrue(self.workerSpy.getPhotoDetailsForPhotoAnnotationCalled)
    }
}
