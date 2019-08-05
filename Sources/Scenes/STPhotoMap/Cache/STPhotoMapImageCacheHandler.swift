//
//  STPhotoMapImageCacheHandler.swift
//  STPhotoMap-iOS
//
//  Created by Crasneanu Cristian on 06/06/2019.
//  Copyright © 2019 mikelanza. All rights reserved.
//

import Foundation
import MapKit
import STPhotoCore

class STPhotoMapImageCacheHandler {
    var cache: STPhotoMapImageCache
    private var activeDownloads: SynchronizedArray<String>
    private var downloadImageOperationQueue: OperationQueue
    
    private var preloadingActiveDownloads: SynchronizedArray<String>
    private var preloadingImageOperationQueue: OperationQueue
    
    init() {
        self.cache = STPhotoMapImageCache()
        self.activeDownloads = SynchronizedArray<String>()
        
        self.downloadImageOperationQueue = OperationQueue()
        self.downloadImageOperationQueue.maxConcurrentOperationCount = 30
        
        self.preloadingImageOperationQueue = OperationQueue()
        self.preloadingImageOperationQueue.maxConcurrentOperationCount = 30
        self.preloadingActiveDownloads = SynchronizedArray<String>()
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
    
    func shouldDownloadImageTile(url: String) -> Bool {
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
    
    func optionalImageDataForUrl(url: String) -> Data? {
        return self.cache.optionalImageDataForUrl(url: url)
    }
    
    func getTile(url: String) throws -> STPhotoMapImageCache.Tile  {
        return try self.cache.getTile(for: url)
    }
    
    private func downloadImage(url: String?, with priority: Operation.QueuePriority = .normal, completion: @escaping (Data?, Error?) -> Void) {
        let model = DownloadImageOperationModel.Request(url: url)
        let operation = DownloadImageOperation(model: model) { imageResult in
            switch imageResult {
            case .success(let value): completion(value.data, value.error); break
            case .failure(let error): completion(nil, error); break
            }
        }
        
        operation.queuePriority =  priority
        self.downloadImageOperationQueue.addOperation(operation)
    }
    
    func downloadTile(with priority: Operation.QueuePriority = .normal, mapRect: MKMapRect, keyUrl: String, downloadUrl: String, completion: (() -> Void)? = nil) {
        guard self.shouldDownloadImageTile(url: keyUrl) else {
            completion?()
            return
        }
        self.addActiveDownload(keyUrl)
        self.downloadImage(url: downloadUrl, with: priority) { [weak self]  (data, error) in
            self?.removeActiveDownload(keyUrl)
            if let imageData = data {
                self?.cache.addTile(mapRect: mapRect, data: imageData, forUrl: downloadUrl, keyUrl: keyUrl)
            }
            completion?()
        }
    }
    
    func cancelAllOperation() {
        self.downloadImageOperationQueue.cancelAllOperations()
    }
    
    // MARK: Preloading
    
    func shouldPredownloadImageTile(url: String) -> Bool {
        if self.hasPreloadingActiveDownload(url) {
            return false
        }
        do {
            let _ = try self.cache.getTile(for: url)
            return false
        } catch {
            return true
        }
    }
    
    func hasPreloadingActiveDownload(_ url: String) -> Bool {
        return self.preloadingActiveDownloads.contains(url)
    }
    
    func addPreloadingActiveDownload(_ url: String) {
        self.preloadingActiveDownloads.append(url)
    }
    
    func removePreloadingActiveDownload(_ url: String) {
        self.preloadingActiveDownloads.remove(where: { $0 == url })
    }
    
    func predownloadTile(with priority: Operation.QueuePriority = .normal, keyUrl: String, downloadUrl: String, completion: (() -> Void)? = nil) {
        guard self.shouldPredownloadImageTile(url: keyUrl) else {
            completion?()
            return
        }
        self.addPreloadingActiveDownload(keyUrl)
        self.predownloadImage(url: downloadUrl, with: priority) { [weak self]  (data, error) in
            self?.removePreloadingActiveDownload(keyUrl)
            if let imageData = data {
                //self?.cache.addTile(data: imageData, forUrl: downloadUrl, keyUrl: keyUrl)
            }
            completion?()
        }
    }
    
    private func predownloadImage(url: String?, with priority: Operation.QueuePriority = .normal, completion: @escaping (Data?, Error?) -> Void) {
        let model = DownloadImageOperationModel.Request(url: url)
        let operation = DownloadImageOperation(model: model) { imageResult in
            switch imageResult {
            case .success(let value): completion(value.data, value.error); break
            case .failure(let error): completion(nil, error); break
            }
        }
        
        operation.queuePriority =  priority
        self.preloadingImageOperationQueue.addOperation(operation)
    }
    
    func cancelAllPreloadingOperation() {
        self.preloadingImageOperationQueue.cancelAllOperations()
    }
}

