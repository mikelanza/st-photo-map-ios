//
//  MultiplePhotoClusterAnnotation.swift
//  STPhotoMap
//
//  Created by Dimitri Strauneanu on 16/05/2019.
//  Copyright © 2019 Streetography. All rights reserved.
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
        let view = MultiplePhotoClusterAnnotationView(annotation: self, count: self.memberAnnotations.count)
        self.interface = view
        return view
    }
    
    func annotation(for index: Int) -> PhotoAnnotation? {
        let photoId = Array(self.multipleAnnotationModels.keys)[index]
        return self.multipleAnnotationModels[photoId]
    }
    
    func inflate() {
        self.interface?.inflate()
    }
    
    func deflate() {
        self.interface?.deflate()
    }
}
