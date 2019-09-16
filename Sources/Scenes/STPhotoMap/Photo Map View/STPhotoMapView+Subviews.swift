//
//  STPhotoMapView+Subviews.swift
//  STPhotoMap-iOS
//
//  Created by Dimitri Strauneanu on 24/06/2019.
//  Copyright © 2019 Streetography. All rights reserved.
//

import UIKit

extension STPhotoMapView {
    func setupSubviews() {
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
        mapView.isRotateEnabled = false
        mapView.showsUserLocation = true
        mapView.isPitchEnabled = false
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
    
    func setupEntityLevelView(model: STEntityLevelView.Model) {
        let view = STEntityLevelView(model: model)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.alpha = 0.0
        view.isUserInteractionEnabled = false
        self.addSubview(view)
        self.entityLevelView = view
    }
    
    func setupLocationOverlayView(model: STLocationOverlayView.Model) {
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
    func setupSubviewsConstraints() {
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
    
    func setupEntityLevelViewConstraints() {
        self.entityLevelView?.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        self.entityLevelView?.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        self.entityLevelView?.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        self.entityLevelView?.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
    }
    
    func setupLocationOverlayViewConstraints() {
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
