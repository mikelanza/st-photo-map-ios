//
//  UINavigationControllerSpy.swift
//  STPhotoMapTests-iOS
//
//  Created by Dimitri Strauneanu on 08/08/2019.
//  Copyright © 2019 mikelanza. All rights reserved.
//

@testable import STPhotoMap
import UIKit

class UINavigationControllerSpy: UINavigationController {
    var pushViewControllerCalled: Bool = false
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        self.pushViewControllerCalled = true
    }
}
