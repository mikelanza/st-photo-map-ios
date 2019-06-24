//
//  DownloadImageOperationModel.swift
//  STPhotoMap-iOS
//
//  Created by Crasneanu Cristian on 06/02/2019.
//  Copyright © 2019 mikelanza. All rights reserved.
//

import UIKit

enum DownloadImageOperationModel {
    struct Request {
        let url: String?
        let priority: Float = 1.0
    }
    
    struct Response {
        let data: Data?
        let image: UIImage
        let error: Error?
    }
}
