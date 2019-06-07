//
//  STPhotoMapRoutingLogicSpy.swift
//  STPhotoMapTests-iOS
//
//  Created by Dimitri Strauneanu on 06/06/2019.
//  Copyright © 2019 mikelanza. All rights reserved.
//

@testable import STPhotoMap
import UIKit

class STPhotoMapRoutingLogicSpy: STPhotoMapRoutingLogic {
    var navigateToSafariCalled: Bool = false
    var navigateToLocationSettingsAlertCalled: Bool = false
    var navigateToApplicationCalled: Bool = false
    
    func navigateToSafari(url: URL) {
        self.navigateToSafariCalled = true
    }
    
    func navigateToLocationSettingsAlert(controller: UIAlertController) {
        self.navigateToLocationSettingsAlertCalled = true
    }
    
    func navigateToApplication(url: URL) {
        self.navigateToApplicationCalled = true
    }
}
