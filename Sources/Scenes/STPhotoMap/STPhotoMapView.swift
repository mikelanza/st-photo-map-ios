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

protocol STPhotoMapDisplayLogic: class {
    func displayLoadingState()
    func displayNotLoadingState()
    
    func displayEntityLevel(viewModel: STPhotoMapModels.EntityZoomLevel.ViewModel)
}

public class STPhotoMapView: UIView {
    public weak var mapView: MKMapView!
    public weak var dataSource: STPhotoMapViewDataSource!
    
    var interactor: STPhotoMapBusinessLogic?
    
    weak var progressView: UIProgressView!
    weak var entityLevelView: STEntityLevelView!
    
    private var photoTileOverlay: STPhotoTileOverlay?
    
    public convenience init(dataSource: STPhotoMapViewDataSource) {
        self.init()
        self.dataSource = dataSource
        
        self.setupTileOverlay()
    }
    
    public convenience init() {
        self.init(frame: .zero)
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
        self.setupSubviews()
        self.setupSubviewsConstraints()
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

// MARK: - Display logic

extension STPhotoMapView: STPhotoMapDisplayLogic {
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
    
    func displayEntityLevel(viewModel: STPhotoMapModels.EntityZoomLevel.ViewModel) {
        DispatchQueue.main.async {
            self.showEntityLevelView(title: viewModel.title, image: viewModel.image)
        }
    }
    
    private func showEntityLevelView(title: String?, image: UIImage?) {
        let model = STEntityLevelView.Model(title: title, image: image)
        self.setupEntityLevelView(model: model)
        self.setupEntityLevelViewConstraints()
        self.entityLevelView?.show()
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
}
