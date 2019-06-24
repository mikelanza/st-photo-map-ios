//
//  STPhotoMapView+MKMapView.swift
//  STPhotoMap-iOS
//
//  Created by Dimitri Strauneanu on 24/06/2019.
//  Copyright © 2019 mikelanza. All rights reserved.
//

import UIKit
import MapKit

extension STPhotoMapView: MKMapViewDelegate {
    public func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        let visibleTiles = mapView.visibleTiles()
        let visibleMapRect = mapView.visibleMapRect
        
        DispatchQueue.global().async {
            self.interactor?.shouldUpdateVisibleMapRect(request: STPhotoMapModels.VisibleMapRect.Request(mapRect: visibleMapRect))
            self.interactor?.shouldUpdateVisibleTiles(request: STPhotoMapModels.VisibleTiles.Request(tiles: visibleTiles))
            self.interactor?.shouldCacheGeojsonObjects()
            self.interactor?.shouldDetermineEntityLevel()
            self.interactor?.shouldDetermineLocationLevel()
            self.interactor?.shouldDetermineCarousel()
            self.interactor?.shouldDetermineSelectedPhotoAnnotation()
        }
    }
    
    public func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if overlay is STPhotoTileOverlay {
            let renderer = STPhotoTileOverlayRenderer(tileOverlay: overlay as! STPhotoTileOverlay)
            self.tileOverlayRenderer = renderer
            return renderer
        }
        
        if overlay is STCarouselOverlay {
            return STCarouselOverlayRenderer(carouselOverlay: overlay as! STCarouselOverlay, visibleMapRect: mapView.visibleMapRect)
        }
        
        return MKOverlayRenderer(overlay: overlay)
    }
    
    public func mapViewDidChangeVisibleRegion(_ mapView: MKMapView) {
        STPhotoMapParametersHandler.shared.update(parameter: KeyValue(Parameters.Keys.bbox, mapView.boundingBox().description))
    }
    
    public func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if let photoAnnotation = annotation as? PhotoAnnotation {
            let view = photoAnnotation.annotationView()
            view.delegate = self
            self.shouldDownloadImageForPhotoAnnotation(photoAnnotation)
            return view
        } else if let clusterAnnotation = annotation as? MultiplePhotoClusterAnnotation {
            let view = clusterAnnotation.annotationView()
            view?.delegate = self
            return view
        } else if let clusterAnnotation = annotation as? MKClusterAnnotation {
            return ClusterAnnotationView(count: clusterAnnotation.memberAnnotations.count, annotation: annotation)
        }
        return nil
    }
    
    public func mapView(_ mapView: MKMapView, clusterAnnotationForMemberAnnotations memberAnnotations: [MKAnnotation]) -> MKClusterAnnotation {
        guard let photoAnnotations = memberAnnotations as? [PhotoAnnotation] else {
            return MKClusterAnnotation(memberAnnotations: memberAnnotations)
        }
        
        let photoIds = photoAnnotations.compactMap({ $0.model.photoId })
        return MultiplePhotoClusterAnnotation(photoIds: photoIds, memberAnnotations: memberAnnotations)
    }
}
