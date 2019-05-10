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

enum STPhotoMapModels {
    enum VisibleTiles {
        struct Request {
            let tiles: [TileCoordinate]
        }
    }
    
    enum EntityZoomLevel {
        struct Response {
            let photoProperties: PhotoProperties
        }
        
        struct ViewModel {
            let title: String?
            let image: UIImage?
        }
    }
}
