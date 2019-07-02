//
//  STActionMapView.swift
//  STPhotoMap-iOS
//
//  Created by Dimitri Strauneanu on 23/05/2019.
//  Copyright © 2019 mikelanza. All rights reserved.
//

import MapKit

protocol STActionMapViewDelegate: NSObjectProtocol {
    func actionMapView(mapView: STActionMapView?, didSelect carouselOverlay: STCarouselOverlay, atLocation location: STLocation)
    func actionMapView(mapView: STActionMapView?, didSelect tileCoordinate: TileCoordinate, atLocation location: STLocation)
    func actionMapView(mapView: STActionMapView?, didSelectCarouselPhoto photoId: String, atLocation location: STLocation)
}

public class STActionMapView: MKMapView {
    weak var actionMapViewDelegate: STActionMapViewDelegate?
    
    override public func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first, touch.tapCount == 1 else {
            return self.touchesEnded(touches, with: event, block: nil)
        }
        
        let touchLocation = touch.location(in: self)
        let coordinate = self.convert(touchLocation, toCoordinateFrom: self)
        
        if let overlay = self.carouselOverlayFor(coordinate, shouldDrawEntityButton: false) {
            return self.touchesEnded(touches, with: event, block: {
                self.didSelectCarouselPhoto(overlay, atLocation: STLocation.from(coordinate: coordinate))
            })
        }
        
        if let overlay = self.carouselOverlayWith(shouldDrawEntityButton: true), let renderer = self.renderer(for: overlay) as? STCarouselOverlayRenderer {
            if renderer.didSelectEntityButtonAtCoordinate(coordinate) {
                return self.touchesEnded(touches, with: event, block: {
                    self.didSelectCarouselOverlay(overlay)
                })
            } else if renderer.didSelectEntityOverlayAtCoordinate(coordinate) {
                return self.touchesEnded(touches, with: event, block: {
                    self.didSelectCarouselPhoto(overlay, atLocation: STLocation.from(coordinate: coordinate))
                })
            }
        }
        
        return self.touchesEnded(touches, with: event, block: {
            self.didSelectCoordinate(coordinate)
        })
    }
    
    private func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?, block: (() -> Void)?) -> Void {
        block?()
        super.touchesEnded(touches, with: event)
        return
    }
    
    private func carouselOverlayFor(_ coordinate: CLLocationCoordinate2D, shouldDrawEntityButton: Bool) -> STCarouselOverlay? {
        return self.overlays.first(where: { overlay -> Bool in
            if let carouselOverlay = overlay as? STCarouselOverlay, carouselOverlay.containsCoordinate(coordinate: coordinate) {
                return carouselOverlay.model.shouldDrawEntityButton == shouldDrawEntityButton
            }
            return false
        }) as? STCarouselOverlay
    }
    
    private func carouselOverlayWith(shouldDrawEntityButton: Bool) -> STCarouselOverlay? {
        return self.overlays.first(where: { overlay -> Bool in
            if let carouselOverlay = overlay as? STCarouselOverlay {
                return carouselOverlay.model.shouldDrawEntityButton == shouldDrawEntityButton
            }
            return false
        }) as? STCarouselOverlay
    }
    
    private func didSelectCarouselPhoto(_ overlay: STCarouselOverlay, atLocation location: STLocation) {
        self.actionMapViewDelegate?.actionMapView(mapView: self, didSelectCarouselPhoto: overlay.model.photoId, atLocation: location)
    }
    
    private func didSelectCarouselOverlay(_ overlay: STCarouselOverlay) {
        self.actionMapViewDelegate?.actionMapView(mapView: self, didSelect: overlay, atLocation: overlay.model.location)
    }
    
    private func didSelectCoordinate(_ coordinate: CLLocationCoordinate2D) {
        let tile = TileCoordinate(coordinate: coordinate, zoom: self.zoomLevel())
        let location = STLocation.from(coordinate: coordinate)
        self.actionMapViewDelegate?.actionMapView(mapView: self, didSelect: tile, atLocation: location)
    }
    
    // MARK: - Annotations
    
    func updateAnnotation(_ photoAnnotation: PhotoAnnotation) {
        var existentAnnotation: PhotoAnnotation?
        
        self.annotations.forEach { annotation in
            if let annotation = annotation as? PhotoAnnotation, annotation.model.photoId == photoAnnotation.model.photoId {
                existentAnnotation = annotation
            }
        }
        
        if let existentAnnotation = existentAnnotation {
            self.removeAnnotation(existentAnnotation)
        }
        self.addAnnotation(photoAnnotation)
    }
}
