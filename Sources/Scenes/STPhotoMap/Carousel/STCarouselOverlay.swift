//
//  STCarouselOverlay.swift
//  STPhotoMap-iOS
//
//  Created by Dimitri Strauneanu on 23/05/2019.
//  Copyright © 2019 mikelanza. All rights reserved.
//

import MapKit

class STCarouselOverlay: NSObject, MKOverlay {
    var polygon: MKPolygon?
    var polyline: MKPolyline?
    
    var model: STCarouselOverlayModel
    
    var coordinate: CLLocationCoordinate2D {
        get {
            if let polygon = self.polygon {
                return polygon.coordinate
            } else if let polyline = self.polyline {
                return polyline.coordinate
            }
            return CLLocationCoordinate2D()
        }
    }
    
    var boundingMapRect: MKMapRect {
        get {
            if let polygon = self.polygon {
                return polygon.boundingMapRect
            } else if let polyline = self.polyline {
                return polyline.boundingMapRect
            }
            return MKMapRect()
        }
    }
    
    init(polygon: MKPolygon?, polyline: MKPolyline?, model: STCarouselOverlayModel) {
        self.polygon = polygon
        self.polyline = polyline
        self.model = model
    }
    
    func containsMapPoint(_ mapPoint: MKMapPoint) -> Bool {
        if let polygon = self.polygon {
            return polygon.containsMapPoint(mapPoint)
        } else if let polyline = self.polyline {
            return polyline.containsMapPoint(mapPoint)
        }
        return false
    }
    
    func containsCoordinate(coordinate: CLLocationCoordinate2D) -> Bool {
        return self.containsMapPoint(MKMapPoint(coordinate))
    }
}
