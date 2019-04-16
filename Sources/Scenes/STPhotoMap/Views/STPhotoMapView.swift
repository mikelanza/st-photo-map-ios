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
    public weak var dataSource: STPhotoMapViewDataSource! {
        didSet {
            self.setupTileOverlay()
        }
    }
    
    private var interactor: STPhotoMapBusinessLogic?
    private var photoTileOverlay: STPhotoTileOverlay?
    
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
    
    public override func didMoveToSuperview() {
        guard let _ = self.dataSource else {
            fatalError("You can not use STPhotoMapView without setting data source")
        }
    }
}

// MARK: - Display logic

extension STPhotoMapView: STPhotoMapDisplayLogic {
    
}

// MARK: - MKMapView delegate methods

extension STPhotoMapView: MKMapViewDelegate {
    public func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {

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
        
        let model = self.dataSource.photoMapView(self, photoTileOverlayModelForUrl: "https://tilesdev.streetography.com/tile/%d/%d/%d.jpeg", parameters: Parameters.defaultParameters())
        self.photoTileOverlay = STPhotoTileOverlay(model: model)
        self.photoTileOverlay?.canReplaceMapContent = true
        self.mapView?.addOverlay(self.photoTileOverlay!, level: .aboveLabels)
    }
}

// MARK: - Subviews configuration

extension STPhotoMapView {
    private func setupSubviews() {
        self.setupMapView()
    }
    
    private func setupMapView() {
        let mapView = MKMapView()
        mapView.translatesAutoresizingMaskIntoConstraints = false
        mapView.delegate = self
        self.addSubview(mapView)
        self.mapView = mapView
    }
}

// MARK: - Constraints configuration

extension STPhotoMapView {
    private func setupSubviewsConstraints() {
        self.setupMapViewConstraints()
    }
    
    private func setupMapViewConstraints() {
        self.mapView?.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        self.mapView?.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        self.mapView?.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        self.mapView?.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
    }
}
