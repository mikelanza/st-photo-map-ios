//
//  CLLocationCoordinate2D+Distance.swift
//  STPhotoMap-iOS
//
//  Created by Crasneanu Cristian on 04/06/2019.
//  Copyright © 2019 mikelanza. All rights reserved.
//

import Foundation
import MapKit

extension CLLocationCoordinate2D {
    func distance(from: CLLocationCoordinate2D) -> CLLocationDistance {
        let destination=CLLocation(latitude:from.latitude,longitude:from.longitude)
        return CLLocation(latitude: latitude, longitude: longitude).distance(from: destination)
    }
}
