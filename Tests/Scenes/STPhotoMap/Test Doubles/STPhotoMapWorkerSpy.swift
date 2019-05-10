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
    
    override func getGeojsonTileForCaching(tileCoordinate: TileCoordinate, keyUrl: String, downloadUrl: String) {
        self.getGeojsonTileForCachingCalled = true
    }
}
