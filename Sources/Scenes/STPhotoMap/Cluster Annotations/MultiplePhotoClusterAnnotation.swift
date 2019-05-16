//
//  MultiplePhotoClusterAnnotation.swift
//  STPhotoMap
//
//  Created by Dimitri Strauneanu on 16/05/2019.
//  Copyright © 2019 mikelanza. All rights reserved.
//

import MapKit

class MultiplePhotoClusterAnnotation: MKClusterAnnotation {
    var photoIds: [String] {
        get {
            return Array(self.multipleAnnotationModels.keys)
        }
    }
    
    var multipleAnnotationModels = [String: PhotoAnnotation]()
    
    weak var interface: MultiplePhotoClusterAnnotationInterface?
    
    init(photoIds: [String], memberAnnotations: [MKAnnotation]) {
        if let photoAnnotations = memberAnnotations as? [PhotoAnnotation] {
            for (index, photoId) in photoIds.enumerated() {
                self.multipleAnnotationModels[photoId] = photoAnnotations[index]
            }
        }
        super.init(memberAnnotations: memberAnnotations)
    }
    
    func annotationView() -> MultiplePhotoClusterAnnotationView? {
        return MultiplePhotoClusterAnnotationView(annotation: self, count: self.memberAnnotations.count)
    }
    
    public func setImage(index: Int, image: UIImage?, photoImageView: PhotoImageView?) {
        if let annotation = getAnnotation(for: index).1 {
            annotation.image = image
            photoImageView?.setImage(image: image)
        }
    }
    
    public func setIsSelected(index: Int, isSelected: Bool, photoImageView: PhotoImageView?) {
        if let annotation = getAnnotation(for: index).1 {
            annotation.isSelected = isSelected
            photoImageView?.setSelected(selected: isSelected)
        }
    }
    
    public func setIsLoading(index: Int, isLoading: Bool, photoImageView: PhotoImageView?) {
        if let annotation = getAnnotation(for: index).1 {
            annotation.isLoading = isLoading
            photoImageView?.setLoading(loading: isLoading)
        }
    }
    
    func getAnnotation(for index: Int) -> (String, PhotoAnnotation?) {
        let photoId = Array(self.multipleAnnotationModels.keys)[index]
        let model = self.multipleAnnotationModels[photoId]
        return (photoId, model)
    }
}
