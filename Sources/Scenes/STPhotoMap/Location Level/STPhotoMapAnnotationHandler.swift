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
    
    init() {
        self.annotations = Array()
    }
    
    func addAnnotations(annotations: [PhotoAnnotation]) {
        for annotation in annotations {
            self.addAnnotation(annotation: annotation)
        }
    }
    
    func addAnnotation(annotation: PhotoAnnotation) {
        let savedAnnotation = self.annotations.first { (photoAnnotation) -> Bool in
            photoAnnotation.model.photoId == annotation.model.photoId
        }
        
        if savedAnnotation == nil {
            self.annotations.append(annotation)
        }
    }
    
    func getVisibleAnnotations(mapRect: MKMapRect) -> [PhotoAnnotation] {
        return self.annotations.filter({ mapRect.contains(MKMapPoint($0.coordinate)) })
    }
    
    func removeAllAnnotations() {
        self.annotations.removeAll()
    }
}
