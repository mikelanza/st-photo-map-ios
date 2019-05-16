//
//  GeoJSONFeature.swift
//  STPhotoMap-iOS
//
//  Created by Dimitri Strauneanu on 13/07/2018.
//  Copyright © 2018 mikelanza. All rights reserved.
//

import Foundation

internal typealias Feature = GeoJSON.Feature

public protocol GeoJSONFeature: GeoJSONObject {
    var geometry: GeoJSONGeometry? { get }
    var id: Any? { get }
    var idAsString: String? { get }
    var properties: GeoJSONDictionary? { get }
    var photoProperties: PhotoProperties? { get }
}

extension GeoJSON {
    public func feature(geometry: GeoJSONGeometry?, id: Any?, properties: GeoJSONDictionary?) -> GeoJSONFeature? {
        return Feature(geometry: geometry, id: id, properties: properties)
    }
    
    public struct Feature: GeoJSONFeature {
        public let type: GeoJSONType = .feature
        public var geoJSON: GeoJSONDictionary {
            var geoJSON: GeoJSONDictionary = ["type": type.rawValue, "geometry": geometry?.geoJSON ?? NSNull(), "properties": properties ?? NSNull()]
            if let id = id { geoJSON["id"] = id }
            return geoJSON
        }
        
        public var id: Any? { return idString ?? idDouble ?? idInt }
        public var idAsString: String? { return idString ?? idDouble?.description ?? idInt?.description }
        
        public var description: String {
            return """
            Feature: \(
            """
            (\n\(geometry != nil ? "Geometry - \(geometry!)" : "null")
            """
            .replacingOccurrences(of: "\n", with: "\n\t")
            )\n)
            """
        }
        
        public let geometry: GeoJSONGeometry?
        public let properties: GeoJSONDictionary?
        
        public let objectGeometries: [GeoJSONGeometry]?
        public let objectBoundingBox: GeoJSONBoundingBox?
        
        internal let idString: String?
        internal let idDouble: Double?
        internal let idInt: Int?
        
        internal init?(geoJSONDictionary: GeoJSONDictionary) {
            let id = geoJSONDictionary["id"] as? String ?? (geoJSONDictionary["id"] as? Double)?.description ?? (geoJSONDictionary["id"] as? Int)?.description
            
            let properties = geoJSONDictionary["properties"] as? GeoJSONDictionary
            
            if geoJSONDictionary["geometry"] is NSNull {
                self.init(geometry: nil, id: id, properties: properties)
                return
            }
            
            guard let geometryJSON = geoJSONDictionary["geometry"] as? GeoJSONDictionary else {
                print("A valid Feature must have a \"geometry\" key: String : \(geoJSONDictionary)")
                return nil
            }
            
            guard let geometry = parser.geoJSONObject(from: geometryJSON) as? GeoJSONGeometry else {
                print("Feature must contain a valid geometry")
                return nil
            }

            self.init(geometry: geometry, id: id, properties: properties)
        }
        
        public var photoProperties: PhotoProperties? {
            guard let properties = self.properties else {
                print("There are no feature properties.")
                return nil
            }
            var featureProperties = PhotoProperties()
            featureProperties.type = properties["type"] as? String ?? ""
            featureProperties.name = properties["name"] as? String ?? ""
            featureProperties.photoId = properties["photoId"] as? String ?? ""
            featureProperties.photoCount = properties["numberOfPhotos"] as? Int ?? (properties["numberOfPhotos"] as? NSString)?.integerValue ?? 0
            featureProperties.image60Url = properties["image60URL"] as? String ?? ""
            featureProperties.image250Url = properties["image250URL"] as? String ?? ""
            
            if let locationArray = properties["photoLocation"] as? [NSNumber], locationArray.count >= 2 {
                featureProperties.photoLocation = Coordinate(longitude: locationArray[0].doubleValue, latitude: locationArray[1].doubleValue)
            }
            return featureProperties
        }
        
        fileprivate init?(geometry: GeoJSONGeometry?, id: Any?, properties: GeoJSONDictionary?) {
            guard id == nil || id is String || id is Double || id is Int else { return nil }
            
            self.geometry = geometry
            self.idString = id as? String
            self.idDouble = id as? Double
            self.idInt = id as? Int
            self.properties = properties
            
            objectGeometries = geometry != nil ? [geometry!] : nil
            
            objectBoundingBox = geometry?.objectBoundingBox
        }
    }
}
