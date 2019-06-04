//
//  STPhotoMapAnnotationHandler.swift
//  STPhotoMap-iOS
//
//  Created by Crasneanu Cristian on 20/05/2019.
//  Copyright © 2019 mikelanza. All rights reserved.
//

import Foundation
import MapKit

class STPhotoMapAnnotationHandler {
    var annotations: Array<PhotoAnnotation>
    var selectedPhotoAnnotation: PhotoAnnotation?
    var selectedPhotoClusterAnnotation: MultiplePhotoClusterAnnotation?
    
    init() {
        self.annotations = Array()
    }
    
    func addAnnotations(annotations: [PhotoAnnotation]) {
        for annotation in annotations {
            self.addAnnotation(annotation: annotation)
        }
    }
    
    func addAnnotation(annotation: PhotoAnnotation) {
        if self.annotations.first(where: { $0.model.photoId == annotation.model.photoId }) == nil {
            self.annotations.append(annotation)
        }
    }
    
    func updateAnnotation(annotation: PhotoAnnotation) {
        if let index = self.annotations.firstIndex(where: { $0.model.photoId == annotation.model.photoId }) {
            self.annotations.remove(at: index)
        }
        self.annotations.append(annotation)
    }
    
    func getVisibleAnnotations(mapRect: MKMapRect) -> [PhotoAnnotation] {
        return self.annotations.filter({ mapRect.contains(MKMapPoint($0.coordinate)) })
    }
    
    func removeAllAnnotations() {
        self.annotations.removeAll()
    }
}
