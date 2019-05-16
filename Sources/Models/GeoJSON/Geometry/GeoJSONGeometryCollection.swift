//
//  GeoJSONGeometryCollection.swift
//  STPhotoMap-iOS
//
//  Created by Dimitri Strauneanu on 13/07/2018.
//  Copyright © 2018 mikelanza. All rights reserved.
//

import Foundation

internal typealias GeometryCollection = GeoJSON.GeometryCollection

public protocol GeoJSONGeometryCollection: GeoJSONGeometry { }

extension GeoJSON {
    public func geometryCollection(geometries: [GeoJSONGeometry]?) -> GeoJSONGeometryCollection {
        return GeometryCollection(geometries: geometries)
    }
    
    public struct GeometryCollection: GeoJSONGeometryCollection {
        public let type: GeoJSONType = .geometryCollection
        public var geoJSON: GeoJSONDictionary { return ["type": type.rawValue, "geometries": objectGeometries?.map { $0.geoJSON } ?? [] ] }
        
        public var description: String {
            return """
            GeometryCollection: \(
            """
            (\n\(objectGeometries != nil ? objectGeometries!.enumerated().map { "Line \($0) - \($1)" }.joined(separator: ",\n") : "null")
            """
            .replacingOccurrences(of: "\n", with: "\n\t")
            )\n)
            """
        }
        
        public let objectGeometries: [GeoJSONGeometry]?
        public let objectBoundingBox: GeoJSONBoundingBox?
        
        internal init?(geoJSONDictionary: GeoJSONDictionary) {
            guard let geometriesJSON = geoJSONDictionary["geometries"] as? [GeoJSONDictionary] else {
                print("A valid GeometryCollection must have a \"geometries\" key: String : \(geoJSONDictionary)")
                return nil
            }
            
            var geometries = [GeoJSONGeometry]()
            for geometryJSON in geometriesJSON {
                guard let geometry = parser.geoJSONObject(from: geometryJSON) as? GeoJSONGeometry else {
                    print("Invalid Geometry for GeometryCollection")
                    return nil
                }

                geometries.append(geometry)
            }
            
            self.init(geometries: geometries)
        }
        
        fileprivate init(geometries: [GeoJSONGeometry]?) {
            self.objectGeometries = geometries
            
            objectBoundingBox = BoundingBox.best(geometries?.compactMap { $0.objectBoundingBox } ?? [])
        }
    }
}
