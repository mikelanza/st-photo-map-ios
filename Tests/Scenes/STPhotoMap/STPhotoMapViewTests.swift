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
import SafariServices

class STPhotoMapViewTests: XCTestCase {
    var sut: STPhotoMapView!
    var interactorSpy: STPhotoMapBusinessLogicSpy!
    var routerSpy: STPhotoMapRoutingLogicSpy!
    var tileOverlayRendererSpy: STPhotoTileOverlayRendererSpy!

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
    
    private func waitForBackgroundQueue() {
        let waitExpectation = expectation(description: "Waiting for background queue.")
        DispatchQueue.global().async {
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
        
        self.routerSpy = STPhotoMapRoutingLogicSpy()
        self.sut.router = self.routerSpy
        
        self.tileOverlayRendererSpy = STPhotoTileOverlayRendererSpy(tileOverlay: MKTileOverlay())
        self.sut.tileOverlayRenderer = self.tileOverlayRendererSpy
        
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
    
    func testIfPhotoMapViewContainsUserLocationButton() {
        self.loadView()
        XCTAssertNotNil(self.sut.userLocationButton)
    }
    
    func testIfPhotoMapViewContainsDataSourcesButton() {
        self.loadView()
        XCTAssertNotNil(self.sut.dataSourcesButton)
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
        let renderer = self.sut.mapView(self.sut.mapView, rendererFor: STPhotoMapSeeds.photoTileOverlay)
        XCTAssertTrue(renderer is STPhotoTileOverlayRenderer)
    }
    
    func testShouldReturnCarouselOverlayRendererForCarouselOverlay() {
        let renderer = self.sut.mapView(self.sut.mapView, rendererFor: STPhotoMapSeeds().carouselOverlay())
        XCTAssertTrue(renderer is STCarouselOverlayRenderer)
    }
    
    func testShouldReturnPhotoAnnotationViewForPhotoAnnotation() {
        let annotation = STPhotoMapSeeds().photoAnnotation()
        let annotationView = self.sut.mapView(self.sut.mapView, viewFor: annotation)
        XCTAssertTrue(annotationView is PhotoAnnotationView)
    }
    
    func testShouldReturnMultiplePhotoClusterAnnotationViewForMultiplePhotoClusterAnnotation() {
        let annotation = STPhotoMapSeeds().multiplePhotoClusterAnnotation(count: 5)
        let annotationView = self.sut.mapView(self.sut.mapView, viewFor: annotation)
        XCTAssertTrue(annotationView is MultiplePhotoClusterAnnotationView)
    }
    
    func testShouldReturnMultiplePhotoClusterAnnotationForMultiplePhotoAnnotations() {
        let clusterAnnotation = self.sut.mapView(self.sut.mapView, clusterAnnotationForMemberAnnotations: STPhotoMapSeeds().photoAnnotations())
        XCTAssertTrue(clusterAnnotation is MultiplePhotoClusterAnnotation)
    }
    
    // MARK: - Test business logic
    
    func testUpdateParameter() {
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
        
        self.waitForBackgroundQueue()
        XCTAssertTrue(self.interactorSpy.shouldUpdateVisibleTilesCalled)
    }
    
    func testShouldUpdateVisibleMapRectWhenRegionDidChangeAnimated() {
        self.loadView()
        
        self.sut.mapView(self.sut.mapView, regionDidChangeAnimated: true)
        
        self.waitForBackgroundQueue()
        XCTAssertTrue(self.interactorSpy.shouldUpdateVisibleMapRect)
    }
    
    func testShouldCacheGeojsonObjectsWhenRegionDidChangeAnimated() {
        self.loadView()
        
        self.sut.mapView(self.sut.mapView, regionDidChangeAnimated: true)
        
        self.waitForBackgroundQueue()
        XCTAssertTrue(self.interactorSpy.shouldCacheGeojsonObjectsCalled)
    }
    
    func testShouldDetermineEntityLevelWhenRegionDidChangeAnimated() {
        self.loadView()
        
        self.sut.mapView(self.sut.mapView, regionDidChangeAnimated: true)
        
        self.waitForBackgroundQueue()
        XCTAssertTrue(self.interactorSpy.shouldDetermineEntityLevelCalled)
    }
    
    func testShouldDetermineLocationLevelWhenRegionDidChangeAnimated() {
        self.loadView()
        
        self.sut.mapView(self.sut.mapView, regionDidChangeAnimated: true)
        
        self.waitForBackgroundQueue()
        XCTAssertTrue(self.interactorSpy.shouldDetermineLocationLevelCalled)
    }
    
    func testShouldDetermineCarouselWhenRegionDidChangeAnimated() {
        self.loadView()
        
        self.sut.mapView(self.sut.mapView, regionDidChangeAnimated: true)
        
        self.waitForBackgroundQueue()
        XCTAssertTrue(self.interactorSpy.shouldDetermineCarouselCalled)
    }
    
    func testShouldDetermineSelectedPhotoAnnotationWhenRegionDidChangeAnimated() {
        self.loadView()
        
        self.sut.mapView(self.sut.mapView, regionDidChangeAnimated: true)
        
        self.waitForBackgroundQueue()
        XCTAssertTrue(self.interactorSpy.shouldDetermineSelectedPhotoAnnotationCalled)
    }
    
    func testShouldPreloadImageTilesWhenMapDidPan() {
        self.loadView()
        
        let gesture = UIPanGestureRecognizer()
        gesture.state = .ended
        
        self.sut.mapViewDidPan(gesture)

        XCTAssertTrue(tileOverlayRendererSpy.predownloadCalled)
    }
    
    func testShouldDownloadImageForPhotoAnnotationWhenAPhotoAnnotationViewIsReturned() {
        let annotation = STPhotoMapSeeds().photoAnnotation()
        let _ = self.sut.mapView(self.sut.mapView, viewFor: annotation)
        XCTAssertTrue(self.interactorSpy.shouldDownloadImageForPhotoAnnotationCalled)
    }
    
    func testShouldSelectPhotoAnnotationWhenItIsSelected() {
        let annotation = STPhotoMapSeeds().photoAnnotation()
        let view = PhotoAnnotationView(annotation: annotation)
        self.sut.photoAnnotationView(view: view, with: annotation, didSelect: nil)
        
        XCTAssertTrue(self.interactorSpy.shouldSelectPhotoAnnotationCalled)
        XCTAssertTrue(self.interactorSpy.shouldUpdateSelectedPhotoAnnotationCalled)
        XCTAssertEqual(self.sut.annotationHandler.selectedPhotoAnnotation, annotation)
    }
    
    func testShouldNavigateToPhotoDetailsWhenLocationOverlayViewIsTouchedUpInside() {
        let model = STLocationOverlayView.Model(photoId: STPhotoMapSeeds.photoId, title: "Title", time: "21/05/2019", description: "Description")
        let view = STLocationOverlayView(model: model)
        self.sut.locationOverlayView(view: view, didSelectPhoto: STPhotoMapSeeds.photoId)
        
        XCTAssertTrue(self.interactorSpy.shouldNavigateToPhotoDetailsCalled)
    }
    
    func testShouldSelectPhotoAnnotationWhenAPhotoFromClusterAnnotationIsSelected() {
        let clusterAnnotation = STPhotoMapSeeds().multiplePhotoClusterAnnotation(count: 5)
        let photoAnnotation = clusterAnnotation.annotation(for: 0)!
        let view = MultiplePhotoClusterAnnotationView(annotation: clusterAnnotation, count: clusterAnnotation.photoIds.count)
        self.sut.multiplePhotoClusterAnnotationView(view: view, with: clusterAnnotation, with: photoAnnotation, didSelect: nil)
        
        XCTAssertTrue(self.interactorSpy.shouldSelectPhotoClusterAnnotationCalled)
        XCTAssertTrue(self.interactorSpy.shouldUpdateSelectedPhotoAnnotationCalled)
        XCTAssertEqual(self.sut.annotationHandler.selectedPhotoAnnotation, photoAnnotation)
    }
    
    func testShouldInflatePhotoClusterAnnotationWhenAPhotoClusterAnnotationIsTouchedUpInside() {
        self.loadView()
        
        let clusterAnnotation = STPhotoMapSeeds().multiplePhotoClusterAnnotation(count: 5)
        let view = MultiplePhotoClusterAnnotationView(annotation: clusterAnnotation, count: clusterAnnotation.photoIds.count)
        self.sut.multiplePhotoClusterAnnotationView(view: view, with: clusterAnnotation, didSelect: nil)
        
        XCTAssertTrue(self.interactorSpy.shouldInflatePhotoClusterAnnotationCalled)
        XCTAssertEqual(self.sut.annotationHandler.selectedPhotoClusterAnnotation, clusterAnnotation)
    }
    
    func testShouldNavigateToPhotoDetailsWhenACarouselPhotoIsSelected() {
        self.sut.actionMapView(mapView: self.sut.mapView, didSelectCarouselPhoto: STPhotoMapSeeds.photoId, atLocation: STPhotoMapSeeds.location)
        XCTAssertTrue(self.interactorSpy.shouldNavigateToPhotoDetailsCalled)
    }
    
    func testShouldNavigateToPhotoCollectionWhenACarouselOverlayIsSelected() {
        let overlay = STCarouselOverlay(polygon: nil, polyline: nil, model: STCarouselOverlayModel())
        self.sut.actionMapView(mapView: self.sut.mapView, didSelect: overlay, atLocation: STPhotoMapSeeds.location)
        
        XCTAssertTrue(self.interactorSpy.shouldNavigateToPhotoCollectionCalled)
    }
    
    func testShouldSelectCarouselWhenATileOverlayIsSelected() {
        self.sut.actionMapView(mapView: self.sut.mapView, didSelect: STPhotoMapSeeds.tileCoordinate, atLocation: STPhotoMapSeeds.location)
        XCTAssertTrue(self.interactorSpy.shouldSelectCarouselCalled)
    }
    
    func testShouldAskForLocationPermissionsWhenUserLocationButtonIsTouchedUpInside() {
        self.sut.touchUpInsideUserLocationButton(button: nil)
        XCTAssertTrue(self.interactorSpy.shouldAskForLocationPermissionsCalled)
    }
    
    func testShouldOpenDataSourcesLinkWhenDataSourcesButtonIsTouchedUpInside() {
        self.sut.touchUpInsideDataSourcesButton(button: nil)
        XCTAssertTrue(self.interactorSpy.shouldOpenDataSourcesLinkCalled)
    }
    
    // MARK: - Test display logic
    
    func testDisplayLoadingState() {
        self.sut.displayLoadingState()
        
        self.waitForMainQueue()
        
        XCTAssertFalse(self.sut.progressView.isHidden)
        XCTAssertEqual(self.sut.progressView.progress, 1.0)
    }
    
    func testDisplayNotLoadingState() {
        self.sut.displayNotLoadingState()
        
        self.waitForMainQueue()
        
        XCTAssertTrue(self.sut.progressView.isHidden)
        XCTAssertEqual(self.sut.progressView.progress, 0.0)
    }
    
    func testDisplayEntityLevel() {
        let viewModel = STPhotoMapModels.EntityZoomLevel.ViewModel(title: STPhotoMapStyle.shared.entityLevelViewModel.blockTitle, image: STPhotoMapStyle.shared.entityLevelViewModel.blockImage)
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
        
        XCTAssertEqual(self.sut.annotationHandler.annotations.count, photoAnnotations.count)
        XCTAssertEqual(self.sut.mapView.annotations.count, photoAnnotations.count)
    }
    
    func testDisplayRemoveLocationAnnotations() {
        let annotation = STPhotoMapSeeds().photoAnnotation()
        self.sut.mapView.addAnnotation(annotation)
        self.sut.annotationHandler.addAnnotation(annotation: annotation)
        
        self.sut.displayRemoveLocationAnnotations()
        self.waitForMainQueue()
        
        XCTAssertTrue(self.sut.annotationHandler.annotations.isEmpty)
        XCTAssertTrue(self.sut.mapView.annotations.isEmpty)
    }
    
    func testDisplayNavigateToPhotoDetails() {
        let viewModel = STPhotoMapModels.PhotoDetailsNavigation.ViewModel(photoId: STPhotoMapSeeds.photoId)
        self.sut.displayNavigateToPhotoDetails(viewModel: viewModel)
        
        XCTAssertTrue(self.delegateSpy.photoMapViewNavigateToPhotoDetailsForPhotoIdCalled)
    }
    
    func testDisplayLocationOverlay() {
        let viewModel = STPhotoMapModels.LocationOverlay.ViewModel(photoId: STPhotoMapSeeds.photoId, title: "Title", time: "21/05/2019", description: "Description")
        self.sut.displayLocationOverlay(viewModel: viewModel)
        
        self.waitForMainQueue()
        
        XCTAssertNotNil(self.sut.locationOverlayView)
    }
    
    func testDisplayRemoveLocationOverlay() {
        self.sut.displayRemoveLocationOverlay()
        self.waitForMainQueue()
        
        XCTAssertNil(self.sut.locationOverlayView)
    }
    
    func testDisplayNavigateToSpecificPhotos() {
        let photoIds = STPhotoMapSeeds().multiplePhotoClusterAnnotation(count: 5).photoIds
        let viewModel = STPhotoMapModels.SpecificPhotosNavigation.ViewModel(photoIds: photoIds)
        self.sut.displayNavigateToSpecificPhotos(viewModel: viewModel)
        
        XCTAssertTrue(self.delegateSpy.photoMapViewNavigateToSpecificPhotosForPhotoIdsCalled)
    }
    
    func testDisplayZoomToCoordinate() {
        let mapViewSpy = STActionMapViewSpy(frame: .zero)
        self.sut.mapView = mapViewSpy
        
        let viewModel = STPhotoMapModels.CoordinateZoom.ViewModel(coordinate: STPhotoMapSeeds.coordinate)
        self.sut.displayZoomToCoordinate(viewModel: viewModel)
        
        self.waitForMainQueue()
        
        XCTAssertTrue(mapViewSpy.setRegionAnimatedCalled)
    }
    
    func testDisplaySelectPhotoAnnotation() {
        let photoAnnotation = STPhotoMapSeeds().photoAnnotation()
        XCTAssertFalse(photoAnnotation.isSelected)
        
        let viewModel = STPhotoMapModels.PhotoAnnotationSelection.ViewModel(photoAnnotation: photoAnnotation)
        self.sut.displaySelectPhotoAnnotation(viewModel: viewModel)
        
        XCTAssertTrue(photoAnnotation.isSelected)
    }
    
    func testDisplayDeselectPhotoAnnotation() {
        let photoAnnotation = STPhotoMapSeeds().photoAnnotation()
        photoAnnotation.isSelected = true
        XCTAssertTrue(photoAnnotation.isSelected)
        
        let viewModel = STPhotoMapModels.PhotoAnnotationDeselection.ViewModel(photoAnnotation: photoAnnotation)
        self.sut.displayDeselectPhotoAnnotation(viewModel: viewModel)
        
        XCTAssertFalse(photoAnnotation.isSelected)
    }
    
    func testDisplayRemoveCarousel() {
        self.sut.mapView.removeOverlays(self.sut.mapView.overlays)
        
        let overlay = STPhotoMapSeeds().carouselOverlay()
        self.sut.carouselOverlays = [overlay]
        self.sut.mapView.addOverlay(STPhotoMapSeeds().carouselOverlay())
        
        self.sut.displayRemoveCarousel()
        
        self.waitForMainQueue()
        
        for overlay in self.sut.mapView.overlays {
            XCTAssertFalse(overlay is STCarouselOverlay)
        }
        
        XCTAssertEqual(self.sut.carouselOverlays.count, 0)
        XCTAssertEqual(self.sut.mapView.overlays.count, 0)
    }
    
    func testDisplayNavigateToPhotoCollection() {
        let viewModel = STPhotoMapModels.PhotoCollectionNavigation.ViewModel(location: STPhotoMapSeeds.location, entityLevel: EntityLevel.block)
        self.sut.displayNavigateToPhotoCollection(viewModel: viewModel)
        
        XCTAssertTrue(self.delegateSpy.photoMapViewNavigateToPhotoCollectionForLocationEntityLevelCalled)
    }
    
    func testDisplayNewCarousel() {
        self.sut.carouselOverlays.removeAll()
        self.sut.mapView.removeOverlays(self.sut.mapView.overlays)
        XCTAssertEqual(self.sut.mapView.overlays.count, 0)
        
        let viewModel = STPhotoMapModels.NewCarousel.ViewModel(overlays: STPhotoMapSeeds().carouselOverlays())
        self.sut.displayNewCarousel(viewModel: viewModel)
        
        self.waitForMainQueue()
        
        for overlay in self.sut.mapView.overlays {
            XCTAssertTrue(overlay is STCarouselOverlay)
        }
        
        XCTAssertEqual(self.sut.carouselOverlays.count, 1)
        XCTAssertEqual(self.sut.mapView.overlays.count, 1)
    }
    
    func testDisplayNewSelectedPhotoAnnotationWhenThereAreNoPhotoAnnotationsOnMap() {
        let photoAnnotation = STPhotoMapSeeds().photoAnnotation()
        self.sut.annotationHandler.removeAllAnnotations()
        self.sut.mapView.removeAnnotations(self.sut.mapView.annotations)
        
        let viewModel = STPhotoMapModels.PhotoAnnotationSelection.ViewModel(photoAnnotation: photoAnnotation)
        self.sut.displayNewSelectedPhotoAnnotation(viewModel: viewModel)
        
        self.waitForMainQueue()
        
        XCTAssertEqual(self.sut.annotationHandler.annotations.count, 1)
        XCTAssertEqual(self.sut.mapView.annotations.count, 1)
        
        XCTAssertEqual(self.sut.annotationHandler.selectedPhotoAnnotation, photoAnnotation)
    }
    
    func testDisplayNewSelectedPhotoAnnotationWhenThereArePhotoAnnotationsOnMap() {
        let photoAnnotations = STPhotoMapSeeds().photoAnnotations()
        let firstPhotoAnnotation = photoAnnotations.first!
        let secondPhotoAnnotation = photoAnnotations.last!
        
        self.sut.annotationHandler.addAnnotation(annotation: firstPhotoAnnotation)
        self.sut.mapView.addAnnotation(firstPhotoAnnotation)
        
        let viewModel = STPhotoMapModels.PhotoAnnotationSelection.ViewModel(photoAnnotation: secondPhotoAnnotation)
        self.sut.displayNewSelectedPhotoAnnotation(viewModel: viewModel)
        
        self.waitForMainQueue()
        
        XCTAssertEqual(self.sut.annotationHandler.annotations.count, 2)
        XCTAssertEqual(self.sut.mapView.annotations.count, 2)
        
        let annotation = self.sut.annotationHandler.annotations.filter({ $0.model.photoId == secondPhotoAnnotation.model.photoId }).first
        XCTAssertNotNil(annotation)
        
        XCTAssertEqual(annotation, secondPhotoAnnotation)
        XCTAssertEqual(self.sut.annotationHandler.selectedPhotoAnnotation, secondPhotoAnnotation)
    }
    
    func testDisplayCenterToCoordinate() {
        self.loadView()
        
        self.sut.mapView.setRegion(MKCoordinateRegion(MKMapRect(origin: MKMapPoint(x: 0, y: 0), size: MKMapSize(width: 0, height: 0))), animated: false)
        
        let region = MKCoordinateRegion(center: STPhotoMapSeeds.coordinate, span: EntityLevel.block.coordinateSpan())
        let viewModel = STPhotoMapModels.CoordinateCenter.ViewModel(region: region)
        self.sut.displayCenterToCoordinate(viewModel: viewModel)
        
        self.waitForMainQueue()
        
        XCTAssertEqual(round(self.sut.mapView.region.center.latitude), round(region.center.latitude))
        XCTAssertEqual(round(self.sut.mapView.region.center.longitude), round(region.center.longitude))
        XCTAssertEqual(round(self.sut.mapView.region.span.latitudeDelta), round(region.span.latitudeDelta))
        XCTAssertEqual(round(self.sut.mapView.region.span.longitudeDelta), round(region.span.longitudeDelta))
    }
    
    func testDisplayOpenDataSourcesLink() {
        let url = URL(string: "https://streetography.com")!
        let viewModel = STPhotoMapModels.OpenApplication.ViewModel(url: url)
        self.sut.displayOpenDataSourcesLink(viewModel: viewModel)
        
        self.waitForMainQueue()
        
        XCTAssertTrue(self.routerSpy.navigateToSafariCalled)
    }
    
    func testDisplayLocationAccessDeniedAlert() {
        let viewModel = STPhotoMapModels.LocationAccessDeniedAlert.ViewModel(title: nil, message: "message", cancelTitle: "cancel", settingsTitle: "settings")
        self.sut.displayLocationAccessDeniedAlert(viewModel: viewModel)
        
        self.waitForMainQueue()
        
        XCTAssertTrue(self.routerSpy.navigateToLocationSettingsAlertCalled)
    }
    
    func testDisplayDisplayOpenApplication() {
        let viewModel = STPhotoMapModels.OpenApplication.ViewModel(url: URL(string: "https://streetography.com")!)
        self.sut.displayOpenApplication(viewModel: viewModel)
        
        self.waitForMainQueue()
        
        XCTAssertTrue(self.routerSpy.navigateToApplicationCalled)
    }
}
