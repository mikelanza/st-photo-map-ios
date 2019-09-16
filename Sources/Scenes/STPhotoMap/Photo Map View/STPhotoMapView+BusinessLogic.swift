//
//  STPhotoMapView+BusinessLogic.swift
//  STPhotoMap-iOS
//
//  Created by Dimitri Strauneanu on 24/06/2019.
//  Copyright © 2019 Streetography. All rights reserved.
//

import Foundation

extension STPhotoMapView {
    func shouldDownloadImageForPhotoAnnotation(_ photoAnnotation: PhotoAnnotation) {
        self.interactor?.shouldDownloadImageForPhotoAnnotation(request: STPhotoMapModels.PhotoAnnotationImageDownload.Request(photoAnnotation: photoAnnotation))
    }
    
    func shouldSelectPhotoAnnotation(_ photoAnnotation: PhotoAnnotation, previousPhotoAnnotation: PhotoAnnotation?) {
        self.interactor?.shouldSelectPhotoAnnotation(request: STPhotoMapModels.PhotoAnnotationSelection.Request(photoAnnotation: photoAnnotation, previousPhotoAnnotation: previousPhotoAnnotation))
    }
    
    func shouldInflatePhotoClusterAnnotation(_ clusterAnnotation: MultiplePhotoClusterAnnotation, previousClusterAnnotation: MultiplePhotoClusterAnnotation?, zoomLevel: Int) {
        self.interactor?.shouldInflatePhotoClusterAnnotation(request: STPhotoMapModels.PhotoClusterAnnotationInflation.Request(clusterAnnotation: clusterAnnotation, previousClusterAnnotation: previousClusterAnnotation, zoomLevel: zoomLevel))
    }
    
    func shouldSelectPhotoClusterAnnotation(_ clusterAnnotation: MultiplePhotoClusterAnnotation, photoAnnotation: PhotoAnnotation, previousPhotoAnnotation: PhotoAnnotation?) {
        self.interactor?.shouldSelectPhotoClusterAnnotation(request: STPhotoMapModels.PhotoClusterAnnotationSelection.Request(clusterAnnotation: clusterAnnotation, photoAnnotation: photoAnnotation, previousPhotoAnnotation: previousPhotoAnnotation))
    }
    
    func shouldUpdateSelectedPhotoAnnotation(_ photoAnnotation: PhotoAnnotation?) {
        self.interactor?.shouldUpdateSelectedPhotoAnnotation(request: STPhotoMapModels.SelectedPhotoAnnotation.Request(annotation: photoAnnotation))
    }
}
