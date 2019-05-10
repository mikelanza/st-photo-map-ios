//
//  STPhotoMapBusinessLogicSpy.swift
//  STPhotoMapTests-iOS
//
//  Created by Dimitri Strauneanu on 10/05/2019.
//  Copyright © 2019 mikelanza. All rights reserved.
//

@testable import STPhotoMap

class STPhotoMapBusinessLogicSpy: STPhotoMapBusinessLogic {
    var shouldUpdateVisibleTilesCalled: Bool = false
    var shouldCacheGeojsonObjectsCalled: Bool = false

    func shouldUpdateVisibleTiles(request: STPhotoMapModels.VisibleTiles.Request) {
        self.shouldUpdateVisibleTilesCalled = true
    }
    
    func shouldCacheGeojsonObjects() {
        self.shouldCacheGeojsonObjectsCalled = true
    }
}
