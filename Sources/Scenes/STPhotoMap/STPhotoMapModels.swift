//
//  STPhotoMapModels.swift
//  STPhotoMap
//
//  Created by Crasneanu Cristian on 12/04/2019.
//  Copyright (c) 2019 mikelanza. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit
import MapKit
import STPhotoCore

enum STPhotoMapModels {
    enum VisibleTiles {
        struct Request {
            let tiles: [TileCoordinate]
        }
    }
    
    enum VisibleMapRect {
        struct Request {
            let mapRect: MKMapRect
        }
    }
    
    enum SelectedPhotoAnnotation {
        struct Request {
            let annotation: PhotoAnnotation?
        }
    }
    
    enum EntityZoomLevel {
        struct Response {
            let entityLevel: EntityLevel
        }
        
        struct ViewModel {
            let title: String?
            let image: UIImage?
        }
    }
    
    struct Annotation {
        let id: String
        let imageUrl: String?
        let latitude: Double
        let longitude: Double
        
        func toPhotoAnnotation() -> PhotoAnnotation {
            let pinAnnotation = PhotoAnnotation(id: id, coordinate: CLLocationCoordinate2D(latitude: self.latitude, longitude: self.longitude))
            pinAnnotation.model.imageUrl = imageUrl
            return pinAnnotation
        }
        
        func distance(from coordinate: CLLocationCoordinate2D) -> CLLocationDistance {
            return CLLocationCoordinate2D(latitude: latitude, longitude: longitude).distance(from: coordinate)
        }
    }
    
    enum LocationAnnotations {
        struct Response {
            let annotations: [Annotation]
        }
        
        struct ViewModel {
            let annotations: [PhotoAnnotation]
        }
    }
    
    enum PhotoAnnotationImageDownload {
        struct Request {
            let photoAnnotation: PhotoAnnotation
        }
    }
    
    enum PhotoAnnotationSelection {
        struct Request {
            let photoAnnotation: PhotoAnnotation
            let previousPhotoAnnotation: PhotoAnnotation?
        }
        
        struct Response {
            let photoAnnotation: PhotoAnnotation?
        }
        
        struct ViewModel {
            let photoAnnotation: PhotoAnnotation?
        }
    }
    
    enum PhotoAnnotationDeselection {
        struct Response {
            let photoAnnotation: PhotoAnnotation?
        }
        
        struct ViewModel {
            let photoAnnotation: PhotoAnnotation?
        }
    }
    
    enum PhotoClusterAnnotationSelection {
        struct Request {
            let clusterAnnotation: MultiplePhotoClusterAnnotation
            let photoAnnotation: PhotoAnnotation
            let previousPhotoAnnotation: PhotoAnnotation?
        }
        
        struct Response {
            let photoAnnotation: PhotoAnnotation
        }
        
        struct ViewModel {
            let photoAnnotation: PhotoAnnotation
        }
    }
    
    enum PhotoClusterAnnotationDeselection {
        struct Response {
            let photoAnnotation: PhotoAnnotation?
        }
        
        struct ViewModel {
            let photoAnnotation: PhotoAnnotation?
        }
    }
    
    enum PhotoDetailsNavigation {
        struct Request {
            let photoId: String
        }
        
        struct Response {
            let photoId: String
        }
        
        struct ViewModel {
            let photoId: String
        }
    }
    
    enum LocationOverlay {
        struct Response {
            let photo: STPhoto
        }
        
        struct ViewModel {
            let photoId: String
            let title: String?
            let time: String?
            let description: String?
        }
    }
    
    enum PhotoClusterAnnotationInflation {
        struct Request {
            let clusterAnnotation: MultiplePhotoClusterAnnotation
            let previousClusterAnnotation: MultiplePhotoClusterAnnotation?
            let zoomLevel: Int
        }
    }
    
    enum SpecificPhotosNavigation {
        struct Request {
            let photoIds: [String]
        }
        
        struct Response {
            let photoIds: [String]
        }
        
        struct ViewModel {
            let photoIds: [String]
        }
    }
    
    enum PhotoCollectionNavigation {
        struct Request {
            let location: STLocation
            let entityLevel: EntityLevel
        }
        
        struct Response {
            let location: STLocation
            let entityLevel: EntityLevel
        }
        
        struct ViewModel {
            let location: STLocation
            let entityLevel: EntityLevel
        }
    }
    
    enum CoordinateZoom {
        struct Response {
            let coordinate: CLLocationCoordinate2D
        }
        
        struct ViewModel {
            let coordinate: CLLocationCoordinate2D
        }
    }
    
    enum CoordinateCenter {
        struct Response {
            let coordinate: CLLocationCoordinate2D
            let entityLevel: EntityLevel
        }
        
        struct ViewModel {
            let region: MKCoordinateRegion
        }
    }
    
    enum CarouselSelection {
        struct Request {
            let tileCoordinate: TileCoordinate
            let location: STLocation
        }
    }
    
    enum NewCarousel {
        struct Response {
            let carousel: STCarousel
        }
        
        struct ViewModel {
            let overlays: [STCarouselOverlay]
        }
    }
    
    enum OpenApplication {
        struct Response {
            let url: URL
        }
        
        struct ViewModel {
            let url: URL
        }
    }
    
    enum LocationAccessDeniedAlert {
        struct ViewModel {
            let title: String?
            let message: String?
            let cancelTitle: String?
            let settingsTitle: String?
        }
    }
}
