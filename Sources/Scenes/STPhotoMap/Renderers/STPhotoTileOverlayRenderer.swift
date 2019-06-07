//
//  STPhotoTileOverlayRenderer.swift
//  STPhotoMap-iOS
//
//  Created by Crasneanu Cristian on 14/04/2019.
//  Copyright © 2019 mikelanza. All rights reserved.
//

import Foundation
import MapKit

enum STPhotoTileOverlayRendererError: LocalizedError {
    case noPhotoTileOverlayAvailable
    case noDataAvailableForUrl(url: String)
    case noDataProviderAvailableForUrl(url: String)
    case noImageAvailableForUrl(url: String)
    case invalidUrl
}

public class STPhotoTileOverlayRenderer: MKOverlayRenderer {
    private var imageCacheHandler = STPhotoMapImageCacheHandler()
    
    init(tileOverlay: MKTileOverlay) {
        super.init(overlay: tileOverlay)
        self.setupObservers()
    }
    
    private func setupObservers() {
        NotificationCenter.default.addObserver(forName: UIApplication.didReceiveMemoryWarningNotification, object: UIApplication.shared, queue: nil) { (_) in
            self.imageCacheHandler.clearCache()
        }
    }
    
    func predownload(model: STPhotoTileOverlay.Model?, outer tiles: [(MKMapRect, [TileCoordinate])]) {
        guard let model = model else { return }
        tiles.forEach { (outerTile) in
            outerTile.1.forEach({ (tileCoordinate) in
                let tileUrls = self.prepareTileUrls(model: model, outer: (outerTile.0, tileCoordinate))
                self.imageCacheHandler.downloadTile(keyUrl: tileUrls.keyUrl, downloadUrl: tileUrls.downloadUrl)
            })
        }
    }
}

// MARK: - Drawing methods

extension STPhotoTileOverlayRenderer {
    override public func canDraw(_ mapRect: MKMapRect, zoomScale: MKZoomScale) -> Bool {
        do {
            let path = try self.pathForMapRect(mapRect: mapRect, zoomScale: zoomScale)
            let tileUrls = try self.tileUrlsFor(path: path)
            
            if let _ = self.imageCacheHandler.optionalImageDataForUrl(url: tileUrls.keyUrl) {
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
            let tileUrls = try self.tileUrlsFor(path: path)
            
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
    
    public func reloadTiles() {
        DispatchQueue.main.async {
            self.setNeedsDisplay()
        }
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
    
    private func setNeedsDisplayInMainThread(_ mapRect: MKMapRect, zoomScale: MKZoomScale) {
        DispatchQueue.main.async {
            self.setNeedsDisplay(mapRect, zoomScale: zoomScale)
        }
    }
}

// MARK: - Tile methods

extension STPhotoTileOverlayRenderer {
    private func tileOverlay() throws -> STPhotoTileOverlay {
        guard let overlay = self.overlay as? STPhotoTileOverlay else {
            throw STPhotoTileOverlayRendererError.noPhotoTileOverlayAvailable
        }
        return overlay
    }
    
    private func loadTile(_ mapRect: MKMapRect, zoomScale: MKZoomScale, in context: CGContext)  {
        do {
            let path = try self.pathForMapRect(mapRect: mapRect, zoomScale: zoomScale)
            let tileUrls = try self.tileUrlsFor(path: path)
            
            if let _ = self.imageCacheHandler.optionalImageDataForUrl(url: tileUrls.keyUrl) {
                self.setNeedsDisplayInMainThread(mapRect, zoomScale: zoomScale)
                return
            }
            try self.downloadTile(mapRect: mapRect, zoomScale: zoomScale)
        } catch {
            self.setNeedsDisplayInMainThread(mapRect, zoomScale: zoomScale)
        }
    }
    
    private func tileUrlsFor(path: MKTileOverlayPath) throws -> (keyUrl: String, downloadUrl: String) {
        let tileOverlay = try self.tileOverlay()
        let downloadUrl = tileOverlay.url(forTilePath: path)
        let keyUrl = downloadUrl.excludeParameter((Parameters.Keys.bbox, ""))
        return (keyUrl.absoluteString, downloadUrl.absoluteString)
    }
}

// MARK: - Image methods

extension STPhotoTileOverlayRenderer {
    private func imageDataForUrl(url: String) throws -> Data {
        guard let data = self.imageCacheHandler.optionalImageDataForUrl(url: url) else {
            throw STPhotoTileOverlayRendererError.noDataAvailableForUrl(url: url)
        }
        return data
    }
    
    private func imageForUrl(url: String) throws -> CGImage {
        let data = try self.imageDataForUrl(url: url)
        guard let provider = CGDataProvider(data: data as CFData) else {
            throw STPhotoTileOverlayRendererError.noDataProviderAvailableForUrl(url: url)
        }
        guard let image = CGImage(jpegDataProviderSource: provider, decode: nil, shouldInterpolate: false, intent: CGColorRenderingIntent.defaultIntent) else {
            throw STPhotoTileOverlayRendererError.noImageAvailableForUrl(url: url)
        }
        return image
    }
}

// MARK: - Download

extension STPhotoTileOverlayRenderer {
    private func downloadTile(mapRect: MKMapRect, zoomScale: MKZoomScale) throws {
        let path = try self.pathForMapRect(mapRect: mapRect, zoomScale: zoomScale)
        let tileUrls = try self.tileUrlsFor(path: path)
        
        self.imageCacheHandler.downloadTile(keyUrl: tileUrls.keyUrl, downloadUrl: tileUrls.downloadUrl, completion: {
            self.setNeedsDisplayInMainThread(mapRect, zoomScale: zoomScale)
        })
    }
}

extension STPhotoTileOverlayRenderer {
    private func prepareTileUrls(model: STPhotoTileOverlay.Model, outer tile: (MKMapRect, TileCoordinate)) -> (keyUrl: String, downloadUrl: String) {
        self.update(model: model, parameter: KeyValue(Parameters.Keys.bbox, tile.0.boundingBox().description))
        let downloadUrl = STPhotoMapUrlBuilder().tileUrl(template: model.url, z: tile.1.zoom, x: tile.1.x, y: tile.1.y, parameters: model.parameters)
        
        let keyUrl = downloadUrl.excludeParameter((Parameters.Keys.bbox, ""))
        return (keyUrl.absoluteString, downloadUrl.absoluteString)
    }
    
    private func update(model: STPhotoTileOverlay.Model, parameter: KeyValue) {
        model.parameters.removeAll(where: { $0.key == parameter.key })
        model.parameters.append(parameter)
    }
}
