//
//  MKPolygon+MapPoint.swift
//  STPhotoMap-iOS
//
//  Created by Dimitri Strauneanu on 02/07/2019.
//  Copyright © 2019 mikelanza. All rights reserved.
//

import MapKit

extension MKPolygon {
    func containsMapPoint(_ mapPoint: MKMapPoint) -> Bool {
        let renderer = MKPolygonRenderer(polygon: self)
        let point = renderer.point(for: mapPoint)
        return renderer.path?.contains(point) ?? false
    }
}
