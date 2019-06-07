//
//  UIViewController+Show.swift
//  STPhotoMap-iOS
//
//  Created by Dimitri Strauneanu on 06/06/2019.
//  Copyright © 2019 mikelanza. All rights reserved.
//

import UIKit

extension UIViewController {
    func show(animated: Bool = true, completion: (() -> Void)? = nil) {
        var rootViewController = UIApplication.shared.keyWindow?.rootViewController
        
        if let viewController = rootViewController?.presentedViewController {
            rootViewController = viewController
        }
        if let navigationController = rootViewController as? UINavigationController {
            rootViewController = navigationController.viewControllers.first
        }
        if let tabBarController = rootViewController as? UITabBarController {
            rootViewController = tabBarController.selectedViewController
        }
        
        rootViewController?.present(self, animated: animated, completion: completion)
    }
}
