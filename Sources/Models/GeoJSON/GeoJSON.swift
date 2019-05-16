//
//  GeoJSON.swift
//  STPhotoMap-iOS
//
//  Created by Dimitri Strauneanu on 12/07/2018.
//  Copyright © 2018 mikelanza. All rights reserved.
//

import Foundation

public typealias GeoJSONDictionary = [String: Any]

public protocol GeoJSONObject: CustomStringConvertible {
    var type: GeoJSONType { get }
    var objectGeometries: [GeoJSONGeometry]? { get }
    var objectBoundingBox: GeoJSONBoundingBox? { get }
    var geoJSON: GeoJSONDictionary { get }
}

public protocol GeoJSONGeometry: GeoJSONObject {
    
}

public protocol GeoJSONCoordinatesGeometry: GeoJSONGeometry {
    var geoJSONCoordinates: [Any] { get }
    var geometries: [GeoJSONGeometry] { get }
    var boundingBox: GeoJSONBoundingBox? { get }
}

public extension GeoJSONCoordinatesGeometry {
    var objectGeometries: [GeoJSONGeometry]? { return self.geometries }
    var objectBoundingBox: GeoJSONBoundingBox? { return self.boundingBox }
    var geoJSON: GeoJSONDictionary { return ["type": self.type.rawValue, "coordinates": self.geoJSONCoordinates] }
    var geometries: [GeoJSONGeometry] { return [self] }
}

public protocol GeoJSONMultiCoordinatesGeometry: GeoJSONCoordinatesGeometry {
    var points: [GeoJSONPoint] { get }
}

public protocol GeoJSONProtocol {
    func parse(geoJSON: GeoJSONDictionary) -> GeoJSONObject?
    
    func featureCollection(features: [GeoJSONFeature]) -> GeoJSONFeatureCollection?
    func feature(geometry: GeoJSONGeometry?, id: Any?, properties: GeoJSONDictionary?) -> GeoJSONFeature?
    func geometryCollection(geometries: [GeoJSONGeometry]?) -> GeoJSONGeometryCollection
    func multiPolygon(polygons: [GeoJSONPolygon]) -> GeoJSONMultiPolygon?
    func polygon(linearRings: [GeoJSONLineString]) -> GeoJSONPolygon?
    func multiLineString(lineStrings: [GeoJSONLineString]) -> GeoJSONMultiLineString?
    func lineString(points: [GeoJSONPoint]) -> GeoJSONLineString?
    func multiPoint(points: [GeoJSONPoint]) -> GeoJSONMultiPoint?
    func point(longitude: Double, latitude: Double) -> GeoJSONPoint
}

public struct GeoJSON: GeoJSONProtocol {
    internal static let parser = GeoJSONParser()
    
    public func parse(geoJSON: GeoJSONDictionary) -> GeoJSONObject? {
        return GeoJSON.parser.geoJSONObject(from: geoJSON)
    }
}
