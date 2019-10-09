//
//  STPhotoMapView.swift
//  STPhotoMap-iOS
//
//  Created by Dimitri Strauneanu on 12/04/2019.
//  Copyright © 2019 Streetography. All rights reserved.
//

import UIKit
import MapKit
import STPhotoCore
import STPhotoCollection

public protocol STPhotoMapViewDelegate: NSObjectProtocol {
    func photoMapView(_ view: STPhotoMapView?, navigateToPhotoDetailsFor photoId: String?)
    func photoMapView(_ view: STPhotoMapView?, navigateToSpecificPhotosFor photoIds: [String])
    func photoMapView(_ view: STPhotoMapView?, navigateToPhotoCollectionFor location: STLocation, entityLevel: EntityLevel)
}

public class STPhotoMapView: UIView {
    public weak var mapView: STActionMapView!
    public weak var delegate: STPhotoMapViewDelegate?
    public weak var viewController: UIViewController? {
        didSet {
            self.router?.viewController = self.viewController
        }
    }
    
    var interactor: STPhotoMapBusinessLogic?
    var router: STPhotoMapRoutingLogic?
    
    weak var progressView: UIProgressView!
    weak var entityLevelView: STEntityLevelView!
    weak var locationOverlayView: STLocationOverlayView!
    weak var userLocationButton: UIButton!
    weak var dataSourcesButton: UIButton!
    
    var photoTileOverlay: STPhotoTileOverlay?
    var carouselOverlays: [STCarouselOverlay] = []
    var tileOverlayRenderer: MKTileOverlayRenderer?
    var annotationHandler: STPhotoMapAnnotationHandler!
    
    public convenience init() {
        self.init(frame: .zero)
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
        self.setupSubviews()
        self.setupSubviewsConstraints()
        
        self.annotationHandler = STPhotoMapAnnotationHandler()
        self.setupTileOverlay()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Setup
    
    private func setup() {
        let displayer = self
        let interactor = STPhotoMapInteractor()
        let presenter = STPhotoMapPresenter()
        let router = STPhotoMapRouter()
        router.photoMapView = self
        
        interactor.presenter = presenter
        presenter.displayer = displayer
        router.displayer = displayer
        
        displayer.interactor = interactor
        displayer.router = router
    }
}

// MARK: - Input

extension STPhotoMapView {
    public func updateParameter(parameter: KeyValue) {
        STPhotoMapParametersHandler.shared.update(parameter: parameter)
    }
    
    public func removeParameter(parameter: KeyValue) {
        STPhotoMapParametersHandler.shared.remove(parameter: parameter)
    }
    
    public func resetParameters() {
        STPhotoMapParametersHandler.shared.reset()
    }
    
    public func reloadCarousel() {
        self.interactor?.shouldReloadCarousel()
    }
    
    public func reloadLocationLevel() {
        self.interactor?.shouldReloadLocationLevel()
    }
    
    public func setNeedsDisplayTiles() {
        DispatchQueue.main.async {
            if let overlay = self.photoTileOverlay, let renderer = self.mapView?.renderer(for: overlay) as? MKTileOverlayRenderer {
                renderer.setNeedsDisplay()
            }
        }
    }
    
    public func setNeedsDisplayCarousel() {
        DispatchQueue.main.async {
            if let overlay = self.carouselOverlays.first, let renderer = self.mapView?.renderer(for: overlay) as? STCarouselOverlayRenderer {
                renderer.reload()
            }
        }
    }
}

// MARK: - Photo annotation view delegate

extension STPhotoMapView: PhotoAnnotationViewDelegate {
    func photoAnnotationView(view: PhotoAnnotationView?, with photoAnnotation: PhotoAnnotation, didSelect photoImageView: PhotoImageView?) {
        self.shouldSelectPhotoAnnotation(photoAnnotation, previousPhotoAnnotation: self.annotationHandler?.selectedPhotoAnnotation)
        self.shouldUpdateSelectedPhotoAnnotation(photoAnnotation)
        self.annotationHandler?.selectedPhotoAnnotation = photoAnnotation
    }
}

// MARK: - Multiple photo cluster view delegate

extension STPhotoMapView: MultiplePhotoClusterAnnotationViewDelegate {
    func multiplePhotoClusterAnnotationView(view: MultiplePhotoClusterAnnotationView?, with photoClusterAnnotation: MultiplePhotoClusterAnnotation, didSelect clusterLabelView: ClusterLabelView?) {
        self.shouldInflatePhotoClusterAnnotation(photoClusterAnnotation, previousClusterAnnotation: self.annotationHandler?.selectedPhotoClusterAnnotation, zoomLevel: self.mapView.zoomLevel())
        self.annotationHandler?.selectedPhotoClusterAnnotation = photoClusterAnnotation
    }
    
    func multiplePhotoClusterAnnotationView(view: MultiplePhotoClusterAnnotationView?, with photoClusterAnnotation: MultiplePhotoClusterAnnotation, with photoAnnotation: PhotoAnnotation, didSelect photoImageView: PhotoImageView?) {
        self.shouldSelectPhotoClusterAnnotation(photoClusterAnnotation, photoAnnotation: photoAnnotation, previousPhotoAnnotation: self.annotationHandler?.selectedPhotoAnnotation)
        self.shouldUpdateSelectedPhotoAnnotation(photoAnnotation)
        self.annotationHandler?.selectedPhotoAnnotation = photoAnnotation
    }
}

// MARK: - Location overlay view delegate

extension STPhotoMapView: STLocationOverlayViewDelegate {
    func locationOverlayView(view: STLocationOverlayView?, didSelectPhoto photoId: String) {
        self.interactor?.shouldNavigateToPhotoDetails(request: STPhotoMapModels.PhotoDetailsNavigation.Request(photoId: photoId))
    }
}

// MARK: - Map logic

extension STPhotoMapView {
    private func setupTileOverlay() {
        self.photoTileOverlay = STPhotoTileOverlay()
        self.photoTileOverlay?.maximumZ = 20
        self.photoTileOverlay?.canReplaceMapContent = true
        self.mapView?.addOverlay(self.photoTileOverlay!, level: .aboveLabels)
    }
}

// MARK: - Actions

extension STPhotoMapView: STActionMapViewDelegate {
    func actionMapView(mapView: STActionMapView?, didSelect carouselOverlay: STCarouselOverlay, atLocation location: STLocation) {
        self.interactor?.shouldNavigateToPhotoCollection(request: STPhotoMapModels.PhotoCollectionNavigation.Request(location: location, entityLevel: carouselOverlay.entityLevel()))
    }
    
    func actionMapView(mapView: STActionMapView?, didSelect tileCoordinate: TileCoordinate, atLocation location: STLocation) {
        self.interactor?.shouldSelectCarousel(request: STPhotoMapModels.CarouselSelection.Request(tileCoordinate: tileCoordinate, location: location))
    }
    
    func actionMapView(mapView: STActionMapView?, didSelectCarouselPhoto photoId: String, atLocation location: STLocation) {
        self.interactor?.shouldNavigateToPhotoDetails(request: STPhotoMapModels.PhotoDetailsNavigation.Request(photoId: photoId))
    }
}

extension STPhotoMapView {
    @objc func touchUpInsideUserLocationButton(button: UIButton?) {
        self.interactor?.shouldAskForLocationPermissions()
    }
    
    @objc func touchUpInsideDataSourcesButton(button: UIButton?) {
        self.interactor?.shouldOpenDataSourcesLink()
    }
}

extension STPhotoMapView: STPhotoCollectionViewControllerDelegate {
    public func photoCollectionViewController(_ viewController: STPhotoCollectionViewController?, navigateToPhotoDetailsFor photoId: String) {
        self.router?.navigateToPhotoDetails(viewController: viewController, photoId: photoId)
    }
}
