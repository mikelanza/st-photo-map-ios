//
//  STPhotoMapWorkerSpy.swift
//  STPhotoMapTests-iOS
//
//  Created by Dimitri Strauneanu on 10/05/2019.
//  Copyright © 2019 mikelanza. All rights reserved.
//

@testable import STPhotoMap

class STPhotoMapWorkerSpy: STPhotoMapWorker {
    var getGeojsonTileForCachingCalled: Bool = false
    var getGeojsonTileForEntityLevelCalled: Bool = false
    
    override func getGeojsonTileForCaching(tileCoordinate: TileCoordinate, keyUrl: String, downloadUrl: String) {
        self.getGeojsonTileForCachingCalled = true
    }
    
    override func getGeojsonEntityLevel(tileCoordinate: TileCoordinate, keyUrl: String, downloadUrl: String) {
        self.getGeojsonTileForEntityLevelCalled = true
    }
}

class STPhotoMapWorkerSuccessSpy: STPhotoMapWorker {
    var getGeojsonTileForCachingCalled: Bool = false
    var getGeojsonTileForEntityLevelCalled: Bool = false
    
    override func getGeojsonTileForCaching(tileCoordinate: TileCoordinate, keyUrl: String, downloadUrl: String) {
        self.getGeojsonTileForCachingCalled = true
    }
    
    override func getGeojsonEntityLevel(tileCoordinate: TileCoordinate, keyUrl: String, downloadUrl: String) {
        self.getGeojsonTileForEntityLevelCalled = true
        
        do {
            let geojsonObject = try STPhotoMapSeeds().geojsonObject()
            self.delegate?.successDidGetGeojsonTileForEntityLevel(tileCoordinate: tileCoordinate, keyUrl: keyUrl, downloadUrl: downloadUrl, geojsonObject: geojsonObject)
        } catch {
        }
    }
}

class STPhotoMapWorkerFailureSpy: STPhotoMapWorker {
    var getGeojsonTileForCachingCalled: Bool = false
    var getGeojsonTileForEntityLevelCalled: Bool = false
    
    override func getGeojsonTileForCaching(tileCoordinate: TileCoordinate, keyUrl: String, downloadUrl: String) {
        self.getGeojsonTileForCachingCalled = true
    }
    
    override func getGeojsonEntityLevel(tileCoordinate: TileCoordinate, keyUrl: String, downloadUrl: String) {
        self.getGeojsonTileForEntityLevelCalled = true
        self.delegate?.failureDidGetGeojsonTileForEntityLevel(tileCoordinate: tileCoordinate, keyUrl: keyUrl, downloadUrl: downloadUrl, error: OperationError.cannotParseResponse)
    }
}
