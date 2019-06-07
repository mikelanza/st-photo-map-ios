//
//  MKMapRect+Coordinates.swift
//  STPhotoMap-iOS
//
//  Created by Dimitri Strauneanu on 23/05/2019.
//  Copyright © 2019 mikelanza. All rights reserved.
//

import MapKit

extension MKMapRect {
    public var northEastCoordinate: CLLocationCoordinate2D {
        return MKMapPoint(x: self.maxX, y: self.origin.y).coordinate
    }
    
    public var northWestCoordinate: CLLocationCoordinate2D {
        return MKMapPoint(x: self.minX, y: self.origin.y).coordinate
    }
    
    public var southEastCoordinate: CLLocationCoordinate2D {
        return MKMapPoint(x: self.maxX, y: self.maxY).coordinate
    }
    
    public var southWestCoordinate: CLLocationCoordinate2D {
        return MKMapPoint(x: self.origin.x, y: self.maxY).coordinate
    }
    
    public var westCenterEdgeCoordinate: CLLocationCoordinate2D {
        return MKMapPoint(x: self.minX, y: self.midY).coordinate
    }
    
    public var northCenterEdgeCoordinate: CLLocationCoordinate2D {
        return MKMapPoint(x: self.midX, y: self.minY).coordinate
    }
    
    public var eastCenterEdgeCoordinate: CLLocationCoordinate2D {
        return MKMapPoint(x: self.maxX, y: self.midY).coordinate
    }
    
    public var southCenterEdgeCoordinate: CLLocationCoordinate2D {
        return MKMapPoint(x: self.midX, y: self.maxY).coordinate
    }
}
