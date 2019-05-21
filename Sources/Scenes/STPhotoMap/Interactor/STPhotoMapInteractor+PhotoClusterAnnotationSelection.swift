//
//  STPhotoMapInteractor+PhotoClusterAnnotationSelection.swift
//  STPhotoMap-iOS
//
//  Created by Dimitri Strauneanu on 21/05/2019.
//  Copyright © 2019 mikelanza. All rights reserved.
//

import Foundation

extension STPhotoMapInteractor {
    func shouldSelectPhotoClusterAnnotation(request: STPhotoMapModels.PhotoClusterAnnotationSelection.Request) {
        let zoomLevel = request.zoomLevel
        let clusterAnnotation = request.clusterAnnotation
        let photoIds = clusterAnnotation.photoIds
        
        if zoomLevel == 20 && photoIds.count > 15 {
            self.presenter?.presentNavigateToSpecificPhotos(response: STPhotoMapModels.SpecificPhotosNavigation.Response(photoIds: photoIds))
        } else if zoomLevel == 20 || clusterAnnotation.doMemberAnnotationsHaveSameCoordinate() {
            request.previousClusterAnnotation?.deflate()
            clusterAnnotation.inflate()
            self.shouldDownloadImagesForPhotoClusterAnnotation(clusterAnnotation)
        }
    }
    
    private func shouldDownloadImagesForPhotoClusterAnnotation(_ clusterAnnotation: MultiplePhotoClusterAnnotation) {
        clusterAnnotation.multipleAnnotationModels.forEach { (key, value) in
            value.isLoading = true
            self.worker?.downloadImageForPhotoAnnotation(value)
        }
    }
}
