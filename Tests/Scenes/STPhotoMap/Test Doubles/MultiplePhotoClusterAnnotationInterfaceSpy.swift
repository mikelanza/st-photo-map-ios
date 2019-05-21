//
//  MultiplePhotoClusterAnnotationInterfaceSpy.swift
//  STPhotoMapTests-iOS
//
//  Created by Dimitri Strauneanu on 21/05/2019.
//  Copyright © 2019 mikelanza. All rights reserved.
//

@testable import STPhotoMap
import UIKit

class MultiplePhotoClusterAnnotationInterfaceSpy: NSObject, MultiplePhotoClusterAnnotationInterface {
    var inflateCalled: Bool = false
    var deflateCalled: Bool = false
    
    func setImage(photoId: String, image: UIImage?) {
        
    }
    
    func setIsLoading(photoId: String, isLoading: Bool) {
        
    }
    
    func setIsSelected(photoId: String, isSelected: Bool) {
        
    }
    
    func inflate() {
        self.inflateCalled = true
    }
    
    func deflate() {
        self.deflateCalled = true
    }
}
