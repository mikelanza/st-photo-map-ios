//
//  Bundle+Module.swift
//  STPhotoMap-iOS
//
//  Created by Dimitri Strauneanu on 22/05/2019.
//  Copyright © 2019 Streetography. All rights reserved.
//

import Foundation

extension Bundle {
    private class STPhotoMapModule { }
    
    static var module: Bundle {
        let bundle = Bundle(for: STPhotoMapModule.self)
        guard let url = bundle.url(forResource: "STPhotoMap", withExtension: "bundle") else { return bundle }
        return Bundle(url: url) ?? bundle
    }
}
