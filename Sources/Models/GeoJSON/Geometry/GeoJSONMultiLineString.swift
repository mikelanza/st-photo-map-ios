//
//  GeoJSONMultiLineString.swift
//  STPhotoMap-iOS
//
//  Created by Dimitri Strauneanu on 13/07/2018.
//  Copyright © 2018 mikelanza. All rights reserved.
//

import Foundation

internal typealias MultiLineString = GeoJSON.MultiLineString

public protocol GeoJSONMultiLineString: GeoJSONMultiCoordinatesGeometry {
    var lineStrings: [GeoJSONLineString] { get }
}

extension GeoJSON {
    public func multiLineString(lineStrings: [GeoJSONLineString]) -> GeoJSONMultiLineString? {
        return MultiLineString(lineStrings: lineStrings)
    }
    
    public struct MultiLineString: GeoJSONMultiLineString {
        public let type: GeoJSONType = .multiLineString
        public var geoJSONCoordinates: [Any] { return lineStrings.map { $0.geoJSONCoordinates } }
        
        public var description: String {
            return """
            MultiLineString: \(
            """
            (\n\(lineStrings.enumerated().map { "Line \($0) - \($1)" }.joined(separator: ",\n"))
            """
            .replacingOccurrences(of: "\n", with: "\n\t")
            )\n)
            """
        }
        
        public let lineStrings: [GeoJSONLineString]
        
        public var points: [GeoJSONPoint] {
            return lineStrings.flatMap { $0.points }
        }
        
        public var boundingBox: GeoJSONBoundingBox? {
            return BoundingBox.best(lineStrings.compactMap { $0.boundingBox })!
        }
        
        internal init?(coordinatesJSON: [Any]) {
            guard let lineStringsJSON = coordinatesJSON as? [[Any]] else {
                print("A valid MultiLineString must have valid coordinates")
                return nil
            }
            
            var lineStrings = [GeoJSONLineString]()
            for lineStringJSON in lineStringsJSON {
                if let lineString = LineString(coordinatesJSON: lineStringJSON) {
                    lineStrings.append(lineString)
                } else {
                    print("Invalid LineString in MultiLineString")
                    return nil
                }
            }
            
            self.init(lineStrings: lineStrings)
        }
        
        fileprivate init?(lineStrings: [GeoJSONLineString]) {
            guard lineStrings.count >= 1 else {
                print("A valid MultiLineString must have at least one LineString")
                return nil
            }
            
            self.lineStrings = lineStrings
        }
    }
}
