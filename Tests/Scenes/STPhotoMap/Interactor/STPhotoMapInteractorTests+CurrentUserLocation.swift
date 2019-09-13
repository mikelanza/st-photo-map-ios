//
//  STPhotoMapInteractorTests+CurrentUserLocation.swift
//  STPhotoMapTests-iOS
//
//  Created by Dimitri Strauneanu on 13/09/2019.
//  Copyright © 2019 mikelanza. All rights reserved.
//

@testable import STPhotoMap
import XCTest
import MapKit
import STPhotoCore

class STPhotoMapInteractorCurrentUserLocationTests: XCTestCase {
    var sut: STPhotoMapInteractor!
    var presenterSpy: STPhotoMapPresentationLogicSpy!
    var currentUserLocationHandlerSpy: STPhotoMapCurrentUserLocationHandlerSpy!
    
    // MARK: - Test lifecycle
    
    override func setUp() {
        super.setUp()
        self.setupSTPhotoMapInteractor()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    // MARK: - Test setup
    
    func setupSTPhotoMapInteractor() {
        self.sut = STPhotoMapInteractor()
        
        self.presenterSpy = STPhotoMapPresentationLogicSpy()
        self.sut.presenter = self.presenterSpy
        
        self.currentUserLocationHandlerSpy = STPhotoMapCurrentUserLocationHandlerSpy()
        self.currentUserLocationHandlerSpy.delegate = self.sut
        self.sut.currentUserLocationHandler = self.currentUserLocationHandlerSpy
    }
    
    // MARK: - Tests
    
    func testShouldAskForLocationPermissionsWhenStatusIsAuthorizedAlways() {
        self.currentUserLocationHandlerSpy.status = .authorizedAlways
        
        self.sut.shouldAskForLocationPermissions()
        XCTAssertTrue(self.presenterSpy.presentCenterToCoordinateCalled)
    }
    
    func testShouldAskForLocationPermissionsWhenStatusIsAuthorizedWhenInUse() {
        self.currentUserLocationHandlerSpy.status = .authorizedWhenInUse
        
        self.sut.shouldAskForLocationPermissions()
        XCTAssertTrue(self.presenterSpy.presentCenterToCoordinateCalled)
    }
    
    func testShouldAskForLocationPermissionsWhenStatusIsNotDetermined() {
        self.currentUserLocationHandlerSpy.status = .notDetermined
        
        self.sut.shouldAskForLocationPermissions()
        XCTAssertTrue(self.currentUserLocationHandlerSpy.requestWhenInUseAuthorizationCalled)
    }
    
    func testShouldAskForLocationPermissionsWhenStatusIsDenied() {
        self.currentUserLocationHandlerSpy.status = .denied
        
        self.sut.shouldAskForLocationPermissions()
        XCTAssertTrue(self.presenterSpy.presentLocationAccessDeniedAlertCalled)
    }
    
    func testShouldAskForLocationPermissionsWhenChangingStatusForAuthorizedAlways() {
        self.sut.currentUserLocationHandler.locationManager(CLLocationManager(), didChangeAuthorization: CLAuthorizationStatus.authorizedAlways)
        XCTAssertTrue(self.presenterSpy.presentCenterToCoordinateCalled)
    }
    
    func testShouldAskForLocationPermissionsWhenChangingStatusForAuthorizedWhenInUse() {
        self.sut.currentUserLocationHandler.locationManager(CLLocationManager(), didChangeAuthorization: CLAuthorizationStatus.authorizedWhenInUse)
        XCTAssertTrue(self.presenterSpy.presentCenterToCoordinateCalled)
    }
    
    func testShouldAskForLocationPermissionsWhenLocationManagerDidUpdateLocations() {
        let locations = [CLLocation(latitude: STPhotoMapSeeds.coordinate.latitude, longitude: STPhotoMapSeeds.coordinate.longitude)]
        self.sut.currentUserLocationHandler.locationManager(CLLocationManager(), didUpdateLocations: locations)
        
        XCTAssertTrue(self.presenterSpy.presentCenterToCoordinateCalled)
        XCTAssertTrue(self.currentUserLocationHandlerSpy.didZoomToUserLocation)
    }
    
    func testShouldAskForLocationPermissionsWhenLocationManagerDidUpdateLocationsWhenItDidZoomToUserLocation() {
        self.currentUserLocationHandlerSpy.didZoomToUserLocation = true
        
        let locations = [CLLocation(latitude: STPhotoMapSeeds.coordinate.latitude, longitude: STPhotoMapSeeds.coordinate.longitude)]
        self.sut.currentUserLocationHandler.locationManager(CLLocationManager(), didUpdateLocations: locations)
        
        XCTAssertFalse(self.presenterSpy.presentCenterToCoordinateCalled)
        XCTAssertTrue(self.currentUserLocationHandlerSpy.didZoomToUserLocation)
    }
    
    func testShouldAskForLocationPermissionsWhenLocationManagerDidUpdateLocationsWhenThereAreNoLocations() {
        self.sut.currentUserLocationHandler.locationManager(CLLocationManager(), didUpdateLocations: [])
        XCTAssertFalse(self.presenterSpy.presentCenterToCoordinateCalled)
        XCTAssertFalse(self.currentUserLocationHandlerSpy.didZoomToUserLocation)
    }
}
