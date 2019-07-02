//
//  WKTReader.swift
//  STPhotoMap-iOS
//
//  Created by Crasneanu Cristian on 28/08/2018.
//  Copyright © 2018 mikelanza. All rights reserved.
//

import Foundation
import Swift

extension WKTReader {
    
    public enum Errors: Error  {
        case invalidNumberOfCoordinates(String)
        case invalidData(String)
        case unsupportedType(String)
        case unexpectedToken(String)
        case missingElement(String)
    }
    
    private class WKT: Token, CustomStringConvertible {
        static let WHITE_SPACE                     = WKT("white space",         pattern:  "^[ \\t]+")
        static let SINGLE_SPACE                    = WKT("single space",        pattern:  "^ (?=[^ ])")
        static let NEW_LINE                        = WKT("\n or \r",            pattern:  "^[\\n|\\r]")
        static let COMMA                           = WKT(",",                   pattern:  "^,")
        static let LEFT_PAREN                      = WKT("(",                   pattern:  "^\\(")
        static let RIGHT_PAREN                     = WKT(")",                   pattern:  "^\\)")
        static let LEFT_BRACKET                    = WKT("[",                   pattern:  "^\\[")
        static let RIGHT_BRACKET                   = WKT("]",                   pattern:  "^\\]")
        static let LEFT_DELIMITER                  = WKT("( or [",              pattern:  "^[\\(|\\[])")
        static let RIGHT_DELIMITER                 = WKT(") or ]",              pattern:  "^[\\)|\\]])")
        static let NUMERIC_LITERAL                 = WKT("numeric literal",     pattern:  "^[-+]?[0-9]*\\.?[0-9]+([eE][-+]?[0-9]+)?")
        static let THREEDIMENSIONAL                = WKT("Z",                   pattern:  "^z")
        static let MEASURED                        = WKT("M",                   pattern:  "^m")
        static let EMPTY                           = WKT("EMPTY",               pattern:  "^empty")
        static let POINT                           = WKT("POINT",               pattern:  "^point")
        static let LINESTRING                      = WKT("LINESTRING",          pattern:  "^linestring")
        static let LINEARRING                      = WKT("LINEARRING",          pattern:  "^linearring")
        static let POLYGON                         = WKT("POLYGON",             pattern:  "^polygon")
        static let MULTIPOINT                      = WKT("MULTIPOINT",          pattern:  "^multipoint")
        static let MULTILINESTRING                 = WKT("MULTILINESTRING",     pattern:  "^multilinestring")
        static let MULTIPOLYGON                    = WKT("MULTIPOLYGON",        pattern:  "^multipolygon")
        static let GEOMETRYCOLLECTION              = WKT("GEOMETRYCOLLECTION",  pattern:  "^geometrycollection")
        // swiftlint:enable variable_name
        init(_ description: String, pattern value: StringLiteralType) {
            self.description = description
            self.pattern     = value
        }
        
        func match(_ string: String, matchRange: Range<String.Index>) -> Range<String.Index>? {
            return string.range(of: self.pattern, options: [.regularExpression, .caseInsensitive], range: matchRange, locale: Locale(identifier: "en_US"))
        }
        
        func isNewLine() -> Bool {
            return self.description == WKT.NEW_LINE.description
        }
        
        var description: String
        var pattern: String
    }
}


///
/// Well Known Text (WKT) parser for GeoFeatures.
///
/// - Parameters:
///     - Coordinate: The coordinate type to use for all generated Geometry types.
///

public class WKTReader {
    
    public init() {        
    }

    
    ///
    /// Parse a WKT String into Geometry objects.
    ///
    /// - Parameters:
    ///     - string: The WKT string to parse
    ///
    /// - Returns: A Geometry object representing the WKT
    ///
    public func read(string: String) throws -> GeoJSONObject {
        
        let tokenizer = Tokenizer<WKT>(string: string)
        
        /// BNF: <geometry tagged text> ::= <point tagged text>
        ///                          | <linestring tagged text>
        ///                          | <polygon tagged text>
        ///                          | <triangle tagged text>
        ///                          | <polyhedralsurface tagged text>
        ///                          | <tin tagged text>
        ///                          | <multipoint tagged text>
        ///                          | <multilinestring tagged text>
        ///                          | <multipolygon tagged text>
        ///                          | <geometrycollection tagged text>
        ///
        /// BNF: <point tagged text> ::= point <point text>
        if tokenizer.accept(.POINT) != nil {
            return try self.pointTaggedText(tokenizer)
        }
        
        /// BNF: <linestring tagged text> ::= linestring <linestring text>
        if tokenizer.accept(.LINESTRING) != nil {
            return try self.lineStringTaggedText(tokenizer)
        }
        
        /// BNF: <polygon tagged text> ::= polygon <polygon text>
        if tokenizer.accept(.POLYGON) != nil {
            return try self.polygonTaggedText(tokenizer)
        }
        
        /// BNF: <multipoint tagged text> ::= multipoint <multipoint text>
        if tokenizer.accept(.MULTIPOINT) != nil {
            return try self.multiPointTaggedText(tokenizer)
        }
        
        /// BNF: <multilinestring tagged text> ::= multilinestring <multilinestring text>
        if tokenizer.accept(.MULTILINESTRING) != nil {
            return try self.multiLineStringTaggedText(tokenizer)
        }
        
        /// BNF: <multipolygon tagged text> ::= multipolygon <multipolygon text>
        if tokenizer.accept(.MULTIPOLYGON) != nil {
            return try self.multiPolygonTaggedText(tokenizer)
        }
        
        /// BNF: <geometrycollection tagged text> ::= geometrycollection <geometrycollection text>
        if tokenizer.accept(.GEOMETRYCOLLECTION) != nil {
            return try self.geometryCollectionTaggedText(tokenizer)
        }
        throw Errors.unsupportedType("Unsupported type -> '\(string)'")
    }
    
    ///
    /// Parse the WKT Data object into Geometry objects.
    ///
    /// - Parameters:
    ///     - data: The Data object to parse
    ///     - encoding: The encoding that should be used to read the data.
    ///
    /// - Returns: A Geometry object representing the WKT
    ///
    public func read(data: Data, encoding: String.Encoding = .utf8) throws -> GeoJSONObject {
        
        guard let string = String(data: data, encoding: encoding) else {
            throw Errors.invalidData("The Data object can not be converted using the given encoding '\(encoding)'.")
        }
        return try self.read(string: string)
    }
    
    /// BNF: <point tagged text> ::= point <point text>
    private func pointTaggedText(_ tokenizer: Tokenizer<WKT>) throws -> GeoJSONPoint {
        return try pointText(tokenizer)
    }
    
    /// BNF: <point text> ::= <empty set> | <left paren> <point> <right paren>
    private func pointText(_ tokenizer: Tokenizer<WKT>) throws -> GeoJSONPoint {
        
        if tokenizer.accept(.LEFT_PAREN) == nil {
            throw Errors.unexpectedToken(errorMessage(tokenizer, expectedToken: .LEFT_PAREN))
        }
        
        let coordinate = try self.coordinate(tokenizer)
        
        if tokenizer.accept(.RIGHT_PAREN) == nil {
            throw Errors.unexpectedToken(errorMessage(tokenizer, expectedToken: .RIGHT_PAREN))
        }
        return GeoJSON().point(longitude: coordinate.longitude, latitude: coordinate.latitude)
    }
    
    /// BNF: <linestring tagged text> ::= linestring <linestring text>
    private func lineStringTaggedText(_ tokenizer: Tokenizer<WKT>) throws -> GeoJSONLineString {
        
        return try lineStringText(tokenizer)
    }
    
    /// BNF: <linestring text> ::= <empty set> | <left paren> <point> {<comma> <point>}* <right paren>
    private func lineStringText(_ tokenizer: Tokenizer<WKT>) throws -> GeoJSONLineString {
        
        if tokenizer.accept(.EMPTY) != nil {
            throw Errors.unexpectedToken(errorMessage(tokenizer, expectedToken: .EMPTY))
        }
        
        if tokenizer.accept(.LEFT_PAREN) == nil {
            throw Errors.unexpectedToken(errorMessage(tokenizer, expectedToken: .LEFT_PAREN))
        }
        
        var points: [GeoJSONPoint] = []
        
        var done = false
        
        repeat {
            let pointCoodinate = try self.coordinate(tokenizer)
            let point = GeoJSON().point(longitude: pointCoodinate.longitude, latitude: pointCoodinate.latitude)
            points.append(point)
            
            if tokenizer.accept(.COMMA) == nil {
                done = true
            }
        } while !done
        
        if tokenizer.accept(.RIGHT_PAREN) == nil {
            throw Errors.unexpectedToken(errorMessage(tokenizer, expectedToken: .RIGHT_PAREN))
        }
        if let lineString = GeoJSON().lineString(points: points) {
            return lineString
        }
        throw Errors.unexpectedToken(errorMessage(tokenizer, expectedToken: .EMPTY))
    }
    
    /// BNF: <polygon tagged text> ::= polygon <polygon text>
    private func polygonTaggedText(_ tokenizer: Tokenizer<WKT>) throws -> GeoJSONPolygon {
        return try polygonText(tokenizer)
    }
    
    /// BNF: <polygon text> ::= <empty set> | <left paren> <linestring text> {<comma> <linestring text>}* <right paren>
    private func polygonText(_ tokenizer: Tokenizer<WKT>) throws -> GeoJSONPolygon {
        
        if tokenizer.accept(.EMPTY) != nil {
           
        }
        
        if tokenizer.accept(.LEFT_PAREN) == nil {
            throw Errors.unexpectedToken(errorMessage(tokenizer, expectedToken: .LEFT_PAREN))
        }
        
        var linearRings = [GeoJSONLineString]()
        
        var done = false
        
        repeat {
            linearRings.append(try self.lineStringText(tokenizer))
            
            if tokenizer.accept(.COMMA) == nil {
                done = true
            }
        } while !done
        
        if tokenizer.accept(.RIGHT_PAREN) == nil {
            throw Errors.unexpectedToken(errorMessage(tokenizer, expectedToken: .RIGHT_PAREN))
        }
        return GeoJSON().polygon(linearRings: linearRings)!
    }
    
    /// BNF: <multipoint tagged text> ::= multipoint <multipoint text>
    private func multiPointTaggedText(_ tokenizer: Tokenizer<WKT>) throws -> GeoJSONMultiPoint {
        
        return try multiPointText(tokenizer)
    }
    
    /// BNF: <multipoint text> ::= <empty set> | <left paren> <point text> {<comma> <point text>}* <right paren>
    private func multiPointText(_ tokenizer: Tokenizer<WKT>) throws -> GeoJSONMultiPoint {
        
        if tokenizer.accept(.EMPTY) != nil {
           throw Errors.unexpectedToken(errorMessage(tokenizer, expectedToken: .EMPTY))
        }
        
        if tokenizer.accept(.LEFT_PAREN) == nil {
            throw Errors.unexpectedToken(errorMessage(tokenizer, expectedToken: .LEFT_PAREN))
        }
        
        var points = [GeoJSONPoint]()
        
        var done = false
        
        repeat {
            points.append(try self.pointText(tokenizer))
            
            if tokenizer.accept(.COMMA) == nil {
                done = true
            }
        } while !done
        
        if tokenizer.accept(.RIGHT_PAREN) == nil {
            throw Errors.unexpectedToken(errorMessage(tokenizer, expectedToken: .RIGHT_PAREN))
        }
        if let multipoints = GeoJSON().multiPoint(points: points) {
            return multipoints
        }
        throw Errors.unexpectedToken(errorMessage(tokenizer, expectedToken: .EMPTY))
    }
    
    /// BNF: <multilinestring tagged text> ::= multilinestring <multilinestring text>
    private func multiLineStringTaggedText(_ tokenizer: Tokenizer<WKT>) throws -> GeoJSONMultiLineString {
        
        return try multiLineStringText(tokenizer)
    }
    
    /// BNF: <multilinestring text> ::= <empty set> | <left paren> <linestring text> {<comma> <linestring text>}* <right paren>
    private func multiLineStringText(_ tokenizer: Tokenizer<WKT>) throws -> GeoJSONMultiLineString {
        
        if tokenizer.accept(.EMPTY) != nil {
            throw Errors.unexpectedToken(errorMessage(tokenizer, expectedToken: .EMPTY))
        }
        
        if tokenizer.accept(.LEFT_PAREN) == nil {
            throw Errors.unexpectedToken(errorMessage(tokenizer, expectedToken: .LEFT_PAREN))
        }
        
        var lineStrings = [GeoJSONLineString]()
        var done     = false
        
        repeat {
            lineStrings.append(try self.lineStringText(tokenizer))
            
            if tokenizer.accept(.COMMA) == nil {
                done = true
            }
        } while !done
        
        if tokenizer.accept(.RIGHT_PAREN) == nil {
            throw Errors.unexpectedToken(errorMessage(tokenizer, expectedToken: .RIGHT_PAREN))
        }
        if let multilineStrings = GeoJSON().multiLineString(lineStrings: lineStrings) {
            return multilineStrings
        }
        throw Errors.unexpectedToken(errorMessage(tokenizer, expectedToken: .EMPTY))
    }
    
    /// BNF: <multipolygon tagged text> ::= multipolygon <multipolygon text>
    private func multiPolygonTaggedText(_ tokenizer: Tokenizer<WKT>) throws -> GeoJSONMultiPolygon {
        
        return try multiPolygonText(tokenizer)
    }
    
    /// BNF: <multipolygon text> ::= <empty set> | <left paren> <polygon text> {<comma> <polygon text>}* <right paren>
    private func multiPolygonText(_ tokenizer: Tokenizer<WKT>) throws -> GeoJSONMultiPolygon {
        
        if tokenizer.accept(.EMPTY) != nil {
            throw Errors.unexpectedToken(errorMessage(tokenizer, expectedToken: .EMPTY))
        }
        
        if tokenizer.accept(.LEFT_PAREN) == nil {
            throw Errors.unexpectedToken(errorMessage(tokenizer, expectedToken: .LEFT_PAREN))
        }
        
        var polygons = [GeoJSONPolygon]()
        var done = false
        
        repeat {
            
            polygons.append(try self.polygonText(tokenizer))
            
            if tokenizer.accept(.COMMA) == nil {
                done = true
            }
        } while !done
        
        if tokenizer.accept(.RIGHT_PAREN) == nil {
            throw Errors.unexpectedToken(errorMessage(tokenizer, expectedToken: .RIGHT_PAREN))
        }
        
        if let multiPolygons = GeoJSON().multiPolygon(polygons: polygons) {
            return multiPolygons
        }
        throw Errors.unexpectedToken(errorMessage(tokenizer, expectedToken: .EMPTY))
    }
    
    /// BNF: <geometrycollection tagged text> ::= geometrycollection <geometrycollection text>
    private func geometryCollectionTaggedText(_ tokenizer: Tokenizer<WKT>) throws -> GeoJSONGeometryCollection {
        
        return try geometryCollectionText(tokenizer)
    }
    
    /// BNF: <geometrycollection text> ::= <empty set> | <left paren> <geometry tagged text> {<comma> <geometry tagged text>}* <right paren>
    private func geometryCollectionText(_ tokenizer: Tokenizer<WKT>) throws -> GeoJSONGeometryCollection {
        
        if tokenizer.accept(.EMPTY) != nil {
            throw Errors.unexpectedToken(errorMessage(tokenizer, expectedToken: .EMPTY))
        }
        
        if tokenizer.accept(.LEFT_PAREN) == nil {
            throw Errors.unexpectedToken(errorMessage(tokenizer, expectedToken: .LEFT_PAREN))
        }
        
        var geometries = [GeoJSONGeometry]()
        var done     = false
        
        repeat {
            /// BNF: <point tagged text> ::= point <point text>
            if tokenizer.accept(.POINT) != nil {
                geometries.append(try self.pointTaggedText(tokenizer))
                
                /// BNF: <linestring tagged text> ::= linestring <linestring text>
            } else if tokenizer.accept(.LINESTRING) != nil {
                geometries.append(try self.lineStringTaggedText(tokenizer))
                
            } else if tokenizer.accept(.POLYGON) != nil {
                geometries.append(try self.polygonTaggedText(tokenizer))
                
                /// BNF: <multipoint tagged text> ::= multipoint <multipoint text>
            } else if tokenizer.accept(.MULTIPOINT) != nil {
                geometries.append(try self.multiPointTaggedText(tokenizer))
                
                /// BNF: <multilinestring tagged text> ::= multilinestring <multilinestring text>
            } else if tokenizer.accept(.MULTILINESTRING) != nil {
                geometries.append(try self.multiLineStringTaggedText(tokenizer))
                
                /// BNF: <multipolygon tagged text> ::= multipolygon <multipolygon text>
            } else if tokenizer.accept(.MULTIPOLYGON) != nil {
                geometries.append(try self.multiPolygonTaggedText(tokenizer))
                
                /// BNF: <geometrycollection tagged text> ::= geometrycollection <geometrycollection text>
            } else if tokenizer.accept(.GEOMETRYCOLLECTION) != nil {
                geometries.append(try self.geometryCollectionTaggedText(tokenizer))
            } else {
                throw Errors.missingElement("At least one Geometry is required unless you specify EMPTY for the GoemetryCollection")
            }
            
            if tokenizer.accept(.COMMA) == nil {
                done = true
            }
        } while !done
        
        if tokenizer.accept(.RIGHT_PAREN) == nil {
            throw Errors.unexpectedToken(errorMessage(tokenizer, expectedToken: .RIGHT_PAREN))
        }
        return GeoJSON().geometryCollection(geometries: geometries)
    }
    
    /// BNF: <point> ::= <x> <y>
    private func coordinate(_ tokenizer: Tokenizer<WKT>) throws -> Coordinate {
        
        var x: Double = .nan
        var y: Double = .nan

        if let token = tokenizer.accept(.NUMERIC_LITERAL), let value = Double(token) {
            x = value
        } else {
            throw Errors.unexpectedToken(errorMessage(tokenizer, expectedToken: .NUMERIC_LITERAL))
        }
        
        if tokenizer.accept(.SINGLE_SPACE) == nil {
            throw Errors.unexpectedToken(errorMessage(tokenizer, expectedToken: .SINGLE_SPACE))
        }
        
        if let token = tokenizer.accept(.NUMERIC_LITERAL), let value = Double(token) {
            y = value
        } else {
            throw Errors.unexpectedToken(errorMessage(tokenizer, expectedToken: .NUMERIC_LITERAL))
        }
    
        return Coordinate(longitude: x, latitude: y)
    }

    
    private func errorMessage(_ tokenizer: Tokenizer<WKT>, expectedToken: WKT) -> String {
        return "Unexpected token at line: \(tokenizer.line) column: \(tokenizer.column). Expected '\(expectedToken)' but found -> '\(tokenizer.matchString)'"
    }
}
