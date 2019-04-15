//
//  STPhotoMapView.swift
//  STPhotoMap-iOS
//
//  Created by Dimitri Strauneanu on 12/04/2019.
//  Copyright © 2019 mikelanza. All rights reserved.
//

import UIKit
import MapKit

public class STPhotoMapView: UIView {
    public weak var mapView: MKMapView!
    
    private var photoTileOverlay: STPhotoTileOverlay?
    
    public convenience init() {
        self.init(frame: .zero)
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupSubviews()
        self.setupSubviewsConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
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
    public func addTileOverlay(model: STPhotoTileOverlay.Model) {
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
