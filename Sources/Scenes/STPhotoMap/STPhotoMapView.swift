//
//  STPhotoMapView.swift
//  STPhotoMap-iOS
//
//  Created by Dimitri Strauneanu on 12/04/2019.
//  Copyright © 2019 mikelanza. All rights reserved.
//

import UIKit
import MapKit

public protocol STPhotoMapViewDataSource: NSObjectProtocol {
    func photoMapView(_ view: STPhotoMapView?, photoTileOverlayModelForUrl url: String, parameters: [KeyValue]?) -> STPhotoTileOverlay.Model
}

public protocol STPhotoMapViewDelegate: NSObjectProtocol {
    func photoMapView(_ view: STPhotoMapView?, navigateToPhotoDetailsFor photoId: String?)
    func photoMapView(_ view: STPhotoMapView?, navigateToSpecificPhotosFor photoIds: [String])
    func photoMapView(_ view: STPhotoMapView?, navigateToPhotoCollectionFor location: STLocation, entityLevel: EntityLevel)
}

protocol STPhotoMapDisplayLogic: class {
    func displayLoadingState()
    func displayNotLoadingState()
    
    func displayEntityLevel(viewModel: STPhotoMapModels.EntityZoomLevel.ViewModel)
    
    func displayLocationAnnotations(viewModel: STPhotoMapModels.LocationAnnotations.ViewModel)
    func displayRemoveLocationAnnotations()
    
    func displayLocationOverlay(viewModel: STPhotoMapModels.LocationOverlay.ViewModel)
    func displayRemoveLocationOverlay()
    
    func displayNavigateToPhotoDetails(viewModel: STPhotoMapModels.PhotoDetailsNavigation.ViewModel)
    func displayNavigateToSpecificPhotos(viewModel: STPhotoMapModels.SpecificPhotosNavigation.ViewModel)
    func displayNavigateToPhotoCollection(viewModel: STPhotoMapModels.PhotoCollectionNavigation.ViewModel)
    
    func displayZoomToCoordinate(viewModel: STPhotoMapModels.CoordinateZoom.ViewModel)
    func displayCenterToCoordinate(viewModel: STPhotoMapModels.CoordinateCenter.ViewModel)
    
    func displaySelectPhotoAnnotation(viewModel: STPhotoMapModels.PhotoAnnotationSelection.ViewModel)
    func displayDeselectPhotoAnnotation(viewModel: STPhotoMapModels.PhotoAnnotationDeselection.ViewModel)
    
    func displaySelectPhotoClusterAnnotation(viewModel: STPhotoMapModels.PhotoClusterAnnotationSelection.ViewModel)
    func displayDeselectPhotoClusterAnnotation(viewModel: STPhotoMapModels.PhotoClusterAnnotationDeselection.ViewModel)
    
    func displayRemoveCarousel()
    func displayNewCarousel(viewModel: STPhotoMapModels.NewCarousel.ViewModel)
    func displayReloadCarousel()
    
    func displayNewSelectedPhotoAnnotation(viewModel: STPhotoMapModels.PhotoAnnotationSelection.ViewModel)
    
    func displayOpenDataSourcesLink(viewModel: STPhotoMapModels.OpenApplication.ViewModel)
    func displayOpenApplication(viewModel: STPhotoMapModels.OpenApplication.ViewModel)
    
    func displayLocationAccessDeniedAlert(viewModel: STPhotoMapModels.LocationAccessDeniedAlert.ViewModel)
}

public class STPhotoMapView: UIView {
    public weak var mapView: STActionMapView!
    public weak var dataSource: STPhotoMapViewDataSource?
    public weak var delegate: STPhotoMapViewDelegate?
    
    var interactor: STPhotoMapBusinessLogic?
    var router: STPhotoMapRoutingLogic?
    
    weak var progressView: UIProgressView!
    weak var entityLevelView: STEntityLevelView!
    weak var locationOverlayView: STLocationOverlayView!
    weak var userLocationButton: UIButton!
    weak var dataSourcesButton: UIButton!
    
    var photoTileOverlay: STPhotoTileOverlay?
    var carouselOverlays: [STCarouselOverlay] = []
    var tileOverlayRenderer: STPhotoTileOverlayRenderer?
    var annotationHandler: STPhotoMapAnnotationHandler!
    
    public convenience init(dataSource: STPhotoMapViewDataSource) {
        self.init()
        self.dataSource = dataSource
    }
    
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
        self.photoTileOverlay?.update(parameter: parameter)
    }
    
    public func reloadTiles() {
        if let overlay = self.photoTileOverlay, let renderer = self.mapView?.renderer(for: overlay) as? STPhotoTileOverlayRenderer {
            renderer.reloadTiles()
        }
    }
    
    public func reloadCarouselOverlays() {
        if let overlay = self.carouselOverlays.first, let renderer = self.mapView?.renderer(for: overlay) as? STCarouselOverlayRenderer {
            renderer.reload()
        }
    }
}

// MARK: - Data Source

extension STPhotoMapView {
    public func photoMapView(_ view: STPhotoMapView?, photoTileOverlayModelForUrl url: String, parameters: [KeyValue]?) -> STPhotoTileOverlay.Model {
        if let dataSource = self.dataSource {
            return dataSource.photoMapView(view, photoTileOverlayModelForUrl: url, parameters: parameters)
        }
        return STPhotoTileOverlay.Model(url: url, parameters: parameters)
    }
}

// MARK: - Business logic

extension STPhotoMapView {
    private func shouldDownloadImageForPhotoAnnotation(_ photoAnnotation: PhotoAnnotation) {
        self.interactor?.shouldDownloadImageForPhotoAnnotation(request: STPhotoMapModels.PhotoAnnotationImageDownload.Request(photoAnnotation: photoAnnotation))
    }
    
    private func shouldSelectPhotoAnnotation(_ photoAnnotation: PhotoAnnotation, previousPhotoAnnotation: PhotoAnnotation?) {
        self.interactor?.shouldSelectPhotoAnnotation(request: STPhotoMapModels.PhotoAnnotationSelection.Request(photoAnnotation: photoAnnotation, previousPhotoAnnotation: previousPhotoAnnotation))
    }
    
    private func shouldInflatePhotoClusterAnnotation(_ clusterAnnotation: MultiplePhotoClusterAnnotation, previousClusterAnnotation: MultiplePhotoClusterAnnotation?, zoomLevel: Int) {
        self.interactor?.shouldInflatePhotoClusterAnnotation(request: STPhotoMapModels.PhotoClusterAnnotationInflation.Request(clusterAnnotation: clusterAnnotation, previousClusterAnnotation: previousClusterAnnotation, zoomLevel: zoomLevel))
    }
    
    private func shouldSelectPhotoClusterAnnotation(_ clusterAnnotation: MultiplePhotoClusterAnnotation, photoAnnotation: PhotoAnnotation, previousPhotoAnnotation: PhotoAnnotation?) {
        self.interactor?.shouldSelectPhotoClusterAnnotation(request: STPhotoMapModels.PhotoClusterAnnotationSelection.Request(clusterAnnotation: clusterAnnotation, photoAnnotation: photoAnnotation, previousPhotoAnnotation: previousPhotoAnnotation))
    }
    
    private func shouldUpdateSelectedPhotoAnnotation(_ photoAnnotation: PhotoAnnotation?) {
        self.interactor?.shouldUpdateSelectedPhotoAnnotation(request: STPhotoMapModels.SelectedPhotoAnnotation.Request(annotation: photoAnnotation))
    }
}

// MARK: - Display logic

extension STPhotoMapView: STPhotoMapDisplayLogic {
    
    // MARK: - Loading state
    
    func displayLoadingState() {
        DispatchQueue.main.async {
            self.shouldShowProgressView()
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
        }
    }
    
    private func shouldShowProgressView() {
        if STPhotoMapStyle.shared.progressViewModel.show {
            self.showProgressView()
        }
    }
    
    private func showProgressView() {
        self.progressView?.isHidden = false
        self.progressView?.setProgress(1.0, animated: true)
    }
    
    // MARK: - Not loading state
    
    func displayNotLoadingState() {
        DispatchQueue.main.async {
            self.shouldHideProgressView()
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
        }
    }
    
    private func shouldHideProgressView() {
        if STPhotoMapStyle.shared.progressViewModel.show {
            self.hideProgressView()
        }
    }
    
    private func hideProgressView() {
        self.progressView?.isHidden = true
        self.progressView?.setProgress(0.0, animated: false)
    }
    
    // MARK: - Entity level view
    
    func displayEntityLevel(viewModel: STPhotoMapModels.EntityZoomLevel.ViewModel) {
        DispatchQueue.main.async {
            self.shouldShowEntityLevelView(title: viewModel.title, image: viewModel.image)
        }
    }
    
    private func shouldShowEntityLevelView(title: String?, image: UIImage?) {
        if STPhotoMapStyle.shared.entityLevelViewModel.show {
            self.showEntityLevelView(title: title, image: image)
        }
    }
    
    private func showEntityLevelView(title: String?, image: UIImage?) {
        let model = STEntityLevelView.Model(title: title, image: image)
        self.setupEntityLevelView(model: model)
        self.setupEntityLevelViewConstraints()
        self.entityLevelView?.show()
    }
    
    // MARK: - Location annotations
    
    func displayLocationAnnotations(viewModel: STPhotoMapModels.LocationAnnotations.ViewModel) {
        DispatchQueue.main.async {
            self.annotationHandler.addAnnotations(annotations: viewModel.annotations)
            let visibleAnnotations = self.annotationHandler.getVisibleAnnotations(mapRect: self.mapView.visibleMapRect)
            self.mapView?.addAnnotations(visibleAnnotations)
        }
    }
    
    func displayRemoveLocationAnnotations() {
        DispatchQueue.main.async {
            self.annotationHandler.removeAllAnnotations()
            self.mapView?.removeAnnotations(self.mapView?.annotations ?? [])
        }
    }
    
    // MARK: - Photo details navigation
    
    func displayNavigateToPhotoDetails(viewModel: STPhotoMapModels.PhotoDetailsNavigation.ViewModel) {
        self.delegate?.photoMapView(self, navigateToPhotoDetailsFor: viewModel.photoId)
    }
    
    // MARK: - Location overlay
    
    func displayLocationOverlay(viewModel: STPhotoMapModels.LocationOverlay.ViewModel) {
        DispatchQueue.main.async {
            self.shouldShowLocationOverlayView(photoId: viewModel.photoId, title: viewModel.title, time: viewModel.time, description: viewModel.description)
        }
    }
    
    private func shouldShowLocationOverlayView(photoId: String, title: String?, time: String?, description: String?) {
        if STPhotoMapStyle.shared.locationOverlayViewModel.show {
            self.showLocationOverlayView(photoId: photoId, title: title, time: time, description: description)
        }
    }
    
    private func showLocationOverlayView(photoId: String, title: String?, time: String?, description: String?) {
        self.removeLocationOverlayView()
        
        let model = STLocationOverlayView.Model(photoId: photoId, title: title, time: time, description: description)
        self.setupLocationOverlayView(model: model)
        self.setupLocationOverlayViewConstraints()
    }
    
    private func removeLocationOverlayView() {
        self.locationOverlayView?.removeFromSuperview()
        self.locationOverlayView = nil
    }
    
    func displayRemoveLocationOverlay() {
        DispatchQueue.main.async {
            self.removeLocationOverlayView()
        }
    }
    
    // MARK: - Specific photos navigation
    
    func displayNavigateToSpecificPhotos(viewModel: STPhotoMapModels.SpecificPhotosNavigation.ViewModel) {
        self.delegate?.photoMapView(self, navigateToSpecificPhotosFor: viewModel.photoIds)
    }
    
    // MARK: - Zoom to coordinate
    
    func displayZoomToCoordinate(viewModel: STPhotoMapModels.CoordinateZoom.ViewModel) {
        DispatchQueue.main.async {
            self.zoomToCoordinate(viewModel.coordinate, latitudeMultiplier: 0.5, longitudeMultiplier: 0.5)
        }
    }
    
    private func zoomToCoordinate(_ coordinate: CLLocationCoordinate2D, latitudeMultiplier: Double, longitudeMultiplier: Double) {
        var span = self.mapView.region.span
        span.latitudeDelta *= latitudeMultiplier
        span.longitudeDelta *= longitudeMultiplier
        let region = MKCoordinateRegion(center: coordinate, span: span)
        self.mapView?.setRegion(region, animated: true)
    }
    
    // MARK: - Center to coordinate
    
    func displayCenterToCoordinate(viewModel: STPhotoMapModels.CoordinateCenter.ViewModel) {
        DispatchQueue.main.async {
            self.mapView?.setRegion(viewModel.region, animated: false)
        }
    }
    
    // MARK: - Photo annotation selection/deselection
    
    func displaySelectPhotoAnnotation(viewModel: STPhotoMapModels.PhotoAnnotationSelection.ViewModel) {
        viewModel.photoAnnotation?.isSelected = true
    }
    
    func displayDeselectPhotoAnnotation(viewModel: STPhotoMapModels.PhotoAnnotationDeselection.ViewModel) {
        viewModel.photoAnnotation?.isSelected = false
    }
    
    func displayNewSelectedPhotoAnnotation(viewModel: STPhotoMapModels.PhotoAnnotationSelection.ViewModel) {
        DispatchQueue.main.async {
            if let annotation = viewModel.photoAnnotation {
                self.annotationHandler?.selectedPhotoAnnotation = annotation
                self.annotationHandler?.updateAnnotation(annotation: annotation)
                self.mapView?.updateAnnotation(annotation)
            }
        }
    }
    
    // MARK: - Photo cluster annotation selection/deselection
    
    func displaySelectPhotoClusterAnnotation(viewModel: STPhotoMapModels.PhotoClusterAnnotationSelection.ViewModel) {
        self.annotationHandler?.selectedPhotoClusterAnnotation?.interface?.setIsSelected(photoId: viewModel.photoAnnotation.model.photoId, isSelected: true)
    }
    
    func displayDeselectPhotoClusterAnnotation(viewModel: STPhotoMapModels.PhotoClusterAnnotationDeselection.ViewModel) {
        if let annotation = viewModel.photoAnnotation {
            self.annotationHandler?.selectedPhotoClusterAnnotation?.interface?.setIsSelected(photoId: annotation.model.photoId, isSelected: false)
        }
    }
    
    // MARK: - Carousel
    
    func displayRemoveCarousel() {
        DispatchQueue.main.async {
            let carouselOverlays = self.mapView.overlays.filter({ $0 is STCarouselOverlay })
            self.mapView.removeOverlays(carouselOverlays)
            self.carouselOverlays.removeAll()
        }
    }
    
    func displayNewCarousel(viewModel: STPhotoMapModels.NewCarousel.ViewModel) {
        DispatchQueue.main.async {
            self.mapView.addOverlays(viewModel.overlays)
            self.carouselOverlays = viewModel.overlays
        }
    }
    
    func displayReloadCarousel() {
        DispatchQueue.main.async {
            self.reloadCarouselOverlays()
        }
    }
    
    // MARK: - Photo collection navigation
    
    func displayNavigateToPhotoCollection(viewModel: STPhotoMapModels.PhotoCollectionNavigation.ViewModel) {
        self.delegate?.photoMapView(self, navigateToPhotoCollectionFor: viewModel.location, entityLevel: viewModel.entityLevel)
    }
    
    // MARK: - Data sources
    
    func displayOpenDataSourcesLink(viewModel: STPhotoMapModels.OpenApplication.ViewModel) {
        self.router?.navigateToSafari(url: viewModel.url)
    }
    
    // MARK: - Open application
    
    func displayOpenApplication(viewModel: STPhotoMapModels.OpenApplication.ViewModel) {
        self.router?.navigateToApplication(url: viewModel.url)
    }
    
    // MARK: - Location access denied alert
    
    func displayLocationAccessDeniedAlert(viewModel: STPhotoMapModels.LocationAccessDeniedAlert.ViewModel) {
        let alertController = UIAlertController(title: viewModel.title, message: viewModel.message, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: viewModel.cancelTitle, style: .cancel, handler: nil)
        let settingsAction = UIAlertAction(title: viewModel.settingsTitle, style: .default, handler: { action in
            self.interactor?.shouldOpenSettingsApplication()
        })
        alertController.addAction(cancelAction)
        alertController.addAction(settingsAction)
        
        self.router?.navigateToLocationSettingsAlert(controller: alertController)
    }
}

// MARK: - MKMapView delegate methods

extension STPhotoMapView: MKMapViewDelegate {
    public func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        let visibleTiles = mapView.visibleTiles()
        let outerTiles = mapView.outerTiles()
        let visibleMapRect = mapView.visibleMapRect
        
        DispatchQueue.global().async {
            self.interactor?.shouldUpdateVisibleMapRect(request: STPhotoMapModels.VisibleMapRect.Request(mapRect: visibleMapRect))
            self.interactor?.shouldUpdateVisibleTiles(request: STPhotoMapModels.VisibleTiles.Request(tiles: visibleTiles))
            self.interactor?.shouldCacheGeojsonObjects()
            self.interactor?.shouldDetermineEntityLevel()
            self.interactor?.shouldDetermineLocationLevel()
            self.interactor?.shouldDetermineCarousel()
            self.interactor?.shouldDetermineSelectedPhotoAnnotation()
    
            self.predownload(outer: outerTiles)
        }
    }
    
    public func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if overlay is STPhotoTileOverlay {
            let renderer = STPhotoTileOverlayRenderer(tileOverlay: overlay as! STPhotoTileOverlay)
            self.tileOverlayRenderer = renderer
            return renderer
        }
        
        if overlay is STCarouselOverlay {
            return STCarouselOverlayRenderer(carouselOverlay: overlay as! STCarouselOverlay, visibleMapRect: mapView.visibleMapRect)
        }
        
        return MKOverlayRenderer(overlay: overlay)
    }
    
    public func mapViewDidChangeVisibleRegion(_ mapView: MKMapView) {
        self.photoTileOverlay?.update(parameter: KeyValue(Parameters.Keys.bbox, mapView.boundingBox().description))
    }
    
    public func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if let photoAnnotation = annotation as? PhotoAnnotation {
            let view = photoAnnotation.annotationView()
            view.delegate = self
            self.shouldDownloadImageForPhotoAnnotation(photoAnnotation)
            return view
        } else if let clusterAnnotation = annotation as? MultiplePhotoClusterAnnotation {
            let view = clusterAnnotation.annotationView()
            view?.delegate = self
            return view
        } else if let clusterAnnotation = annotation as? MKClusterAnnotation {
            return ClusterAnnotationView(count: clusterAnnotation.memberAnnotations.count, annotation: annotation)
        }
        return nil
    }
    
    public func mapView(_ mapView: MKMapView, clusterAnnotationForMemberAnnotations memberAnnotations: [MKAnnotation]) -> MKClusterAnnotation {
        guard let photoAnnotations = memberAnnotations as? [PhotoAnnotation] else {
            return MKClusterAnnotation(memberAnnotations: memberAnnotations)
        }
        
        let photoIds = photoAnnotations.compactMap({ $0.model.photoId })
        return MultiplePhotoClusterAnnotation(photoIds: photoIds, memberAnnotations: memberAnnotations)
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
        let model = self.photoMapView(self, photoTileOverlayModelForUrl: "https://tilesdev.streetography.com/tile/%d/%d/%d.jpeg", parameters: Parameters.defaultParameters())
        
        self.photoTileOverlay = STPhotoTileOverlay(model: model)
        self.photoTileOverlay?.canReplaceMapContent = true
        self.mapView?.addOverlay(self.photoTileOverlay!, level: .aboveLabels)
    }
}

// MARK: - Predownload tiles

extension STPhotoMapView {
    private func predownload(outer tiles: [(MKMapRect, [TileCoordinate])]) {
        self.tileOverlayRenderer?.predownload(model: self.photoTileOverlay?.model.clone(), outer: tiles)
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

// MARK: - Subviews configuration

extension STPhotoMapView {
    private func setupSubviews() {
        self.setupMapView()
        self.setupProgressView()
        self.setupUserLocationButton()
        self.setupDataSourcesButton()
    }
    
    private func setupMapView() {
        let mapView = STActionMapView()
        mapView.translatesAutoresizingMaskIntoConstraints = false
        mapView.delegate = self
        mapView.actionMapViewDelegate = self
        self.addSubview(mapView)
        self.mapView = mapView
    }
    
    private func setupProgressView() {
        let view = UIProgressView(progressViewStyle: UIProgressView.Style.bar)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isHidden = true
        view.progressTintColor = STPhotoMapStyle.shared.progressViewModel.tintColor
        self.addSubview(view)
        self.progressView = view
    }
    
    private func setupEntityLevelView(model: STEntityLevelView.Model) {
        let view = STEntityLevelView(model: model)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.alpha = 0.0
        view.isUserInteractionEnabled = false
        self.addSubview(view)
        self.entityLevelView = view
    }
    
    private func setupLocationOverlayView(model: STLocationOverlayView.Model) {
        let view = STLocationOverlayView(model: model)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.delegate = self
        self.addSubview(view)
        self.locationOverlayView = view
    }
    
    private func setupUserLocationButton() {
        let button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(STPhotoMapStyle.shared.userLocationButtonModel.image, for: .normal)
        button.addTarget(self, action: #selector(STPhotoMapView.touchUpInsideUserLocationButton(button:)), for: .touchUpInside)
        self.addSubview(button)
        self.userLocationButton = button
    }
    
    private func setupDataSourcesButton() {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        let text: String = STPhotoMapLocalization.shared.dataSourcesTitle
        let title: NSMutableAttributedString = NSMutableAttributedString(string: text)
        title.addAttribute(NSAttributedString.Key.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: NSMakeRange(0, text.count))
        title.addAttribute(NSAttributedString.Key.font, value: UIFont.systemFont(ofSize: 9, weight: UIFont.Weight.medium), range: NSMakeRange(0, text.count))
        title.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.darkGray, range: NSMakeRange(0, text.count))
        button.setAttributedTitle(title, for: .normal)
        button.addTarget(self, action: #selector(STPhotoMapView.touchUpInsideDataSourcesButton(button:)), for: .touchUpInside)
        self.addSubview(button)
        self.dataSourcesButton = button
    }
}

// MARK: - Constraints configuration

extension STPhotoMapView {
    private func setupSubviewsConstraints() {
        self.setupMapViewConstraints()
        self.setupProgressViewConstraints()
        self.setupUserLocationButtonConstraints()
        self.setupDataSourcesButtonConstraints()
    }
    
    private func setupMapViewConstraints() {
        self.mapView?.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        self.mapView?.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        self.mapView?.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        self.mapView?.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
    }
    
    private func setupProgressViewConstraints() {
        self.progressView?.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        self.progressView?.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        self.progressView?.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
    }
    
    private func setupEntityLevelViewConstraints() {
        self.entityLevelView?.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        self.entityLevelView?.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        self.entityLevelView?.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        self.entityLevelView?.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
    }
    
    private func setupLocationOverlayViewConstraints() {
        self.locationOverlayView?.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 15).isActive = true
        self.locationOverlayView?.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -75).isActive = true
        self.locationOverlayView?.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -30).isActive = true
    }
    
    private func setupUserLocationButtonConstraints() {
        self.userLocationButton?.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10).isActive = true
        self.userLocationButton?.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10).isActive = true
    }
    
    private func setupDataSourcesButtonConstraints() {
        self.dataSourcesButton?.trailingAnchor.constraint(equalTo: self.userLocationButton.leadingAnchor, constant: -10).isActive = true
        self.dataSourcesButton?.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -3).isActive = true
    }
}
