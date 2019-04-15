//
//  STPhotoTileOverlay.swift
//  STPhotoMap-iOS
//
//  Created by Crasneanu Cristian on 12/04/2019.
//  Copyright © 2019 mikelanza. All rights reserved.
//

import Foundation
import MapKit

class STPhotoTileOverlay: MKTileOverlay {
    
    var url: String
    
    init(url: String) {
        self.url = url
        super.init(urlTemplate: url)
    }
    
    override func url(forTilePath path: MKTileOverlayPath) -> URL {
        return buildTileUrl(path: path)
    }
    
    override func loadTile(at path: MKTileOverlayPath, result: @escaping (Data?, Error?) -> Void) {
        let url = self.buildTileUrl(path: path)
        self.downloadImage(url: url) { (data, error) in
            result(data, error)
        }
    }
    
    private func buildTileUrl(path: MKTileOverlayPath) -> URL {
        return URL(string: String(format: self.url, path.z, path.x, path.y))!
    }
    
    private func downloadImage(url: URL, result: @escaping (Data?, Error?) -> Void) {
        let _ = URLSession.shared.dataTask(with: url) { (data, response, error) in
            result(data, error)
        }
    }
}
