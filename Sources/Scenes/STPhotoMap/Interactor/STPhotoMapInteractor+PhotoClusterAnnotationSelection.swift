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
        let photoAnnotation = request.photoAnnotation
        if photoAnnotation.isSelected == true {
            self.presenter?.presentNavigateToPhotoDetails(response: STPhotoMapModels.PhotoDetailsNavigation.Response(photoId: photoAnnotation.model.photoId))
        } else {
            self.shouldHandleNonSelectedPhotoClusterAnnotation(request.clusterAnnotation, photoAnnotation: photoAnnotation, previousPhotoAnnotation: request.previousPhotoAnnotation)
            self.shouldGetPhotoDetailsFor(photoAnnotation)
        }
    }
    
    private func shouldHandleNonSelectedPhotoClusterAnnotation(_ clusterAnnotation: MultiplePhotoClusterAnnotation, photoAnnotation: PhotoAnnotation, previousPhotoAnnotation: PhotoAnnotation?) {
        if self.isLocationLevel() {
            self.presenter?.presentDeselectPhotoClusterAnnotation(response: STPhotoMapModels.PhotoClusterAnnotationDeselection.Response(photoAnnotation: previousPhotoAnnotation))
            self.presenter?.presentDeselectPhotoAnnotation(response: STPhotoMapModels.PhotoAnnotationDeselection.Response(photoAnnotation: previousPhotoAnnotation))
            self.presenter?.presentSelectPhotoAnnotation(response: STPhotoMapModels.PhotoAnnotationSelection.Response(photoAnnotation: photoAnnotation))
            self.presenter?.presentSelectPhotoClusterAnnotation(response: STPhotoMapModels.PhotoClusterAnnotationSelection.Response(photoAnnotation: photoAnnotation))
        }
    }
}
