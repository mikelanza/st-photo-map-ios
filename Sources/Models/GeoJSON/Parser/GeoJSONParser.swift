//
//  GeoJSONParser.swift
//  STPhotoMap-iOS
//
//  Created by Dimitri Strauneanu on 13/07/2018.
//  Copyright © 2018 mikelanza. All rights reserved.
//

import Foundation

internal protocol GeoJSONParserProtocol {
    func geoJSONObject(from geoJSON: GeoJSONDictionary) -> GeoJSONObject?
}

internal struct GeoJSONParser: GeoJSONParserProtocol {
    func geoJSONObject(from geoJSONDictionary: GeoJSONDictionary) -> GeoJSONObject? {
        guard let type = geoJSONType(geoJSONDictionary: geoJSONDictionary) else { return nil }
        
        switch type {
            case .feature:
                return Feature(geoJSONDictionary: geoJSONDictionary)
            case .featureCollection:
                return FeatureCollection(geoJSONDictionary: geoJSONDictionary)
            default: return geometry(geoJSONDictionary: geoJSONDictionary, geoJSONType: type)
        }
    }
}

internal extension GeoJSONParser {
    fileprivate func geoJSONType(geoJSONDictionary: GeoJSONDictionary) -> GeoJSONType? {
        guard let typeString = geoJSONDictionary["type"] as? String else {
            print("A valid geoJSON must have a \"type\" key: String : \(geoJSONDictionary)")
            return nil
        }
        guard let type = GeoJSONType(rawValue: typeString) else {
            print("Invalid GeoJSON Geometry type: \(typeString)")
            return nil
        }
        
        return type
    }
    
    fileprivate func geometry(geoJSONDictionary: GeoJSONDictionary, geoJSONType: GeoJSONType) -> GeoJSONGeometry? {
        if geoJSONType == .geometryCollection { return GeometryCollection(geoJSONDictionary: geoJSONDictionary) }
        
        guard let coordinates = geoJSONDictionary["coordinates"] as? [Any] else {
            print("A valid GeoJSON Coordinates Geometry must have a valid \"coordinates\" array: String : \(geoJSONDictionary)")
            return nil
        }
        
        switch geoJSONType {
        case .point:
            return Point(coordinatesJSON: coordinates)
        case .multiPoint:
            return MultiPoint(coordinatesJSON: coordinates)
        case .lineString:
            return LineString(coordinatesJSON: coordinates)
        case .multiLineString:
            return MultiLineString(coordinatesJSON: coordinates)
        case .polygon:
            return Polygon(coordinatesJSON: coordinates)
        case .multiPolygon:
            return MultiPolygon(coordinatesJSON: coordinates)
        default:
            print("\(geoJSONType.rawValue) is not a valid Coordinates Geometry.")
            return nil
        }
    }
}
