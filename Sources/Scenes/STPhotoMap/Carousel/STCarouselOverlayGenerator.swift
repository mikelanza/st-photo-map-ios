//
//  STCarouselOverlayGenerator.swift
//  STPhotoMap-iOS
//
//  Created by Dimitri Strauneanu on 23/05/2019.
//  Copyright © 2019 mikelanza. All rights reserved.
//

import MapKit

struct STCarouselOverlayGenerator {
    func overlayForPolygon(polygon: GeoJSONPolygon) -> MKPolygon {
        let linearRingsCoordinates = polygon.linearRings.map { $0.points.map { $0.locationCoordinate } }
        let firstCoordinates = linearRingsCoordinates.first!
        let interiorPolygons = linearRingsCoordinates.tail?.map { MKPolygon(coordinates: $0, count: $0.count) }
        return MKPolygon(coordinates: firstCoordinates, count: firstCoordinates.count, interiorPolygons: interiorPolygons)
    }
    
    func overlayForLineString(lineString: GeoJSONLineString) -> MKPolyline {
        let coordinates = lineString.points.map { $0.locationCoordinate }
        
        return MKPolyline(coordinates: coordinates, count: coordinates.count)
    }
    
    func overlaysForGeoJSONObject(geoJSONObject: GeoJSONObject) -> [MKOverlay] {
        guard let geometries = geoJSONObject.objectGeometries else {
            return []
        }
        
        return geometries.flatMap { overlaysForGeometry(geometry: $0) }
    }
    
    func carouselOverlayForLineString(lineString: GeoJSONLineString) -> STCarouselOverlay {
        let polyline = self.overlayForLineString(lineString: lineString)
        return STCarouselOverlay(polygon: nil, polyline: polyline, model: STCarouselOverlayModel())
    }
    
    func carouselOverlayForPolygon(polygon: GeoJSONPolygon) -> STCarouselOverlay {
        let polygon = self.overlayForPolygon(polygon: polygon)
        return STCarouselOverlay(polygon: polygon, polyline: nil, model: STCarouselOverlayModel())
    }
    
    func carouselOverlaysForPolygons(polygons: [GeoJSONPolygon]) -> [STCarouselOverlay] {
        return polygons.compactMap { carouselOverlayForPolygon(polygon: $0) }
    }
    
    func carouselOverlaysForGeoJSONObject(geoJSONObject: GeoJSONObject) -> [STCarouselOverlay] {
        guard let geometries = geoJSONObject.objectGeometries else {
            return []
        }
        return geometries.flatMap { overlaysForGeometry(geometry: $0) }
    }
    
    private func overlaysForGeometry(geometry: GeoJSONGeometry) -> [STCarouselOverlay] {
        switch geometry {
            case let lineString as GeoJSONLineString:
                return [carouselOverlayForLineString(lineString: lineString)]
            case let multiLineString as GeoJSONMultiLineString:
                return multiLineString.lineStrings.flatMap { overlaysForGeometry(geometry: $0) }
            case let polygon as GeoJSONPolygon:
                return [carouselOverlayForPolygon(polygon: polygon)]
            case let multiPolygon as GeoJSONMultiPolygon:
                return multiPolygon.polygons.flatMap { overlaysForGeometry(geometry: $0) }
            case let geometryCollection as GeoJSONGeometryCollection:
                return geometryCollection.objectGeometries?.flatMap { overlaysForGeometry(geometry: $0) } ?? []
            default: return []
        }
    }
}
