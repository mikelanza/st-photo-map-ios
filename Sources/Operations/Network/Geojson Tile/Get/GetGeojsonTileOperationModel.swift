//
//  GetGeojsonTileOperationModel.swift
//  STPhotoMap-iOS
//
//  Created by Dimitri Strauneanu on 11/07/2018.
//  Copyright © 2018 mikelanza. All rights reserved.
//

import Foundation

enum GetGeojsonTileOperationModel {
    struct Request {
        let tileCoordinate: TileCoordinate
        let url: String
    }
    
    struct Response {
        let geoJSONObject: GeoJSONObject
    }
}
