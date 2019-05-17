//
//  STPhotoMapInteractor+Location.swift
//  STPhotoMap-iOS
//
//  Created by Crasneanu Cristian on 17/05/2019.
//  Copyright © 2019 mikelanza. All rights reserved.
//

import Foundation

// MARK: - Location logic

extension STPhotoMapInteractor {
    func shouldDetermineLocationLevel() {
        guard isLocationLevel() else { return }
        
        let cachedTiles = self.getVisibleCachedTiles()
        self.presentPhotoAnnotationsForCached(tiles: cachedTiles)
    }
    
    private func presentLocationAnnotations(annotations: [STPhotoMapModels.Annotation]) {
        self.presenter?.presentLocationAnnotations(response: STPhotoMapModels.LocationAnnotations.Response(annotations: annotations))
    }
    
    func isLocationLevel() -> Bool {
        return self.entityLevelHandler.entityLevel == EntityLevel.location
    }
    
    private func presentPhotoAnnotationsForCached(tiles:  [STPhotoMapCache.Tile]) {
        var annotations =  [STPhotoMapModels.Annotation]()
        for tile in tiles {
            let tileAnnotations = self.getAnnotations(from: tile.geojsonObject)
            if tileAnnotations.isEmpty == false {
                annotations.append(contentsOf: tileAnnotations)
            }
        }
        self.presentLocationAnnotations(annotations: annotations)
    }
    
    private func getAnnotations(from geojsonObject: GeoJSONObject) -> [STPhotoMapModels.Annotation] {
        return self.getAnnotations(from: geojsonObject.features())
    }
    
    private func getAnnotations(from features: [GeoJSONFeature]) -> [STPhotoMapModels.Annotation] {
        var annotations: [STPhotoMapModels.Annotation] = []
        for feature in features {
            if let annotation = self.annotation(from: feature) {
                annotations.append(annotation)
            }
        }
        return annotations
    }
    
    private func annotation(from feature: GeoJSONFeature) -> STPhotoMapModels.Annotation? {
        if let id = feature.idAsString, let point = feature.geometry as? GeoJSONPoint {
            return STPhotoMapModels.Annotation(id: id, imageUrl: feature.photoProperties?.image250Url,  latitude: point.latitude, longitude: point.longitude)
        }
        return nil
    }
}
