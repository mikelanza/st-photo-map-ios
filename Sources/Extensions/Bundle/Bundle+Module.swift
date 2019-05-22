//
//  Bundle+Module.swift
//  STPhotoMap-iOS
//
//  Created by Dimitri Strauneanu on 22/05/2019.
//  Copyright © 2019 mikelanza. All rights reserved.
//

import Foundation

extension Bundle {
    private static let bundleId = "com.streetography.st.photo.map.ios.STPhotoMap"
    
    static var module: Bundle {
        guard let bundle = Bundle(identifier: bundleId) else { return .main }
        guard let url = bundle.url(forResource: "STPhotoMap", withExtension: "bundle") else { return bundle }
        return Bundle(url: url) ?? bundle
    }
}
