//
//  EntityLevel.swift
//  STPhotoMap-iOS
//
//  Created by Dimitri Strauneanu on 31/07/2018.
//  Copyright © 2018 mikelanza. All rights reserved.
//

import Foundation

public enum EntityLevel: String {
    case location = "location"
    case block = "block"
    case neighborhood = "neighborhood"
    case city = "city"
    case county = "county"
    case state = "state"
    case country = "country"
    case unknown = ""
    
    static func from(value: String) -> EntityLevel {
        return EntityLevel(rawValue: value) ?? .unknown
    }
}
