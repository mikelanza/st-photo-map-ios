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
    var delegateSpy: STPhotoMapViewDelegateSpy!
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
        
        self.delegateSpy = STPhotoMapViewDelegateSpy()
        self.sut.delegate = self.delegateSpy
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
        
        let annotation = STPhotoMapSeeds().photoAnnotation()
        let annotationView = self.sut.mapView(self.sut.mapView, viewFor: annotation)
        XCTAssertTrue(annotationView is PhotoAnnotationView)
    }
    
    func testShouldReturnMultiplePhotoClusterAnnotationViewForMultiplePhotoClusterAnnotation() {
        self.loadView()
        
        let annotation = STPhotoMapSeeds().multiplePhotoClusterAnnotation(count: 5)
        let annotationView = self.sut.mapView(self.sut.mapView, viewFor: annotation)
        XCTAssertTrue(annotationView is MultiplePhotoClusterAnnotationView)
    }
    
    func testShouldReturnMultiplePhotoClusterAnnotationForMultiplePhotoAnnotations() {
        self.loadView()
        
        let clusterAnnotation = self.sut.mapView(self.sut.mapView, clusterAnnotationForMemberAnnotations: STPhotoMapSeeds().photoAnnotations())
        XCTAssertTrue(clusterAnnotation is MultiplePhotoClusterAnnotation)
    }
    
    // MARK: - Test business logic
    
    func testUpdateParameter() {
        self.loadView()
        
        XCTAssertNotNil(self.sut.photoTileOverlay)
        
        let defaultParameters = Parameters.defaultParameters()
        self.sut.updateParameter(parameter: ("bbox", "50,50,50,50"))
        XCTAssertEqual(self.sut.photoTileOverlay?.model.parameters.count, defaultParameters.count + 1)
        
        self.sut.updateParameter(parameter: ("bbox", "60,60,60,60"))
        XCTAssertEqual(self.sut.photoTileOverlay?.model.parameters.count, defaultParameters.count + 1)
    }
    
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
    
    func testShouldDownloadImageForPhotoAnnotationWhenAPhotoAnnotationViewIsReturned() {
        self.loadView()
        
        let annotation = STPhotoMapSeeds().photoAnnotation()
        let _ = self.sut.mapView(self.sut.mapView, viewFor: annotation)
        XCTAssertTrue(self.interactorSpy.shouldDownloadImageForPhotoAnnotationCalled)
    }
    
    func testShouldSelectPhotoAnnotationWhenItIsSelected() {
        self.loadView()
        
        let annotation = STPhotoMapSeeds().photoAnnotation()
        let view = PhotoAnnotationView(annotation: annotation)
        self.sut.photoAnnotationView(view: view, with: annotation, didSelect: nil)
        
        XCTAssertTrue(self.interactorSpy.shouldSelectPhotoAnnotationCalled)
    }
    
    func testShouldNavigateToPhotoDetailsWhenLocationOverlayViewIsTouchedUpInside() {
        self.loadView()
        
        let model = STLocationOverlayView.Model(photoId: STPhotoMapSeeds.photoId, title: "Title", time: "21/05/2019", description: "Description")
        let view = STLocationOverlayView(model: model)
        self.sut.locationOverlayView(view: view, didSelectPhoto: STPhotoMapSeeds.photoId)
        
        XCTAssertTrue(self.interactorSpy.shouldNavigateToPhotoDetailsCalled)
    }
    
    func testShouldSelectPhotoAnnotationWhenAPhotoFromClusterAnnotationIsSelected() {
        self.loadView()
        
        let clusterAnnotation = STPhotoMapSeeds().multiplePhotoClusterAnnotation(count: 5)
        let view = MultiplePhotoClusterAnnotationView(annotation: clusterAnnotation, count: clusterAnnotation.photoIds.count)
        self.sut.multiplePhotoClusterAnnotationView(view: view, with: clusterAnnotation.annotation(for: 0)!, didSelect: nil)
        
        XCTAssertTrue(self.interactorSpy.shouldSelectPhotoAnnotationCalled)
    }
    
    func testShouldSelectPhotoClusterAnnotationWhenAPhotoClusterAnnotationIsTouchedUpInside() {
        self.loadView()
        
        let clusterAnnotation = STPhotoMapSeeds().multiplePhotoClusterAnnotation(count: 5)
        let view = MultiplePhotoClusterAnnotationView(annotation: clusterAnnotation, count: clusterAnnotation.photoIds.count)
        self.sut.multiplePhotoClusterAnnotationView(view: view, with: clusterAnnotation, didSelect: nil)
        
        XCTAssertTrue(self.interactorSpy.shouldSelectPhotoClusterAnnotationCalled)
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
    
    func testDisplayLocationAnnotations() {
        self.loadView()
        let photoAnnotations = STPhotoMapSeeds().photoAnnotations()
        
        self.sut.mapView.setCenter(photoAnnotations.first!.coordinate, animated: false)
        
        let viewModel = STPhotoMapModels.LocationAnnotations.ViewModel(annotations: photoAnnotations)
        self.sut.displayLocationAnnotations(viewModel: viewModel)
        
        self.waitForMainQueue()
        
        XCTAssertEqual(self.sut.mapView.annotations.count, photoAnnotations.count)
    }
    
    func testDisplayRemoveLocationAnnotations() {
        self.loadView()
        
        self.sut.displayRemoveLocationAnnotations()
        self.waitForMainQueue()
        
        XCTAssertTrue(self.sut.mapView.annotations.isEmpty)
    }
    
    func testDisplayNavigateToPhotoDetails() {
        self.loadView()
        
        let viewModel = STPhotoMapModels.PhotoDetailsNavigation.ViewModel(photoId: STPhotoMapSeeds.photoId)
        self.sut.displayNavigateToPhotoDetails(viewModel: viewModel)
        
        XCTAssertTrue(self.delegateSpy.photoMapViewNavigateToPhotoDetailsForPhotoIdCalled)
    }
    
    func testDisplayLocationOverlay() {
        self.loadView()
        
        let viewModel = STPhotoMapModels.LocationOverlay.ViewModel(photoId: STPhotoMapSeeds.photoId, title: "Title", time: "21/05/2019", description: "Description")
        self.sut.displayLocationOverlay(viewModel: viewModel)
        
        self.waitForMainQueue()
        
        XCTAssertNotNil(self.sut.locationOverlayView)
    }
    
    func testDisplayRemoveLocationOverlay() {
        self.loadView()
        
        self.sut.displayRemoveLocationOverlay()
        self.waitForMainQueue()
        
        XCTAssertNil(self.sut.locationOverlayView)
    }
    
    func testDisplayNavigateToSpecificPhotos() {
        self.loadView()
        
        let photoIds = STPhotoMapSeeds().multiplePhotoClusterAnnotation(count: 5).photoIds
        let viewModel = STPhotoMapModels.SpecificPhotosNavigation.ViewModel(photoIds: photoIds)
        self.sut.displayNavigateToSpecificPhotos(viewModel: viewModel)
        
        XCTAssertTrue(self.delegateSpy.photoMapViewNavigateToSpecificPhotosForPhotoIdsCalled)
    }
    
    func testDisplayZoomToCoordinate() {
        self.loadView()
        
        let mapViewSpy = MKMapViewSpy(frame: .zero)
        self.sut.mapView = mapViewSpy
        
        let viewModel = STPhotoMapModels.CoordinateZoom.ViewModel(coordinate: STPhotoMapSeeds.coordinate)
        self.sut.displayZoomToCoordinate(viewModel: viewModel)
        
        self.waitForMainQueue()
        
        XCTAssertTrue(mapViewSpy.setRegionAnimatedCalled)
    }
}
