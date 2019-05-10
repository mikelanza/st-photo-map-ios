//
//  STPhotoMapUrlBuilder.swift
//  STPhotoMap-iOS
//
//  Created by Dimitri Strauneanu on 10/05/2019.
//  Copyright © 2019 mikelanza. All rights reserved.
//

import Foundation

class STPhotoMapUrlBuilder {
    init() {
        
    }
    
    func geojsonTileUrl(tileCoordinate: TileCoordinate, parameters: [KeyValue] = Parameters.defaultParameters()) -> (keyUrl: String, downloadUrl: String) {
        let template = "https://tilesdev.streetography.com/tile/%d/%d/%d.geojson"
        return self.tileUrl(template: template, tileCoordinate: tileCoordinate, parameters: parameters)
    }
    
    func jpegTileUrl(tileCoordinate: TileCoordinate, parameters: [KeyValue] = Parameters.defaultParameters()) -> (keyUrl: String, downloadUrl: String) {
        let template = "https://tilesdev.streetography.com/tile/%d/%d/%d.jpeg"
        return self.tileUrl(template: template, tileCoordinate: tileCoordinate, parameters: parameters)
    }
    
    private func tileUrl(template: String, tileCoordinate: TileCoordinate, parameters: [KeyValue] = Parameters.defaultParameters()) -> (keyUrl: String, downloadUrl: String) {
        let downloadUrl = self.tileUrl(template: template, z: tileCoordinate.zoom, x: tileCoordinate.x, y: tileCoordinate.y, parameters: parameters)
        let keyUrl = downloadUrl.excludeParameter((Parameters.Keys.bbox, ""))
        return (keyUrl.absoluteString, downloadUrl.absoluteString)
    }
    
    func tileUrl(template: String, z: Int, x: Int, y: Int, parameters: [KeyValue] = Parameters.defaultParameters()) -> URL {
        let urlString = String(format: template, z, x, y)
        let url = URL(string: urlString)!
        return url.addParameters(parameters)
    }
}