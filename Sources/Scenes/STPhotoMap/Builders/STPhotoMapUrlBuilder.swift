//
//  STPhotoMapUrlBuilder.swift
//  STPhotoMap-iOS
//
//  Created by Dimitri Strauneanu on 10/05/2019.
//  Copyright © 2019 Streetography. All rights reserved.
//

import Foundation
import STPhotoCore

public class STPhotoMapUrlBuilder {
    init() {
        
    }
    
    func geojsonTileUrl(tileCoordinate: TileCoordinate, parameters: [KeyValue] = STPhotoMapParametersHandler.shared.parameters) -> (keyUrl: String, downloadUrl: String) {
        return self.tileUrl(template: Environment.tilesGeojsonURL, tileCoordinate: tileCoordinate, parameters: parameters)
    }
    
    private func tileUrl(template: String, tileCoordinate: TileCoordinate, parameters: [KeyValue] = STPhotoMapParametersHandler.shared.parameters) -> (keyUrl: String, downloadUrl: String) {
        let downloadUrl = self.tileUrl(template: template, z: tileCoordinate.zoom, x: tileCoordinate.x, y: tileCoordinate.y, parameters: parameters)
        let keyUrl = downloadUrl.excludeParameter((Parameters.Keys.bbox, ""))
        return (keyUrl.absoluteString, downloadUrl.absoluteString)
    }
    
    func jpegTileUrl(z: Int, x: Int, y: Int, parameters: [KeyValue] = STPhotoMapParametersHandler.shared.parameters) -> URL {
        return self.tileUrl(template: Environment.tilesJpegURL, z: z, x: x, y: y)
    }
    
    private func tileUrl(template: String, z: Int, x: Int, y: Int, parameters: [KeyValue] = STPhotoMapParametersHandler.shared.parameters) -> URL {
        let urlString = String(format: template, z, x, y)
        let url = URL(string: urlString)!
        return url.addParameters(parameters)
    }
}
