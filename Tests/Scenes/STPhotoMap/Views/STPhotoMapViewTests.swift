//
//  STPhotoMapViewTests.swift
//  STPhotoMapTests-iOS
//
//  Created by Dimitri Strauneanu on 10/05/2019.
//  Copyright © 2019 mikelanza. All rights reserved.
//

@testable import STPhotoMap
import XCTest
import MapKit

class STPhotoMapViewTests: XCTestCase {
    // MARK: Subject under test
    
    var sut: STPhotoMapView!
    var interactorSpy: STPhotoMapBusinessLogicSpy!
    var window: UIWindow!
    
    // MARK: Test lifecycle
    
    override func setUp() {
        super.setUp()
        self.window = UIWindow()
        self.window.bounds = UIScreen.main.bounds
        
        self.setupSTPhotoMapView()
    }
    
    override func tearDown() {
        self.window = nil
        super.tearDown()
    }
    
    // MARK: Test setup
    
    func setupSTPhotoMapView() {
        self.sut = STPhotoMapView()
        self.sut.translatesAutoresizingMaskIntoConstraints = false
        
        self.interactorSpy = STPhotoMapBusinessLogicSpy()
        self.sut.interactor = self.interactorSpy
    }
    
    func loadView() {
        self.window.addSubview(self.sut)
        
        self.setupSubviewsConstraints()
        
        RunLoop.current.run(until: Date())
    }
    
    private func setupSubviewsConstraints() {
        self.setupPhotoMapViewConstraints()
    }
    
    private func setupPhotoMapViewConstraints() {
        self.sut.topAnchor.constraint(equalTo: self.window.topAnchor).isActive = true
        self.sut.bottomAnchor.constraint(equalTo: self.window.bottomAnchor).isActive = true
        self.sut.leadingAnchor.constraint(equalTo: self.window.leadingAnchor).isActive = true
        self.sut.trailingAnchor.constraint(equalTo: self.window.trailingAnchor).isActive = true
    }
    
    // MARK: Test doubles
    
    // MARK: Tests
    
    func testIfPhotoMapViewContainsMapView() {
        self.loadView()
        XCTAssertNotNil(self.sut.mapView)
    }
    
    func testIfPhotoMapViewConformsToMKMapViewDelegate() {
        self.loadView()
        XCTAssert(self.sut.conforms(to: MKMapViewDelegate.self), "The photo map view does not conform to MKMapViewDelegate protocol.")
    }
    
    func testIfPhotoMapViewHasSetMKMapViewDelegate() {
        self.loadView()
        XCTAssertNotNil(self.sut.mapView.delegate, "The MKMapViewDelegate from the photo map view was not set.")
    }
    
    func testIfPhotoMapViewImplementsMKMapViewDelegateMethods() {
        self.loadView()
        XCTAssert(self.sut.responds(to: #selector(MKMapViewDelegate.mapView(_:regionDidChangeAnimated:))), "The photo map view does not implement mapView(_:regionDidChangeAnimated:).")
        XCTAssert(self.sut.responds(to: #selector(MKMapViewDelegate.mapView(_:rendererFor:))), "The photo map view does not implement mapView(_:rendererFor:).")
    }
    
    func testDisplayLoadingState() {
        self.loadView()
        self.sut.displayLoadingState()
        
        XCTAssertFalse(self.sut.progressView.isHidden)
        XCTAssertEqual(self.sut.progressView.progress, 1.0)
    }
    
    func testDisplayNotLoadingState() {
        self.loadView()
        self.sut.displayNotLoadingState()
        
        XCTAssertTrue(self.sut.progressView.isHidden)
        XCTAssertEqual(self.sut.progressView.progress, 0.0)
    }
    
    func testUpdateTilesWhenRegionDidChangeAnimated() {
        self.loadView()
        
        self.sut.mapView(self.sut.mapView, regionDidChangeAnimated: true)
        XCTAssertTrue(self.interactorSpy.shouldUpdateVisibleTilesCalled)
    }
}
