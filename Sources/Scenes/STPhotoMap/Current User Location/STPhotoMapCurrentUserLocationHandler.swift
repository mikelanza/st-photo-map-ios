//
//  STPhotoMapCurrentUserLocationHandler.swift
//  STPhotoMap-iOS
//
//  Created by Dimitri Strauneanu on 06/06/2019.
//  Copyright © 2019 Streetography. All rights reserved.
//

import MapKit

protocol STPhotoMapCurrentUserLocationHandlerDelegate: NSObjectProtocol {
    func currentUserLocationHandler(handler: STPhotoMapCurrentUserLocationHandler?, centerToCoordinate coordinate: CLLocationCoordinate2D)
}

class STPhotoMapCurrentUserLocationHandler: NSObject {
    var locationManager: CLLocationManager?
    var didZoomToUserLocation: Bool = false
    
    var locationServicesEnabled: Bool {
        return CLLocationManager.locationServicesEnabled()
    }
    
    var locationAuthorizationStatus: CLAuthorizationStatus? {
        if self.locationServicesEnabled {
            return CLLocationManager.authorizationStatus()
        }
        return nil
    }
    
    var location: CLLocation? {
        return self.locationManager?.location
    }
    
    weak var delegate: STPhotoMapCurrentUserLocationHandlerDelegate?
    
    override init() {
        super.init()
        
        if self.locationServicesEnabled {
            self.locationManager = CLLocationManager()
            self.locationManager?.delegate = self
            self.locationManager?.desiredAccuracy = kCLLocationAccuracyThreeKilometers
        }
    }
    
    func requestWhenInUseAuthorization() {
        self.locationManager?.requestWhenInUseAuthorization()
    }
}

extension STPhotoMapCurrentUserLocationHandler: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
            case .authorizedAlways, .authorizedWhenInUse:
                if let location = self.location {
                    self.delegate?.currentUserLocationHandler(handler: self, centerToCoordinate: location.coordinate)
                }
                break
            default: break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if !self.didZoomToUserLocation, let location = locations.last {
            self.delegate?.currentUserLocationHandler(handler: self, centerToCoordinate: location.coordinate)
            self.didZoomToUserLocation = true
        }
    }
}
