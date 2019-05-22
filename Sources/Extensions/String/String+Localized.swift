//
//  String+Localized.swift
//  STPhotoMap-iOS
//
//  Created by Dimitri Strauneanu on 17/04/2019.
//  Copyright © 2019 mikelanza. All rights reserved.
//

import Foundation

extension String {
    func localized(withComment comment: String = "") -> String {
        return NSLocalizedString(self, bundle: Bundle.module, comment: comment)
    }
}
