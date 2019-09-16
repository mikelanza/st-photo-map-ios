//
//  MultiplePhotoClusterAnnotationInterfaceSpy.swift
//  STPhotoMapTests-iOS
//
//  Created by Dimitri Strauneanu on 21/05/2019.
//  Copyright © 2019 Streetography. All rights reserved.
//

@testable import STPhotoMap
import UIKit

class MultiplePhotoClusterAnnotationInterfaceSpy: NSObject, MultiplePhotoClusterAnnotationInterface {
    var setImageCalled: Bool = false
    var setIsLoadingCalled: Bool = false
    var setIsSelectedCalled: Bool = false
    var inflateCalled: Bool = false
    var deflateCalled: Bool = false
    
    func setImage(photoId: String, image: UIImage?) {
        self.setImageCalled = true
    }
    
    func setIsLoading(photoId: String, isLoading: Bool) {
        self.setIsLoadingCalled = true
    }
    
    func setIsSelected(photoId: String, isSelected: Bool) {
        self.setIsSelectedCalled = true
    }
    
    func inflate() {
        self.inflateCalled = true
    }
    
    func deflate() {
        self.deflateCalled = true
    }
}
