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
        urlComponents.queryItems = parameters.map({ return URLQueryItem(name: $0.key, value: $0.value) })
        return urlComponents.url!
    }
        
    func excludeParameter(_ parameter: KeyValue) -> URL {
        var urlComponents: URLComponents = URLComponents(url: self, resolvingAgainstBaseURL: false)!
        urlComponents.queryItems = urlComponents.queryItems?.filter({ $0.name != parameter.key })
        return urlComponents.url!
    }
}
