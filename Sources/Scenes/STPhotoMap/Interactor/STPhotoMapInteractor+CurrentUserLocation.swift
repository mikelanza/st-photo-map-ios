//
//  STPhotoMapInteractor+CurrentUserLocation.swift
//  STPhotoMap-iOS
//
//  Created by Dimitri Strauneanu on 06/06/2019.
//  Copyright © 2019 mikelanza. All rights reserved.
//

import Foundation
import MapKit
import STPhotoCore

extension STPhotoMapInteractor {
    func shouldAskForLocationPermissions() {
        switch self.currentUserLocationHandler.locationAuthorizationStatus {
            case .authorizedAlways?, .authorizedWhenInUse?: self.handleAuthorizedLocationPermissions(); break
            case .notDetermined?: self.handleNotDeterminedLocationPermissions(); break
            case .denied?: self.handleDeniedLocationPermissions(); break
            default: break
        }
    }
    
    private func handleAuthorizedLocationPermissions() {
        if let location = self.currentUserLocationHandler.location {
            self.presentCenterToCoordinate(coordinate: location.coordinate)
        }
    }
    
    private func handleNotDeterminedLocationPermissions() {
        self.currentUserLocationHandler.requestWhenInUseAuthorization()
    }
    
    private func handleDeniedLocationPermissions() {
        self.presenter?.presentLocationAccessDeniedAlert()
    }
    
    private func presentCenterToCoordinate(coordinate: CLLocationCoordinate2D) {
        self.presenter?.presentCenterToCoordinate(response: STPhotoMapModels.CoordinateCenter.Response(coordinate: coordinate, entityLevel: EntityLevel.block))
    }
}

extension STPhotoMapInteractor: STPhotoMapCurrentUserLocationHandlerDelegate {
    func currentUserLocationHandler(handler: STPhotoMapCurrentUserLocationHandler?, centerToCoordinate coordinate: CLLocationCoordinate2D) {
        self.presentCenterToCoordinate(coordinate: coordinate)
    }
}
