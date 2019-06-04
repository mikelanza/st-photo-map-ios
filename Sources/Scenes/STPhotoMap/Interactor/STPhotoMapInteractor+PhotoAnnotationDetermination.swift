//
//  STPhotoMapInteractor+PhotoAnnotationDetermination.swift
//  STPhotoMap-iOS
//
//  Created by Crasneanu Cristian on 04/06/2019.
//  Copyright © 2019 mikelanza. All rights reserved.
//

import Foundation
import MapKit

// MARK: - Determine selected photo annotation

extension STPhotoMapInteractor {
    func shouldDetermineSelectedPhotoAnnotation() {
        guard self.shouldChangePhotoAnnotation() else { return }
        
        let cachedTiles = self.getVisibleCachedTiles()
        let geojsonObjects = cachedTiles.compactMap({ $0.geojsonObject })
        let features: [GeoJSONFeature] = geojsonObjects.flatMap({ $0.features() })
        
        self.determineSelectedPhotoAnnotation(from: features)
    }
    
    private func shouldChangePhotoAnnotation() -> Bool {
        guard self.entityLevelHandler.entityLevel == .location else { return false }
        guard self.isSelectedPhotoAnnotationVisibleOnScreen() == false else { return false }
        return true
    }
    
    private func determineSelectedPhotoAnnotation(from features: [GeoJSONFeature]) {
        if let bestAnnotation = self.bestAnnotation(features: features) {
            let newPhotoAnnotation = bestAnnotation.toPhotoAnnotation()
            self.presenter?.presentDeselectPhotoAnnotation(response: STPhotoMapModels.PhotoAnnotationDeselection.Response(photoAnnotation: self.selectedPhotoAnnotation))
            self.presenter?.presentSelectPhotoAnnotation(response: STPhotoMapModels.PhotoAnnotationSelection.Response(photoAnnotation: newPhotoAnnotation))
            
            self.shouldGetPhotoDetailsFor(newPhotoAnnotation)
            
            self.selectedPhotoAnnotation = newPhotoAnnotation
        }
    }
    
    internal func determineSelectedPhotoAnnotationForDownloadedLocationTile(features: [GeoJSONFeature] ) {
        guard self.shouldChangePhotoAnnotation() else { return }        
        self.determineSelectedPhotoAnnotation(from: features)
    }
    
    private func bestAnnotation(features: [GeoJSONFeature]) -> STPhotoMapModels.Annotation? {
        let center = self.visibleMapRect.origin.coordinate
        let annotations = self.getAnnotations(from: features)
        
        let annotationsSortedByDistance = annotations.sorted(by: { (lht, rht) -> Bool in
            lht.distance(from: center) < rht.distance(from: center)
        })
        return annotationsSortedByDistance.first
    }
    
    private func isSelectedPhotoAnnotationVisibleOnScreen() -> Bool {
        guard let coordinate = self.selectedPhotoAnnotation?.coordinate else { return false }
        return visibleMapRect.contains(MKMapPoint(coordinate))
    }
    
    private func points(from features: [GeoJSONFeature]) -> [GeoJSONPoint] {
        return features.compactMap({ (feature) -> GeoJSONPoint? in
            if let _ = feature.idAsString, let point = feature.geometry as? GeoJSONPoint {
                return point
            }
            return nil
        })
    }
}
