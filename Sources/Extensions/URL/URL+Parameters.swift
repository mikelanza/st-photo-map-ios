//
//  URL+Parameters.swift
//  STPhotoMap-iOS
//
//  Created by Dimitri Strauneanu on 15/04/2019.
//  Copyright © 2019 mikelanza. All rights reserved.
//

import Foundation

extension URL {
    func addParameters(_ parameters: [KeyValue]) -> URL {
        var urlComponents: URLComponents = URLComponents(url: self, resolvingAgainstBaseURL: false)!
        let queryItems: [URLQueryItem] = parameters.map({ return URLQueryItem(name: $0.key, value: $0.value) })
        
        urlComponents.queryItems = queryItems
        return urlComponents.url!
    }
}
