//
//  STActionMapViewSpy.swift
//  STPhotoMapTests-iOS
//
//  Created by Dimitri Strauneanu on 23/05/2019.
//  Copyright © 2019 mikelanza. All rights reserved.
//

@testable import STPhotoMap
import MapKit

class STActionMapViewSpy: STActionMapView {
    var setRegionAnimatedCalled: Bool = false
    
    override func setRegion(_ region: MKCoordinateRegion, animated: Bool) {
        self.setRegionAnimatedCalled = animated
    }
}
