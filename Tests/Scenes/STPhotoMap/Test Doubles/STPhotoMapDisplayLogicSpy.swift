//
//  STPhotoMapDisplayLogicSpy.swift
//  STPhotoMapTests-iOS
//
//  Created by Dimitri Strauneanu on 10/05/2019.
//  Copyright © 2019 mikelanza. All rights reserved.
//

@testable import STPhotoMap

class STPhotoMapDisplayLogicSpy: STPhotoMapDisplayLogic {
    var displayLoadingStateCalled: Bool = false
    var displayNotLoadingStateCalled: Bool = false
    var displayEntityLevelCalled: Bool = false
    
    func displayLoadingState() {
        self.displayLoadingStateCalled = true
    }
    
    func displayNotLoadingState() {
        self.displayNotLoadingStateCalled = true
    }
    
    func displayEntityLevel(viewModel: STPhotoMapModels.EntityZoomLevel.ViewModel) {
        self.displayEntityLevelCalled = true
    }
}
