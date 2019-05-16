//
//  PhotoProperties.swift
//  STPhotoMap-iOS
//
//  Created by Dimitri Strauneanu on 13/07/2018.
//  Copyright © 2018 mikelanza. All rights reserved.
//

import Foundation

public struct PhotoProperties {
    public var type: String = ""
    public var name: String = ""
    public var photoId: String = ""
    public var photoCount: Int = 0
    public var photoLocation: Coordinate?
    public var image60Url: String = ""
    public var image250Url: String = ""
    
    public init() {
        
    }
}
