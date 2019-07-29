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
    
    private var zoom: Int = 0
    
    enum ZoomActivity {
        case zoomIn
        case zoomOut
    }
    
    var zoomActivity: ZoomActivity = .zoomOut
    
    init(tileOverlay: MKTileOverlay) {
        super.init(overlay: tileOverlay)
        self.setupObservers()
    }
    
    private func setupObservers() {
        NotificationCenter.default.addObserver(forName: UIApplication.didReceiveMemoryWarningNotification, object: UIApplication.shared, queue: nil) { (_) in
            self.imageCacheHandler.clearCache()
        }
    }
    
    func predownload(outer tiles: [(MKMapRect, [TileCoordinate])]) {
    }
}

// MARK: - Drawing methods

extension STPhotoTileOverlayRenderer {
    override public func canDraw(_ mapRect: MKMapRect, zoomScale: MKZoomScale) -> Bool {
        self.setZoomActivity(zoomScale: zoomScale)
        return true
    }
    
    override public func draw(_ mapRect: MKMapRect, zoomScale: MKZoomScale, in context: CGContext) {
        do {
            let path = try self.pathForMapRect(mapRect: mapRect, zoomScale: zoomScale)
            try self.drawImageTile(path: path, context: context)
        } catch {
            do {
                try self.drawCachedTile(mapRect, zoomScale: zoomScale, in: context)
            } catch {
                self.drawEmptyTile(mapRect, in: context)
            }
            self.loadTile(mapRect, zoomScale: zoomScale, in: context)
        }
    }
    
    public func reload() {
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
        
        self.imageCacheHandler.downloadTile(with: Operation.QueuePriority.veryHigh, mapRect: mapRect, keyUrl: tileUrls.keyUrl, downloadUrl: tileUrls.downloadUrl, completion: {
            self.setNeedsDisplayInMainThread(mapRect, zoomScale: zoomScale)
        })
    }
}

extension STPhotoTileOverlayRenderer {
    private func prepareTileUrls(outer tile: (MKMapRect, TileCoordinate)) -> (keyUrl: String, downloadUrl: String) {
        let newParameters = self.update(newParameter: KeyValue(Parameters.Keys.bbox, tile.0.boundingBox().description))
        let downloadUrl = STPhotoMapUrlBuilder().jpegTileUrl(z: tile.1.zoom, x: tile.1.x, y: tile.1.y, parameters: newParameters)
        
        let keyUrl = downloadUrl.excludeParameter((Parameters.Keys.bbox, ""))
        return (keyUrl.absoluteString, downloadUrl.absoluteString)
    }
    
    private func update(newParameter: KeyValue) -> [KeyValue] {
        var newParameters = STPhotoMapParametersHandler.shared.parameters
        newParameters.removeAll(where: { $0.key == newParameter.key })
        newParameters.append(newParameter)
        return newParameters
    }
}

// MARK: - Draw old tiles

extension STPhotoTileOverlayRenderer {
    private func drawCachedTile(_ mapRect: MKMapRect, zoomScale: MKZoomScale, in context: CGContext) throws {
        let path = try self.pathForMapRect(mapRect: mapRect, zoomScale: zoomScale)
        
        if zoomActivity == .zoomOut {
            self.drawTilePaths(path.childrenPaths(), mapRect: mapRect, context: context)
        } else {
            try self.drawImageTile(path: path.parentPath(), context: context)
        }
    }
    
    private func drawEmptyTile(_ mapRect: MKMapRect, in context: CGContext) {
        UIGraphicsPushContext(context)
        context.setFillColor(UIColor(displayP3Red: 0.88, green: 0.88, blue: 0.86, alpha: 1.0).cgColor)
        context.fill(self.rect(for: mapRect))
        UIGraphicsPopContext()
    }
    
    private func drawTilePaths(_ paths: [MKTileOverlayPath], mapRect: MKMapRect, context: CGContext) {
        for path in paths {
            do {
                try self.drawImageTile(path: path, context: context)
            } catch {
                self.drawEmptyTile(mapRect, in: context)
            }
        }
    }
    
    private func drawImageTile(path: MKTileOverlayPath, context: CGContext) throws {
        let tileUrls = try self.tileUrlsFor(path: path)
        let tile = try self.imageCacheHandler.getTile(url: tileUrls.keyUrl)
        
        let imageRef = try self.imageForUrl(url: tileUrls.keyUrl)
        let image = UIImage(cgImage: imageRef)
        let rect = self.rect(for: tile.mapRect)
        UIGraphicsPushContext(context)
        image.draw(in: rect)
        UIGraphicsPopContext()
    }
    
    private func setZoomActivity(zoomScale: MKZoomScale) {
        let newZoom = Int(log2(zoomScale) + 20)
        
        if self.zoom < newZoom {
            self.zoomActivity = ZoomActivity.zoomIn
        } else if self.zoom > newZoom {
            self.zoomActivity = ZoomActivity.zoomOut
        }
        
        self.zoom = newZoom <= 20 ? newZoom : 20
    }
}
