//
//  STPhotoMapRoutingLogicSpy.swift
//  STPhotoMapTests-iOS
//
//  Created by Dimitri Strauneanu on 06/06/2019.
//  Copyright © 2019 mikelanza. All rights reserved.
//

@testable import STPhotoMap

class STPhotoMapRoutingLogicSpy: STPhotoMapRoutingLogic {
    var navigateToSafariCalled: Bool = false
    
    func navigateToSafari(url: URL) {
        self.navigateToSafariCalled = true
    }
}
