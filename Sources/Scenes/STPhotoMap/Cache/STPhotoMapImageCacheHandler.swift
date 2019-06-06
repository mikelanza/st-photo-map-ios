//
//  STPhotoMapImageCacheHandler.swift
//  STPhotoMap-iOS
//
//  Created by Crasneanu Cristian on 06/06/2019.
//  Copyright © 2019 mikelanza. All rights reserved.
//

import Foundation
import MapKit

class STPhotoMapImageCacheHandler {
    var cache: STPhotoMapImageCache
    private var activeDownloads: SynchronizedArray<String>
    
    init() {
        self.cache = STPhotoMapImageCache()
        self.activeDownloads = SynchronizedArray<String>()
    }
    
    func clearCache() {
        self.cache.removeAll()
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
    
    func activeDownloadCount() -> Int {
        return self.activeDownloads.count
    }
    
    func optionalImageDataForUrl(url: String) -> Data? {
        return self.cache.optionalImageDataForUrl(url: url)
    }
    
    func downloadImage(url: String?, completion: @escaping (Data?, Error?) -> Void) {
        guard let urlString = url, let url = URL(string: urlString) else {
            completion(nil, STPhotoTileOverlayRendererError.invalidUrl)
            return
        }
        
        url.downloadImage { (data, error) in
            completion(data, error)
        }
    }
    
    func downloadTile(keyUrl: String, downloadUrl: String, completion: @escaping () -> Void) {
        guard self.hasActiveDownload(keyUrl) == false else {
            completion()
            return
        }
        self.addActiveDownload(keyUrl)
        self.downloadImage(url: downloadUrl) { [weak self]  (data, error) in
            self?.removeActiveDownload(keyUrl)
            if let imageData = data {
                self?.cache.addTile(data: imageData, forUrl: downloadUrl, keyUrl: keyUrl)
            }
            completion()
        }
    }
}

