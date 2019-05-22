//
//  Bundle+Module.swift
//  STPhotoMap-iOS
//
//  Created by Dimitri Strauneanu on 22/05/2019.
//  Copyright © 2019 mikelanza. All rights reserved.
//

import Foundation

public extension Bundle {
    static var module: Bundle {
        let bundle = Bundle(for: self)
        guard let url = bundle.url(forResource: "STPhotoMap", withExtension: "bundle") else { return bundle }
        return Bundle(url: url) ?? bundle
    }
}
