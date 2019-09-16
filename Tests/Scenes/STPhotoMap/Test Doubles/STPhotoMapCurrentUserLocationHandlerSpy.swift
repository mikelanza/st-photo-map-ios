//
//  STPhotoMapCurrentUserLocationHandlerSpy.swift
//  STPhotoMapTests-iOS
//
//  Created by Dimitri Strauneanu on 06/06/2019.
//  Copyright © 2019 Streetography. All rights reserved.
//

@testable import STPhotoMap
import MapKit

class STPhotoMapCurrentUserLocationHandlerSpy: STPhotoMapCurrentUserLocationHandler {
    var status: CLAuthorizationStatus? = .none
    var requestWhenInUseAuthorizationCalled: Bool = false
    
    override var locationAuthorizationStatus: CLAuthorizationStatus? {
        return self.status
    }
    
    override var location: CLLocation? {
        return CLLocation(latitude: STPhotoMapSeeds.coordinate.latitude, longitude: STPhotoMapSeeds.coordinate.longitude)
    }
    
    override func requestWhenInUseAuthorization() {
        self.requestWhenInUseAuthorizationCalled = true
        super.requestWhenInUseAuthorization()
    }
}
