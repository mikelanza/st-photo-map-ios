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
    var sut: STPhotoMapView!
    var interactorSpy: STPhotoMapBusinessLogicSpy!
    var window: UIWindow!
    
    // MARK: - Test lifecycle
    
    override func setUp() {
        super.setUp()
        self.window = UIWindow(frame: UIScreen.main.bounds)
        
        self.setupSTPhotoMapView()
    }
    
    override func tearDown() {
        self.window = nil
        super.tearDown()
    }
    
    private func waitForMainQueue() {
        let waitExpectation = expectation(description: "Waiting for main queue.")
        DispatchQueue.main.async {
            waitExpectation.fulfill()
        }
        waitForExpectations(timeout: 1.0)
    }
    
    // MARK: - Test setup
    
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
    
    // MARK: - Tests
    
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
        XCTAssert(self.sut.responds(to: #selector(MKMapViewDelegate.mapView(_:viewFor:))), "The photo map view does not implement mapView(_:viewFor:).")
        XCTAssert(self.sut.responds(to: #selector(MKMapViewDelegate.mapView(_:clusterAnnotationForMemberAnnotations:))), "The photo map view does not implement mapView(_:clusterAnnotationForMemberAnnotations:).")
    }
    
    // MARK: - Test map view logic
    
    func testShouldReturnPhotoTileOverlayRendererForPhotoTileOverlay() {
        self.loadView()
        
        let renderer = self.sut.mapView(self.sut.mapView, rendererFor: STPhotoMapSeeds.photoTileOverlay)
        XCTAssertTrue(renderer is STPhotoTileOverlayRenderer)
    }
    
    func testShouldReturnPhotoAnnotationViewForPhotoAnnotation() {
        self.loadView()
        
        let annotationView = self.sut.mapView(self.sut.mapView, viewFor: STPhotoMapSeeds.photoAnnotation)
        XCTAssertTrue(annotationView is PhotoAnnotationView)
    }
    
    func testShouldReturnMultiplePhotoClusterAnnotationViewForMultiplePhotoClusterAnnotation() {
        self.loadView()
        
        let annotationView = self.sut.mapView(self.sut.mapView, viewFor: STPhotoMapSeeds.multiplePhotoClusterAnnotation)
        XCTAssertTrue(annotationView is MultiplePhotoClusterAnnotationView)
    }
    
    func testShouldReturnMultiplePhotoClusterAnnotationForMultiplePhotoAnnotations() {
        self.loadView()
        
        let clusterAnnotation = self.sut.mapView(self.sut.mapView, clusterAnnotationForMemberAnnotations: [STPhotoMapSeeds.photoAnnotation])
        XCTAssertTrue(clusterAnnotation is MultiplePhotoClusterAnnotation)
    }
    
    // MARK: - Test business logic
    
    func testShouldUpdateVisibleTilesWhenRegionDidChangeAnimated() {
        self.loadView()
        
        self.sut.mapView(self.sut.mapView, regionDidChangeAnimated: true)
        XCTAssertTrue(self.interactorSpy.shouldUpdateVisibleTilesCalled)
    }
    
    func testShouldCacheGeojsonObjectsWhenRegionDidChangeAnimated() {
        self.loadView()
        
        self.sut.mapView(self.sut.mapView, regionDidChangeAnimated: true)
        XCTAssertTrue(self.interactorSpy.shouldCacheGeojsonObjectsCalled)
    }
    
    func testShouldDetermineEntityLevelWhenRegionDidChangeAnimated() {
        self.loadView()
        
        self.sut.mapView(self.sut.mapView, regionDidChangeAnimated: true)
        XCTAssertTrue(self.interactorSpy.shouldDetermineEntityLevelCalled)
    }
    
    // MARK: - Test display logic
    
    func testDisplayLoadingState() {
        self.loadView()
        self.sut.displayLoadingState()
        
        self.waitForMainQueue()
        
        XCTAssertFalse(self.sut.progressView.isHidden)
        XCTAssertEqual(self.sut.progressView.progress, 1.0)
    }
    
    func testDisplayNotLoadingState() {
        self.loadView()
        self.sut.displayNotLoadingState()
        
        self.waitForMainQueue()
        
        XCTAssertTrue(self.sut.progressView.isHidden)
        XCTAssertEqual(self.sut.progressView.progress, 0.0)
    }
    
    func testDisplayEntityLevel() {
        self.loadView()
        let viewModel = STPhotoMapModels.EntityZoomLevel.ViewModel(title: STPhotoMapStyle.EntityLevelViewModel().blockTitle, image: STPhotoMapStyle.EntityLevelViewModel().blockImage)
        self.sut.displayEntityLevel(viewModel: viewModel)
        
        self.waitForMainQueue()
        
        XCTAssertNotNil(self.sut.entityLevelView)
    }
}
