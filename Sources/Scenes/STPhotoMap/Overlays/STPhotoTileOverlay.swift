//
//  STPhotoTileOverlay.swift
//  STPhotoMap-iOS
//
//  Created by Crasneanu Cristian on 12/04/2019.
//  Copyright © 2019 mikelanza. All rights reserved.
//

import Foundation
import MapKit
import Kingfisher

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
        return STPhotoMapUrlBuilder().tileUrl(template: self.model.url, z: path.z, x: path.x, y: path.y, parameters: self.model.parameters)
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

// MARK: - Download methods

extension STPhotoTileOverlay {
    private func downloadImage(url: URL, result: @escaping (Data?, Error?) -> Void) {
        DispatchQueue.global().async {
            KingfisherManager.shared.retrieveImage(with: url, completionHandler: { imageResult in
                switch imageResult {
                    case .success(let value): result(value.image.jpegData(compressionQuality: 1.0), nil); break
                    case .failure(let error): result(nil, error); break
                }
            })
        }
    }
}
