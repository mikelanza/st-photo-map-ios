//
//  STPhotoMapInteractor+PhotoClusterAnnotationInflation.swift
//  STPhotoMap-iOS
//
//  Created by Dimitri Strauneanu on 22/05/2019.
//  Copyright © 2019 mikelanza. All rights reserved.
//

import Foundation

extension STPhotoMapInteractor {
    func shouldInflatePhotoClusterAnnotation(request: STPhotoMapModels.PhotoClusterAnnotationInflation.Request) {
        let zoomLevel = request.zoomLevel
        let clusterAnnotation = request.clusterAnnotation
        let photoIds = clusterAnnotation.photoIds
        
        if zoomLevel == 20 && photoIds.count > 15 {
            self.presenter?.presentNavigateToSpecificPhotos(response: STPhotoMapModels.SpecificPhotosNavigation.Response(photoIds: photoIds))
        } else if zoomLevel == 20 || clusterAnnotation.doMemberAnnotationsHaveSameCoordinate() {
            request.previousClusterAnnotation?.deflate()
            clusterAnnotation.inflate()
            self.shouldDownloadImagesForPhotoClusterAnnotation(clusterAnnotation)
        } else {
            self.presenter?.presentZoomToCoordinate(response: STPhotoMapModels.CoordinateZoom.Response(coordinate: clusterAnnotation.coordinate))
        }
    }
    
    private func shouldDownloadImagesForPhotoClusterAnnotation(_ clusterAnnotation: MultiplePhotoClusterAnnotation) {
        clusterAnnotation.multipleAnnotationModels.forEach { (key, value) in
            value.isLoading = true
            clusterAnnotation.interface?.setIsLoading(photoId: key, isLoading: true)
            
            self.worker?.downloadImageForPhotoAnnotation(value, completion: { image in
                clusterAnnotation.interface?.setIsLoading(photoId: key, isLoading: false)
                clusterAnnotation.interface?.setImage(photoId: key, image: image)
            })
        }
    }
}
