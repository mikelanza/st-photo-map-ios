//
//  STPhotoMapView+DisplayLogic.swift
//  STPhotoMap-iOS
//
//  Created by Dimitri Strauneanu on 24/06/2019.
//  Copyright © 2019 mikelanza. All rights reserved.
//

import UIKit
import MapKit
import STPhotoCore

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
        DispatchQueue.main.async {
            if let delegate = self.delegate {
                delegate.photoMapView(self, navigateToPhotoDetailsFor: viewModel.photoId)
            } else {
                self.router?.navigateToPhotoDetails(viewController: self.viewController, photoId: viewModel.photoId)
            }
        }
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
            self.setNeedsDisplayCarousel()
        }
    }
    
    // MARK: - Photo collection navigation
    
    func displayNavigateToPhotoCollection(viewModel: STPhotoMapModels.PhotoCollectionNavigation.ViewModel) {
        DispatchQueue.main.async {
            if let delegate = self.delegate {
                delegate.photoMapView(self, navigateToPhotoCollectionFor: viewModel.location, entityLevel: viewModel.entityLevel)
            } else {
                self.router?.navigateToPhotoCollection(location: viewModel.location, entityLevel: viewModel.entityLevel, userId: nil, collectionId: nil)
            }
        }
    }
    
    // MARK: - Data sources
    
    func displayOpenDataSourcesLink(viewModel: STPhotoMapModels.OpenApplication.ViewModel) {
        DispatchQueue.main.async {
            self.router?.navigateToSafari(url: viewModel.url)
        }
    }
    
    // MARK: - Open application
    
    func displayOpenApplication(viewModel: STPhotoMapModels.OpenApplication.ViewModel) {
        DispatchQueue.main.async {
            self.router?.navigateToApplication(url: viewModel.url)
        }
    }
    
    // MARK: - Location access denied alert
    
    func displayLocationAccessDeniedAlert(viewModel: STPhotoMapModels.LocationAccessDeniedAlert.ViewModel) {
        DispatchQueue.main.async {
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
}
