//
//  STPhotoMapCacheHandler.swift
//  STPhotoMap-iOS
//
//  Created by Dimitri Strauneanu on 10/05/2019.
//  Copyright © 2019 mikelanza. All rights reserved.
//

import Foundation
import STPhotoCore

class STPhotoMapGeojsonCacheHandler {
    var cache: STPhotoMapGeojsonCache
    var activeDownloads: SynchronizedArray<String>
    
    init() {
        self.cache = STPhotoMapGeojsonCache()
        self.activeDownloads = SynchronizedArray<String>()
    }
    
    func hasActiveDownload(_ url: String) -> Bool {
        return self.activeDownloads.contains(url)
    }
    
    func addActiveDownload(_ url: String) {
        self.activeDownloads.append(url)
    }
    
    func removeActiveDownload(_ url: String) {
        self.activeDownloads.remove(where: { $0 == url })
    }
    
    func removeAllActiveDownloads() {
        self.activeDownloads.removeAll()
    }
    
    func shouldPrepareTileForCaching(url: String) -> Bool {
        if self.hasActiveDownload(url) {
            return false
        }
        do {
            let _ = try self.cache.getTile(for: url)
            return false
        } catch {
            return true
        }
    }
    
    func activeDownloadCount() -> Int {
        return self.activeDownloads.count
    }
}
