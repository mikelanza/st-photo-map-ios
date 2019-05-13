//
//  STPhotoMapCacheHandler.swift
//  STPhotoMap-iOS
//
//  Created by Dimitri Strauneanu on 10/05/2019.
//  Copyright © 2019 mikelanza. All rights reserved.
//

import Foundation

class STPhotoMapCacheHandler {
    var cache: STPhotoMapCache
    var activeDownloads: SynchronizedArray<String>
    
    init() {
        self.cache = STPhotoMapCache()
        self.activeDownloads = SynchronizedArray<String>()
    }
}
