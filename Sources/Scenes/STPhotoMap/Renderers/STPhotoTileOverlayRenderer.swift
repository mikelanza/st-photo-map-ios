//
//  STPhotoTileOverlayRenderer.swift
//  STPhotoMap-iOS
//
//  Created by Crasneanu Cristian on 14/04/2019.
//  Copyright © 2019 mikelanza. All rights reserved.
//

import Foundation
import MapKit

public class STPhotoTileOverlayRenderer: MKOverlayRenderer {
    
    private var activeDownloads = SynchronizedArray<String>()
    private var tiles: SynchronizedArray<Tile> = SynchronizedArray()
    
    private class Tile: NSObject {
        var data: Data
        var keyUrl: String
        var downloadUrl: String
        
        init(data: Data, keyUrl: String, downloadUrl: String) {
            self.data = data
            self.keyUrl = keyUrl
            self.downloadUrl = downloadUrl
        }
    }
    
    init(tileOverlay: MKTileOverlay) {
        super.init(overlay: tileOverlay)
        
        self.setupObservers()
    }
    
    private func setupObservers() {
        NotificationCenter.default.addObserver(forName: UIApplication.didReceiveMemoryWarningNotification, object: UIApplication.shared, queue: nil) { (_) in
            self.tiles.removeAll()
        }
    }
    
    override public func canDraw(_ mapRect: MKMapRect, zoomScale: MKZoomScale) -> Bool {
        do {
            let path = try self.pathForMapRect(mapRect: mapRect, zoomScale: zoomScale)
            let tileUrls = try self.getTileUrlsFor(path: path)
            
            if let _ = self.optionalImageDataForUrl(url: tileUrls.keyUrl) {
                return true
            }
            
            try self.downloadTile(mapRect: mapRect, zoomScale: zoomScale)
        } catch {
            self.setNeedsDisplayInMainThread(mapRect, zoomScale: zoomScale)
        }
        
        return false
    }
    
    override public func draw(_ mapRect: MKMapRect, zoomScale: MKZoomScale, in context: CGContext) {
        do {
            let path = try self.pathForMapRect(mapRect: mapRect, zoomScale: zoomScale)
            let tileUrls = try self.getTileUrlsFor(path: path)
            
            let imageRef = try self.imageForUrl(url: tileUrls.keyUrl)
            let image = UIImage(cgImage: imageRef)
            let rect = self.rect(for: mapRect)
            UIGraphicsPushContext(context)
            image.draw(in: rect)
            UIGraphicsPopContext()
        } catch {
            self.loadTile(mapRect, zoomScale: zoomScale, in: context)
        }
    }
    
    private func loadTile(_ mapRect: MKMapRect, zoomScale: MKZoomScale, in context: CGContext)  {
        do {
            let path = try self.pathForMapRect(mapRect: mapRect, zoomScale: zoomScale)
            let tileUrls = try self.getTileUrlsFor(path: path)
            
            if let _ = self.optionalImageDataForUrl(url: tileUrls.keyUrl) {
                self.setNeedsDisplayInMainThread(mapRect, zoomScale: zoomScale)
                return
            }
            try self.downloadTile(mapRect: mapRect, zoomScale: zoomScale)
        } catch {
            self.setNeedsDisplayInMainThread(mapRect, zoomScale: zoomScale)
        }
    }
    
    private func downloadTile(mapRect: MKMapRect, zoomScale: MKZoomScale) throws {
        let path = try self.pathForMapRect(mapRect: mapRect, zoomScale: zoomScale)
        let tileUrls = try self.getTileUrlsFor(path: path)
        
        if !self.isDownloadingTile(url: tileUrls.keyUrl) {
            self.addDownloadTile(url: tileUrls.keyUrl)
            self.downloadImage(url: tileUrls.downloadUrl) { [weak self]  (data, error) in
                self?.removeDownloadTile(url: tileUrls.keyUrl)
                if let imageData = data {
                    self?.addImageData(data: imageData, forUrl: tileUrls.downloadUrl, keyUrl: tileUrls.keyUrl)
                }
                self?.setNeedsDisplayInMainThread(mapRect, zoomScale: zoomScale)
            }
        } else {
            self.setNeedsDisplayInMainThread(mapRect, zoomScale: zoomScale)
        }
    }
    
    private func setNeedsDisplayInMainThread(_ mapRect: MKMapRect, zoomScale: MKZoomScale) {
        DispatchQueue.main.async {
            self.setNeedsDisplay(mapRect, zoomScale: zoomScale)
        }
    }
    
    private func tileOverlay() throws -> MKTileOverlay {
        guard let overlay = self.overlay as? MKTileOverlay else {
            throw NSError(domain: "No tile overlay available", code: 404, userInfo: nil)
        }
        return overlay
    }
    
    private func getCacheTileOverlay() throws -> STPhotoTileOverlay {
        guard let overlay = self.overlay as? STPhotoTileOverlay else {
            throw NSError(domain: "No cache tile overlay available", code: 404, userInfo: nil)
        }
        return overlay
    }
    
    private func getTileUrlsFor(path: MKTileOverlayPath) throws -> (keyUrl: String, downloadUrl: String) {
        let tileOverlay = try self.getCacheTileOverlay()
        let url = tileOverlay.url(forTilePath: path)
        return (url.absoluteString, url.absoluteString)
    }
    
    private func addImageData(data: Data, forUrl downloadUrl: String, keyUrl: String) {
        if self.tiles.filter({ $0.keyUrl == keyUrl }).count == 0 {
            self.tiles.append(Tile(data: data, keyUrl: keyUrl, downloadUrl: downloadUrl))
        }
    }
    
    private func optionalImageDataForUrl(url: String) -> Data? {
        for i in 0..<self.tiles.count {
            if tiles[i]?.keyUrl == url {
                return tiles[i]?.data
            }
        }
        return nil
    }
    
    private func imageDataForUrl(url: String) throws -> Data {
        guard let data = self.optionalImageDataForUrl(url: url) else {
            throw NSError(domain: "No data available for url: \(url)", code: 404, userInfo: nil)
        }
        return data
    }
    
    private func imageForUrl(url: String) throws -> CGImage {
        let data = try self.imageDataForUrl(url: url)
        guard let provider = CGDataProvider(data: data as CFData) else {
            throw NSError(domain: "No data provider available for url: \(url)", code: 404, userInfo: nil)
        }
        guard let image = CGImage(jpegDataProviderSource: provider, decode: nil, shouldInterpolate: false, intent: CGColorRenderingIntent.defaultIntent) else {
            throw NSError(domain: "No image available for url: \(url)", code: 404, userInfo: nil)
        }
        return image
    }
    
    private func pathForMapRect(mapRect: MKMapRect, zoomScale: MKZoomScale) throws -> MKTileOverlayPath {
        let tileOverlay = try self.tileOverlay()
        let factor: CGFloat = tileOverlay.tileSize.width / 256
        
        var path: MKTileOverlayPath = MKTileOverlayPath()
        let x = Int((mapRect.origin.x * Double(zoomScale)) / Double(tileOverlay.tileSize.width / factor))
        let y = Int((mapRect.origin.y * Double(zoomScale)) / Double(tileOverlay.tileSize.width / factor))
        let z = Int(log2(zoomScale) + 20)
        path.x = x >= 0 ? x : 0
        path.y = y >= 0 ? y : 0
        path.z = z <= 20 ? z : 20
        
        path.contentScaleFactor = self.contentScaleFactor
        
        return path
    }
    
    private func isDownloadingTile(url: String) -> Bool {
        return self.activeDownloads.contains(url)
    }
    
    private func addDownloadTile(url: String) {
        self.activeDownloads.append(url)
    }
    
    private func removeDownloadTile(url: String) {
        self.activeDownloads.remove(where: { (activeDownloadUrl) -> Bool in
            activeDownloadUrl == url
        })
    }
    
    public func reloadTiles() {
        DispatchQueue.main.async {
            self.setNeedsDisplay()
        }
    }
}


// MARK: Download and predownload

extension STPhotoTileOverlayRenderer {
    private func downloadImage(url: String?, completion: @escaping (Data?, Error?) -> Void) {
        guard let urlString = url, let url = URL(string: urlString) else {
            completion(nil, NSError(domain: "No url for download tile image", code: 404, userInfo: nil));

            return
        }
        
        let dataTask = URLSession.shared.dataTask(with: url) { (data, response, error) in
            completion(data, error)
        }
        dataTask.resume()
    }
}
