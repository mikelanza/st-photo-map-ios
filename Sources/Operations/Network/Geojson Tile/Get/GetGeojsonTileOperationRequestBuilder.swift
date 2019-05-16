//
//  GetGeojsonTileOperationRequestBuilder.swift
//  STPhotoMap-iOS
//
//  Created by Dimitri Strauneanu on 11/07/2018.
//  Copyright © 2018 mikelanza. All rights reserved.
//

import Foundation

class GetGeojsonTileOperationRequestBuilder {
 
    private let model: GetGeojsonTileOperationModel.Request
    
    init(model: GetGeojsonTileOperationModel.Request) {
        self.model = model
    }
    
    public func request() -> URLRequest? {
        guard let url = URL(string: model.url) else {
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
