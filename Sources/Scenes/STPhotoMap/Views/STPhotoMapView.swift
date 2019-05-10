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

public class STPhotoMapView: UIView {
    public weak var mapView: MKMapView!
    public weak var dataSource: STPhotoMapViewDataSource!
    
    var interactor: STPhotoMapBusinessLogic?
    
    weak var progressView: UIProgressView!
    
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
        self.progressView?.isHidden = false
        self.progressView?.setProgress(1.0, animated: true)
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func displayNotLoadingState() {
        self.progressView?.isHidden = true
        self.progressView?.setProgress(0.0, animated: false)
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
}

// MARK: - MKMapView delegate methods

extension STPhotoMapView: MKMapViewDelegate {
    public func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        self.interactor?.shouldUpdateVisibleTiles(request: STPhotoMapModels.VisibleTiles.Request(tiles: mapView.visibleTiles()))
        self.interactor?.shouldCacheGeojsonObjects()
    }
    
    public func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if overlay is STPhotoTileOverlay {
            return STPhotoTileOverlayRenderer(tileOverlay: overlay as! STPhotoTileOverlay)
        }
        
        return MKOverlayRenderer(overlay: overlay)
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
}
