//
//  MultiplePhotoClusterAnnotationView.swift
//  STPhotoMap
//
//  Created by Dimitri Strauneanu on 16/05/2019.
//  Copyright © 2019 mikelanza. All rights reserved.
//

import MapKit

protocol MultiplePhotoClusterAnnotationInterface: NSObjectProtocol {
    func setImage(photoId: String, image: UIImage?)
    func setIsLoading(photoId: String, isLoading: Bool)
    func setIsSelected(photoId: String, isSelected: Bool)
}

protocol MultiplePhotoClusterAnnotationViewDelegate: NSObjectProtocol {
    func multiplePhotoClusterAnnotationView(view: MultiplePhotoClusterAnnotationView?, didSelect clusterLabelView: ClusterLabelView?)
    func multiplePhotoClusterAnnotationView(view: MultiplePhotoClusterAnnotationView?, didSelect photoImageView: PhotoImageView?, at index: Int)
}

class MultiplePhotoClusterAnnotationView: MKAnnotationView, DefaultReuseIdentifier {
    private let count: Int
    private let animationDuration: TimeInterval = 0.25
    
    private weak var clusterLabelView: ClusterLabelView!
    private weak var calloutView: MultiplePhotoCalloutView!
    
    weak var delegate: MultiplePhotoClusterAnnotationViewDelegate?
    
    init(annotation: MKAnnotation?, count: Int) {
        self.count = count
        super.init(annotation: annotation, reuseIdentifier: MultiplePhotoClusterAnnotationView.defaultReuseIdentifier)
        self.deflate(animated: false)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.removeSubviews()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        if selected {
            self.inflate(animated: animated)
        } else {
            self.deflate(animated: animated)
        }
    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        if let hitView = super.hitTest(point, with: event) {
            return hitView
        }
        
        if let clusterLabelView = self.clusterLabelView {
            let pointInClusterLabelView = self.convert(point, to: clusterLabelView)
            return clusterLabelView.hitTest(pointInClusterLabelView, with: event)
        }
        
        if let calloutView = self.calloutView {
            let pointInCalloutView = self.convert(point, to: calloutView)
            return calloutView.hitTest(pointInCalloutView, with: event)
        }
        
        return nil
    }
}

// MARK: - Animate subviews

extension MultiplePhotoClusterAnnotationView {
    private func inflate(animated: Bool) {
        self.removeSubviews()
        self.addCalloutView()
        
        if animated {
            self.animateCalloutView()
        }
    }
    
    private func deflate(animated: Bool) {
        self.removeSubviews()
        self.addClusterLabelView()
        
        if animated {
            self.animateClusterLabelView()
        }
    }
    
    private func animateCalloutView() {
        self.calloutView?.alpha = 0
        UIView.animate(withDuration: self.animationDuration) {
            self.calloutView?.alpha = 1
        }
    }
    
    private func animateClusterLabelView() {
        self.clusterLabelView?.alpha = 0
        UIView.animate(withDuration: self.animationDuration) {
            self.clusterLabelView?.alpha = 1
        }
    }
}

// MARK: - Remove subviews

extension MultiplePhotoClusterAnnotationView {
    private func removeSubviews() {
        self.calloutView?.removeFromSuperview()
        self.clusterLabelView?.removeFromSuperview()
    }
}

// MARK: - Add subviews

extension MultiplePhotoClusterAnnotationView {
    private func addClusterLabelView() {
        let view = ClusterLabelView()
        view.delegate = self
        view.setCount(count: self.count)
        view.add(to: self)
        self.clusterLabelView = view
    }
    
    private func addCalloutView() {
        let view = MultiplePhotoCalloutView(photoIds: (self.annotation as? MultiplePhotoClusterAnnotation)?.photoIds ?? [])
        view.delegate = self
        view.backgroundColor = UIColor.clear
        view.add(to: self)
        self.calloutView = view
    }
}

// MARK: - Interface

extension MultiplePhotoClusterAnnotationView: MultiplePhotoClusterAnnotationInterface {
    func setImage(photoId: String, image: UIImage?) {
        self.calloutView?.setImage(photoId: photoId, image: image)
    }
    
    func setIsLoading(photoId: String, isLoading: Bool) {
        self.calloutView?.setIsLoading(photoId: photoId, isLoading: isLoading)
    }
    
    func setIsSelected(photoId: String, isSelected: Bool) {
        self.calloutView?.setIsSelected(photoId: photoId, isSelected: isSelected)
    }
}

// MARK: - Cluster label view delegate

extension MultiplePhotoClusterAnnotationView: ClusterLabelViewDelegate {
    func clusterLabelView(view: ClusterLabelView?, didSelect button: UIButton?) {
        self.delegate?.multiplePhotoClusterAnnotationView(view: self, didSelect: view)
    }
}

// MARK: - Multiple photo callout view delegate

extension MultiplePhotoClusterAnnotationView: MultiplePhotoCalloutViewDelegate {
    func multiplePhotoCalloutView(view: MultiplePhotoCalloutView?, didSelect photoImageView: PhotoImageView?, at index: Int) {
        self.delegate?.multiplePhotoClusterAnnotationView(view: self, didSelect: photoImageView, at: index)
    }
}
