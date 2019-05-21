//
//  STPhotoMapInteractor+SelectPhotoAnnotation.swift
//  STPhotoMap-iOS
//
//  Created by Dimitri Strauneanu on 20/05/2019.
//  Copyright © 2019 mikelanza. All rights reserved.
//

import Foundation

extension STPhotoMapInteractor {
    func shouldSelectPhotoAnnotation(request: STPhotoMapModels.PhotoAnnotationSelection.Request) {
        let photoAnnotation = request.photoAnnotation
        if photoAnnotation.isSelected == true {
            self.presenter?.presentNavigateToPhotoDetails(response: STPhotoMapModels.PhotoDetailsNavigation.Response(photoId: photoAnnotation.model.photoId))
        } else {
            self.shouldHandleNonSelectedPhotoAnnotation(photoAnnotation, previousPhotoAnnotation: request.previousPhotoAnnotation)
            self.shouldGetPhotoDetailsFor(photoAnnotation)
        }
    }
    
    private func shouldHandleNonSelectedPhotoAnnotation(_ photoAnnotation: PhotoAnnotation, previousPhotoAnnotation: PhotoAnnotation?) {
        if self.isLocationLevel() {
            previousPhotoAnnotation?.isSelected = false
            photoAnnotation.isSelected = true
        }
    }
    
    private func shouldGetPhotoDetailsFor(_ photoAnnotation: PhotoAnnotation) {
        if self.isLocationLevel() {
            self.presenter?.presentLoadingState()
            self.worker?.getPhotoDetailsForPhotoAnnotation(photoAnnotation)
        }
    }
    
    private func shouldPresentLocationOverlayFor(_ photo: STPhoto) {
        if self.isLocationLevel() {
            self.presenter?.presentLocationOverlay(response: STPhotoMapModels.LocationOverlay.Response(photo: photo))
        }
    }
}

extension STPhotoMapInteractor {
    func successDidGetPhotoForPhotoAnnotation(photoAnnotation: PhotoAnnotation, photo: STPhoto) {
        self.presenter?.presentNotLoadingState()
        self.shouldPresentLocationOverlayFor(photo)
    }
    
    func failureDidGetPhotoForPhotoAnnotation(photoAnnotation: PhotoAnnotation, error: OperationError) {
        self.presenter?.presentNotLoadingState()
    }
}
