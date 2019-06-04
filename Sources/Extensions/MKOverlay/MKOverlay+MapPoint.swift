//
//  MKOverlay+MapPoint.swift
//  STPhotoMap-iOS
//
//  Created by Dimitri Strauneanu on 23/05/2019.
//  Copyright © 2019 mikelanza. All rights reserved.
//

import MapKit

extension MKOverlay {
    func containsMapPoint(_ mapPoint: MKMapPoint) -> Bool {
        let renderer = MKOverlayPathRenderer(overlay: self)
        let point = renderer.point(for: mapPoint)
        return renderer.path?.contains(point) ?? false
    }
}
