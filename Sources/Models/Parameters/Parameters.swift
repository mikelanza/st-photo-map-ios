//
//  Parameters.swift
//  STPhotoMap-iOS
//
//  Created by Dimitri Strauneanu on 15/04/2019.
//  Copyright © 2019 mikelanza. All rights reserved.
//

import Foundation

public typealias KeyValue = (key: String, value: String)

public class Parameters {
    public static func defaultParameters() -> [KeyValue] {
        return [
            ("shadow", "yes"),
            ("basemap", "yes")
        ]
    }
}
