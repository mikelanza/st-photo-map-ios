//
//  PhotoAnnotation.swift
//  STPhotoMap
//
//  Created by Dimitri Strauneanu on 16/05/2019.
//  Copyright © 2019 mikelanza. All rights reserved.
//

import Foundation
import MapKit

class PhotoAnnotation: NSObject, MKAnnotation {
    class Model {
        var photoId: String
        var imageUrl: String?
        
        init(photoId: String) {
            self.photoId = photoId
        }
    }
    
    dynamic var coordinate: CLLocationCoordinate2D
    
    var model: Model
    
    var image: UIImage? {
        didSet {
            DispatchQueue.main.async {
                self.interface?.setImage(image: self.image)
            }
        }
    }
    
    var isLoading: Bool = false {
        didSet {
            DispatchQueue.main.async {
                self.interface?.setIsLoading(isLoading: self.isLoading)
            }
        }
    }
    
    var isSelected: Bool = false {
        didSet {
            DispatchQueue.main.async {
                self.interface?.setIsSelected(isSelected: self.isSelected)
            }
        }
    }
    
    weak var interface: PhotoAnnotationInterface?
    
    init(id: String, coordinate: CLLocationCoordinate2D) {
        self.model = PhotoAnnotation.Model(photoId: id)
        self.coordinate = coordinate
    }
    
    func annotationView() -> PhotoAnnotationView {
        let view = PhotoAnnotationView(annotation: self)
        self.interface = view
        view.setImage(image: self.image)
        view.setIsLoading(isLoading: self.isLoading)
        return view
    }
}
