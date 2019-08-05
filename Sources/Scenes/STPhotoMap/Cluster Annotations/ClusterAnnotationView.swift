//
//  ClusterAnnotationView.swift
//  STPhotoMap
//
//  Created by Dimitri Strauneanu on 16/05/2019.
//  Copyright © 2019 mikelanza. All rights reserved.
//

import MapKit
import STPhotoCore

class ClusterAnnotationView: MKAnnotationView, DefaultReuseIdentifier {
    private let count: Int
    private weak var clusterLabelView: ClusterLabelView!
    
    init(count: Int, annotation: MKAnnotation?, reuseIdentifier: String? = ClusterAnnotationView.defaultReuseIdentifier) {
        self.count = count
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        self.setupSubviews()
        self.setupSubviewsConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Subviews configuration

extension ClusterAnnotationView {
    private func setupSubviews() {
        self.setupClusterLabelView()
    }
    
    private func setupClusterLabelView() {
        let view = ClusterLabelView()
        view.setCount(count: self.count)
        self.addSubview(view)
        self.clusterLabelView = view
    }
}

// MARK: - Subviews constraints configuration

extension ClusterAnnotationView {
    private func setupSubviewsConstraints() {
        self.setupClusterLabelViewConstraints()
    }
    
    private func setupClusterLabelViewConstraints() {
        self.clusterLabelView?.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        self.clusterLabelView?.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
    }
}
