//
//  STPhotoMapRouter.swift
//  STPhotoMap
//
//  Created by Crasneanu Cristian on 12/04/2019.
//  Copyright (c) 2019 mikelanza. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit
import SafariServices
import STPhotoDetails

@objc protocol STPhotoMapRoutingLogic {
    func navigateToSafari(url: URL)
    func navigateToLocationSettingsAlert(controller: UIAlertController)
    func navigateToApplication(url: URL)
    func navigateToPhotoDetails(photoId: String)
    
    weak var viewController: UIViewController? { get set }
}

class STPhotoMapRouter: NSObject, STPhotoMapRoutingLogic {
    weak var displayer: STPhotoMapDisplayLogic?
    weak var viewController: UIViewController?
    
    // MARK: Routing
    
    func navigateToSafari(url: URL) {
        let safariViewController = SFSafariViewController(url: url)
        self.viewController?.present(safariViewController, animated: true, completion: nil)
    }
        
    func navigateToLocationSettingsAlert(controller: UIAlertController) {
        self.viewController?.present(controller, animated: true, completion: nil)
    }
    
    func navigateToApplication(url: URL) {
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        }
    }
    
    func navigateToPhotoDetails(photoId: String) {
        let photoDetailsViewController = STPhotoDetailsViewController(photoId: photoId)
        if let controller = self.viewController as? UINavigationController {
            controller.pushViewController(photoDetailsViewController, animated: true)
        } else {
            self.viewController?.present(photoDetailsViewController, animated: true, completion: nil)
        }
    }
}
