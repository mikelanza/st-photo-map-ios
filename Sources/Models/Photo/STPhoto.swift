//
//  STPhoto.swift
//  STPhotoMap-iOS
//
//  Created by Dimitri Strauneanu on 20/05/2019.
//  Copyright © 2019 mikelanza. All rights reserved.
//

import Foundation

struct STPhoto: Codable {
    var id: String
    var createdAt: Date
    var user: STUser?
    
    var imageUrl: String?
    var image1200Url: String?
    var image750Url: String?
    var image650Url: String?
    
    var text: String { return self._text ?? "" }
    private var _text: String?
    
    var fhUsername: String { return self._fhUsername ?? "" }
    private var _fhUsername: String?
    
    init(id: String, createdAt: Date) {
        self.id = id
        self.createdAt = createdAt
    }
    
    enum CodingKeys: String, CodingKey {
        case id = "objectId"
        case createdAt = "createdAt"
        case user = "owner"
        case _text = "descriptionText"
        case _fhUsername = "fhOwnerUsername"
        case imageUrl = "imageOriginalURL"
        case image1200Url = "imageWidth1200URL"
        case image750Url = "imageWidth750URL"
        case image650Url = "imageWidth650URL"
    }
}
