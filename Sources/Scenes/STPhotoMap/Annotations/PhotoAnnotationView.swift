//
//  PhotoAnnotationView.swift
//  STPhotoMap
//
//  Created by Dimitri Strauneanu on 16/05/2019.
//  Copyright © 2019 mikelanza. All rights reserved.
//

import Foundation
import MapKit

protocol PhotoAnnotationInterface: NSObjectProtocol {
    func setImage(image: UIImage?)
    func setIsLoading(isLoading: Bool)
    func setIsSelected(isSelected: Bool)
}

protocol PhotoAnnotationViewDelegate: NSObjectProtocol {
    func photoAnnotationView(view: PhotoAnnotationView?, with photoAnnotation: PhotoAnnotation?, didSelect photoImageView: PhotoImageView?)
}

class PhotoAnnotationView: MKAnnotationView, DefaultReuseIdentifier {
    private weak var photoImageView: PhotoImageView?
    
    weak var delegate: PhotoAnnotationViewDelegate?
    
    convenience init(annotation: MKAnnotation?) {
        self.init(annotation: annotation, reuseIdentifier: PhotoAnnotationView.defaultReuseIdentifier)
    }
    
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        self.clusteringIdentifier = reuseIdentifier
        self.setupSubviews()
        self.setupSubviewsConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setupSubviews()
        self.setupSubviewsConstraints()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.setIsLoading(isLoading: false)
    }
}

// MARK: - Subviews configuration

extension PhotoAnnotationView {
    private func setupSubviews() {
        self.setupContentView()
        self.setupPhotoImageView()
    }
    
    private func setupContentView() {
        self.frame = CGRect(origin: CGPoint.zero, size: CGSize(width: 80, height: 80))
    }
    
    private func setupPhotoImageView() {
        let photoImageView = PhotoImageView()
        photoImageView.delegate = self
        photoImageView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(photoImageView)
        self.photoImageView = photoImageView
    }
}

// MARK: - Subviews constraints configuration

extension PhotoAnnotationView {
    private func setupSubviewsConstraints() {
        self.setupPhotoImageViewConstraints()
    }
    
    private func setupPhotoImageViewConstraints() {
        self.photoImageView?.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        self.photoImageView?.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        self.photoImageView?.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        self.photoImageView?.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
    }
}

// MARK: - Photo annotation interface

extension PhotoAnnotationView: PhotoAnnotationInterface {
    func setImage(image: UIImage?) {
        self.photoImageView?.setImage(image: image)
    }
    
    func setIsLoading(isLoading: Bool) {
        self.photoImageView?.setLoading(loading: isLoading)
    }
    
    func setIsSelected(isSelected: Bool) {
        self.photoImageView?.setSelected(selected: isSelected)
    }
}

// MARK: - Photo image view delegate

extension PhotoAnnotationView: PhotoImageViewDelegate {
    func photoImageView(view: PhotoImageView?, didSelect button: UIButton?) {
        self.delegate?.photoAnnotationView(view: self, with: self.annotation as? PhotoAnnotation, didSelect: view)
    }
}
