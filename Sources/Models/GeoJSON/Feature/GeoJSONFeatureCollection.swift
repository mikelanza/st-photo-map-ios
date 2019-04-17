//
//  GeoJSONFeatureCollection.swift
//  STPhotoMap-iOS
//
//  Created by Dimitri Strauneanu on 13/07/2018.
//  Copyright © 2018 mikelanza. All rights reserved.
//

import Foundation

internal typealias FeatureCollection = GeoJSON.FeatureCollection

public protocol GeoJSONFeatureCollection: GeoJSONObject {
    var features: [GeoJSONFeature] { get }
}

extension GeoJSON {
    public func featureCollection(features: [GeoJSONFeature]) -> GeoJSONFeatureCollection? {
        return FeatureCollection(features: features)
    }
    
    public struct FeatureCollection: GeoJSONFeatureCollection {
        public let type: GeoJSONType = .featureCollection
        public var geoJSON: GeoJSONDictionary { return ["type": type.rawValue, "features": features.map { $0.geoJSON } ] }
        
        public var description: String {
            return """
            FeatureCollection: \(
            """
            (\n\(features.enumerated().map { "Line \($0) - \($1)" }.joined(separator: ",\n"))
            """
            .replacingOccurrences(of: "\n", with: "\n\t")
            )\n)
            """
        }
        
        public let features: [GeoJSONFeature]
        
        public let objectGeometries: [GeoJSONGeometry]?
        public let objectBoundingBox: GeoJSONBoundingBox?
        
        internal init?(geoJSONDictionary: GeoJSONDictionary) {
            guard let featuresJSON = geoJSONDictionary["features"] as? [GeoJSONDictionary] else {
                print("A valid FeatureCollection must have a \"features\" key: String : \(geoJSONDictionary)")
                return nil
            }
            
            var features = [GeoJSONFeature]()
            for featureJSON in featuresJSON {
                if let feature = Feature(geoJSONDictionary: featureJSON) {
                    features.append(feature)
                } else {
                    print("Invalid Feature in FeatureCollection")
                    return nil
                }
            }
            
            self.init(features: features)
        }
        
        fileprivate init?(features: [GeoJSONFeature]) {
            self.features = features
            
            let geometries = features.compactMap { $0.objectGeometries }.flatMap { $0 }
            
            self.objectGeometries = geometries.count > 0 ? geometries : nil
            
            objectBoundingBox = BoundingBox.best(geometries.compactMap { $0.objectBoundingBox })
        }
    }
}
