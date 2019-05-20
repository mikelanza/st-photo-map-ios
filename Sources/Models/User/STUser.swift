//
//  STUser.swift
//  STPhotoMap-iOS
//
//  Created by Dimitri Strauneanu on 20/05/2019.
//  Copyright © 2019 mikelanza. All rights reserved.
//

import Foundation

struct STUser: Codable {
    var id: String
    
    var firstName: String { return self._firstName ?? "" }
    private var _firstName: String?
    
    var lastName: String { return self._lastName ?? "" }
    private var _lastName: String?
    
    init(id: String) {
        self.id = id
    }
    
    enum CodingKeys: String, CodingKey {
        case id = "objectId"
        case _firstName = "firstName"
        case _lastName = "lastName"
    }
}
