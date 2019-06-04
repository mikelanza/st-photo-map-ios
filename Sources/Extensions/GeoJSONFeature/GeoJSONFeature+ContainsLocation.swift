//
//  GeoJSONFeature+ContainsLocation.swift
//  STPhotoMap-iOS
//
//  Created by Crasneanu Cristian on 27/05/2019.
//  Copyright © 2019 mikelanza. All rights reserved.
//

import Foundation

extension GeoJSONFeature {
    func contains(location: STLocation) -> Bool {
        if let coordinateInBoundingBox = self.objectBoundingBox?.contains(point: Coordinate.fromSTLocation(location: location)), coordinateInBoundingBox == false {
            return false
        }
        
        guard let geometries = self.geometry?.objectGeometries else {
            return false
        }
        
        return geometries.filter({ $0.contains(location: location)}).first != nil
    }
}
