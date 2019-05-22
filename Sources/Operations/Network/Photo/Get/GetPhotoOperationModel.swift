//
//  GetPhotoOperationModel.swift
//  STPhotoMap-iOS
//
//  Created by Dimitri Strauneanu on 20/05/2019.
//  Copyright © 2019 mikelanza. All rights reserved.
//

import Foundation

enum GetPhotoOperationModel {
    struct Request {
        let photoId: String
        let includeUser: Bool = true
    }
    
    struct Response: Codable {
        let photo: STPhoto
    }
}
