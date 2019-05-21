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
}

protocol STPhotoMapDisplayLogic: class {
    func displayLoadingState()
    func displayNotLoadingState()
    
    func displayEntityLevel(viewModel: STPhotoMapModels.EntityZoomLevel.ViewModel)
    func displayLocationAnnotations(viewModel: STPhotoMapModels.LocationAnnotations.ViewModel)
    func displayNavigateToPhotoDetails(viewModel: STPhotoMapModels.PhotoDetailsNavigation.ViewModel)
    
    func displayRemoveLocationAnnotations()
    func displayLocationOverlay(viewModel: STPhotoMapModels.LocationOverlay.ViewModel)
}

public class STPhotoMapView: UIView {
    public weak var mapView: MKMapView!
    public weak var dataSource: STPhotoMapViewDataSource?
    public weak var delegate: STPhotoMapViewDelegate?
    
    var interactor: STPhotoMapBusinessLogic?
    
    weak var progressView: UIProgressView!
    weak var entityLevelView: STEntityLevelView!
    weak var locationOverlayView: STLocationOverlayView!
    
    var photoTileOverlay: STPhotoTileOverlay?
    private var annotationHandler: STPhotoMapAnnotationHandler!
    
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
        displayer.interactor = interactor
        interactor.presenter = presenter
        presenter.displayer = displayer
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
        self.annotationHandler.addAnnotations(annotations: viewModel.annotations)
        DispatchQueue.main.async {
            let visibleAnnotations = self.annotationHandler.getVisibleAnnotations(mapRect: self.mapView.visibleMapRect)
            self.mapView?.addAnnotations(visibleAnnotations)
        }
    }
    
    func displayRemoveLocationAnnotations() {
        DispatchQueue.main.async {
            self.mapView?.removeAnnotations(self.mapView?.annotations ?? [])
        }
        self.annotationHandler.removeAllAnnotations()
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
}

// MARK: - MKMapView delegate methods

extension STPhotoMapView: MKMapViewDelegate {
    public func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        let visibleTiles = mapView.visibleTiles()
        DispatchQueue.global().async {
            self.interactor?.shouldUpdateVisibleTiles(request: STPhotoMapModels.VisibleTiles.Request(tiles: visibleTiles))
            self.interactor?.shouldCacheGeojsonObjects()
            self.interactor?.shouldDetermineEntityLevel()
            self.interactor?.shouldDetermineLocationLevel()
        }
    }
    
    public func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if overlay is STPhotoTileOverlay {
            return STPhotoTileOverlayRenderer(tileOverlay: overlay as! STPhotoTileOverlay)
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
        self.annotationHandler?.selectedPhotoAnnotation = photoAnnotation
    }
}

// MARK: - Multiple photo cluster view delegate

extension STPhotoMapView: MultiplePhotoClusterAnnotationViewDelegate {
    func multiplePhotoClusterAnnotationView(view: MultiplePhotoClusterAnnotationView?, didSelect clusterLabelView: ClusterLabelView?) {
        
    }
    
    func multiplePhotoClusterAnnotationView(view: MultiplePhotoClusterAnnotationView?, didSelect photoImageView: PhotoImageView?, at index: Int) {
        
    }
}

// MARK: - Location overlay view delegate

extension STPhotoMapView: STLocationOverlayViewDelegate {
    func locationOverlayView(view: STLocationOverlayView?, didSelectPhoto photoId: String) {
        
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

// MARK: - Subviews configuration

extension STPhotoMapView {
    private func setupSubviews() {
        self.setupMapView()
        self.setupProgressView()
    }
    
    private func setupMapView() {
        let mapView = MKMapView()
        mapView.translatesAutoresizingMaskIntoConstraints = false
        mapView.delegate = self
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
        view.backgroundColor = UIColor.white
        view.delegate = self
        self.addSubview(view)
        self.locationOverlayView = view
    }
}

// MARK: - Constraints configuration

extension STPhotoMapView {
    private func setupSubviewsConstraints() {
        self.setupMapViewConstraints()
        self.setupProgressViewConstraints()
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
}
