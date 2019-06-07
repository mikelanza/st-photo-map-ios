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
    
    var model: Model
    
    init(model: Model) {
        self.model = model
        super.init(urlTemplate: nil)
    }
    
    override public func url(forTilePath path: MKTileOverlayPath) -> URL {
        return STPhotoMapUrlBuilder().tileUrl(template: self.model.url, z: path.z, x: path.x, y: path.y, parameters: self.model.parameters)
    }
    
    override public func loadTile(at path: MKTileOverlayPath, result: @escaping (Data?, Error?) -> Void) {
        let url = self.url(forTilePath: path)
        url.downloadImage(result: result)
    }
}

// MARK: - Parameters methods

public extension STPhotoTileOverlay {
    func update(parameter: KeyValue) {
        self.model.parameters.removeAll(where: { $0.key == parameter.key })
        self.model.parameters.append(parameter)
    }
}


public extension STPhotoTileOverlay.Model {
    func clone() -> STPhotoTileOverlay.Model {
        return STPhotoTileOverlay.Model(url: self.url, parameters: self.parameters)
    }
}
