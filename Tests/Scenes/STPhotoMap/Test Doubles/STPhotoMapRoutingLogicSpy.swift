//
//  STPhotoMapRoutingLogicSpy.swift
//  STPhotoMapTests-iOS
//
//  Created by Dimitri Strauneanu on 06/06/2019.
//  Copyright © 2019 Streetography. All rights reserved.
//

@testable import STPhotoMap
import UIKit
import STPhotoCore

class STPhotoMapRoutingLogicSpy: STPhotoMapRoutingLogic {
    var navigateToSafariCalled: Bool = false
    var navigateToLocationSettingsAlertCalled: Bool = false
    var navigateToApplicationCalled: Bool = false
    var navigateToPhotoDetailsCalled: Bool = false
    var navigateToPhotoCollectionCalled: Bool = false
    
    weak var viewController: UIViewController?
    weak var photoMapView: STPhotoMapView?
    
    func navigateToSafari(url: URL) {
        self.navigateToSafariCalled = true
    }
    
    func navigateToLocationSettingsAlert(controller: UIAlertController) {
        self.navigateToLocationSettingsAlertCalled = true
    }
    
    func navigateToApplication(url: URL) {
        self.navigateToApplicationCalled = true
    }
    
    func navigateToPhotoDetails(viewController: UIViewController?, photoId: String) {
        self.navigateToPhotoDetailsCalled = true
    }
    
    func navigateToPhotoCollection(location: STLocation, entityLevel: EntityLevel, userId: String?, collectionId: String?) {
        self.navigateToPhotoCollectionCalled = true
    }
}
