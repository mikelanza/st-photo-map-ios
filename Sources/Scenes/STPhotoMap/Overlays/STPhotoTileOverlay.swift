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
    public class Model {
        var url: String
        var parameters: [KeyValue]
        
        public init(url: String, parameters: [KeyValue]? = nil) {
            self.url = url
            self.parameters = parameters ?? Parameters.defaultParameters()
        }
    }
    
    private var model: Model
    
    init(model: Model) {
        self.model = model
        super.init(urlTemplate: nil)
    }
    
    override public func url(forTilePath path: MKTileOverlayPath) -> URL {
        let tileUrl = self.buildTileUrl(path: path)
        return self.buildTileUrl(url: tileUrl, with: self.model.parameters)
    }
    
    override public func loadTile(at path: MKTileOverlayPath, result: @escaping (Data?, Error?) -> Void) {
        let url = self.url(forTilePath: path)
        self.downloadImage(url: url) { (data, error) in
            result(data, error)
        }
    }
}

// MARK: - Parameters methods

public extension STPhotoTileOverlay {
    func update(parameter: KeyValue) {
        self.model.parameters.removeAll(where: { $0 == parameter })
        self.model.parameters.append(parameter)
    }
}

// MARK: - Tile methods

extension STPhotoTileOverlay {
    private func buildTileUrl(path: MKTileOverlayPath) -> URL {
        return URL(string: String(format: self.model.url, path.z, path.x, path.y))!
    }
    
    private func buildTileUrl(url: URL, with parameters: [KeyValue]) -> URL {
        return url.addParameters(parameters)
    }
}

// MARK: - Download methods

extension STPhotoTileOverlay {
    private func downloadImage(url: URL, result: @escaping (Data?, Error?) -> Void) {
        let dataTask = URLSession.shared.dataTask(with: url) { (data, response, error) in
            result(data, error)
        }
        dataTask.resume()
    }
}
