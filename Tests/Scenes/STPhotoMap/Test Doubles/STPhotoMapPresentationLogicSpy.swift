//
//  STPhotoMapPresentationLogicSpy.swift
//  STPhotoMapTests-iOS
//
//  Created by Dimitri Strauneanu on 10/05/2019.
//  Copyright © 2019 mikelanza. All rights reserved.
//

@testable import STPhotoMap

class STPhotoMapPresentationLogicSpy: STPhotoMapPresentationLogic {
    var presentLoadingStateCalled: Bool = false
    var presentNotLoadingStateCalled: Bool = false
    var presentEntityLevelCalled: Bool = false
    
    func presentLoadingState() {
        self.presentLoadingStateCalled = true
    }
    
    func presentNotLoadingState() {
        self.presentNotLoadingStateCalled = true
    }
    
    func presentEntityLevel(response: STPhotoMapModels.EntityZoomLevel.Response) {
        self.presentEntityLevelCalled = true
    }
}
