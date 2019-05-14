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

class STPhotoMapWorkerSuccessWithAsyncSpy: STPhotoMapWorker {
    var getGeojsonTileForCachingCalled: Bool = false
    var getGeojsonTileForEntityLevelCalled: Bool = false
    
    override func getGeojsonTileForCaching(tileCoordinate: TileCoordinate, keyUrl: String, downloadUrl: String) {
        self.getGeojsonTileForCachingCalled = true
    }
    
    override func getGeojsonEntityLevel(tileCoordinate: TileCoordinate, keyUrl: String, downloadUrl: String) {
        self.getGeojsonTileForEntityLevelCalled = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + Double.random(in: 1..<5)) {
            //self.delegate?.successDidGetGeojsonTileForEntityLevel(tileCoordinate: tileCoordinate, keyUrl: keyUrl, downloadUrl: downloadUrl, geojsonObject: GeoJSON().parse(geoJSON: [:])!)
        }
    }
}
