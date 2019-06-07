//
//  MKMapView+BoundingBox.swift
//  STPhotoMap-iOS
//
//  Created by Crasneanu Cristian on 16/05/2019.
//  Copyright © 2019 mikelanza. All rights reserved.
//

import Foundation
import MapKit

extension MKMapView {
    public func boundingBox() -> BoundingBox {
        return self.visibleMapRect.boundingBox()
    }
}
