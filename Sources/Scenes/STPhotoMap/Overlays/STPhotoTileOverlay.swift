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
    init() {
        super.init(urlTemplate: nil)
    }
    
    override public func url(forTilePath path: MKTileOverlayPath) -> URL {
        return STPhotoMapUrlBuilder().tileUrl(template: STPhotoMapUrlBuilder().jpegUrl, z: path.z, x: path.x, y: path.y, parameters: STPhotoMapParametersHandler.shared.parameters)
    }
    
    override public func loadTile(at path: MKTileOverlayPath, result: @escaping (Data?, Error?) -> Void) {
        let url = self.url(forTilePath: path)
        url.downloadImage(result: result)
    }
}
