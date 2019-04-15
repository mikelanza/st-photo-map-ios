//
//  STPhotoTileOverlay.swift
//  STPhotoMap-iOS
//
//  Created by Crasneanu Cristian on 12/04/2019.
//  Copyright © 2019 mikelanza. All rights reserved.
//

import Foundation
import MapKit

public class STPhotoTileOverlay: MKTileOverlay {
    class STPhotoTileOverlayModel {
        var url: String
        
        init(url: String) {
            self.url = url
        }
    }
    
    private var model: STPhotoTileOverlayModel
    
    init(model: STPhotoTileOverlayModel) {
        self.model = model
        super.init(urlTemplate: model.url)
    }
    
    override public func url(forTilePath path: MKTileOverlayPath) -> URL {
        return self.buildTileUrl(path: path)
    }
    
    override public func loadTile(at path: MKTileOverlayPath, result: @escaping (Data?, Error?) -> Void) {
        let url = self.buildTileUrl(path: path)
        self.downloadImage(url: url) { (data, error) in
            result(data, error)
        }
    }
    
    private func buildTileUrl(path: MKTileOverlayPath) -> URL {
        return URL(string: String(format: self.model.url, path.z, path.x, path.y))!
    }
    
    private func downloadImage(url: URL, result: @escaping (Data?, Error?) -> Void) {
        let dataTask = URLSession.shared.dataTask(with: url) { (data, response, error) in
            result(data, error)
        }
        dataTask.resume()
    }
}
