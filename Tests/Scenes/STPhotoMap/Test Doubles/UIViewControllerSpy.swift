//
//  UIViewControllerSpy.swift
//  STPhotoMapTests-iOS
//
//  Created by Dimitri Strauneanu on 08/08/2019.
//  Copyright © 2019 Streetography. All rights reserved.
//

@testable import STPhotoMap
import UIKit

class UIViewControllerSpy: UIViewController {
    var presentCalled: Bool = false
    
    override func present(_ viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Void)? = nil) {
        self.presentCalled = true
    }
}
