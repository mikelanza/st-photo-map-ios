//
//  GetPhotoOperationRequestBuilder.swift
//  STPhotoMap-iOS
//
//  Created by Dimitri Strauneanu on 20/05/2019.
//  Copyright © 2019 mikelanza. All rights reserved.
//

import Foundation

class GetPhotoOperationRequestBuilder {
    private let model: GetPhotoOperationModel.Request
    
    init(model: GetPhotoOperationModel.Request) {
        self.model = model
    }
    
    public func request() -> URLRequest? {
        let urlString = String(format: Environment.getPhotoURL, self.model.photoId)
        guard var urlComponents = URLComponents(string: urlString) else {
            return nil
        }
        urlComponents.queryItems = [
            URLQueryItem(name: "apisecret", value: "k9f2Hje7DM03Jyhf73hJ"),
            URLQueryItem(name: "includeOwner", value: String(self.model.includeUser))
        ]
        guard let url = urlComponents.url else {
            return nil
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.cachePolicy = .reloadIgnoringLocalCacheData
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        return request
    }
}
