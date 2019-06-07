//
//  MKMapView+ZoomLevel.swift
//  STPhotoMap-iOS
//
//  Created by Crasneanu Cristian on 06/06/2019.
//  Copyright © 2019 mikelanza. All rights reserved.
//

import MapKit

extension MKMapView {
    public func zoomLevel(minZoom: Int = 0, maxZoom: Int = 20) -> Int {
        let zoom = Int(round(log2(360 * Double(self.frame.size.width) / (self.region.span.longitudeDelta * 128))))
        if zoom < minZoom {
            return minZoom
        }
        if zoom > maxZoom {
            return maxZoom
        }
        return zoom
    }
}
