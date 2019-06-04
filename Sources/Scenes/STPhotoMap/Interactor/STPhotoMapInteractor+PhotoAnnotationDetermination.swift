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
        guard self.entityLevelHandler.entityLevel == .location else { return }
        
    }
    
    private func getClosestPointToCenter(features: [GeoJSONFeature]) -> GeoJSONPoint? {
        let center = self.visibleMapRect.origin.coordinate
        let points = self.points(from: features)
        
        let sortedPoints = points.sorted(by: { (lht, rht) -> Bool in
            lht.locationCoordinate.distance(from: center) < rht.locationCoordinate.distance(from: center)
        })
        return sortedPoints.first
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
