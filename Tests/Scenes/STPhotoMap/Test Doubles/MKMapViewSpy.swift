//
//  MKMapViewSpy.swift
//  STPhotoMapTests-iOS
//
//  Created by Dimitri Strauneanu on 21/05/2019.
//  Copyright © 2019 mikelanza. All rights reserved.
//

@testable import STPhotoMap
import MapKit

class MKMapViewSpy: MKMapView {
    var setRegionAnimatedCalled: Bool = false
    
    override func setRegion(_ region: MKCoordinateRegion, animated: Bool) {
        self.setRegionAnimatedCalled = animated
    }
}
