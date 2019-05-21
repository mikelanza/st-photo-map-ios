//
//  CLLocationCoordinate2D+Equatable.swift
//  STPhotoMap-iOS
//
//  Created by Dimitri Strauneanu on 21/05/2019.
//  Copyright © 2019 mikelanza. All rights reserved.
//

import MapKit

public func ==(lhs: CLLocationCoordinate2D?, rhs: CLLocationCoordinate2D?) -> Bool {
    return (lhs?.latitude == rhs?.latitude && lhs?.longitude == rhs?.longitude)
}
