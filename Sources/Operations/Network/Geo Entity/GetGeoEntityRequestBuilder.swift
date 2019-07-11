//
//  GetGeoEntityRequestBuilder.swift
//  STPhotoMap-iOS
//
//  Created by Crasneanu Cristian on 23/01/2019.
//  Copyright © 2019 mikelanza. All rights reserved.
//

import Foundation

enum GetGeoEntityRequestBuilderError: LocalizedError {
    case invalidUrl(url: String)
}

class GetGeoEntityRequestBuilder {
    let urlString = Environment.bboxmongoURL
    var parameters: [String: Any]?
    let httpMethod: String
    
    private let model: GetGeoEntityOperationModel.Request
    
    init(model: GetGeoEntityOperationModel.Request) {
        self.model = model
        self.httpMethod = "GET"
        self.setupParameters()
    }
    
    func request() throws -> URLRequest {
        var urlComponents = URLComponents(string: self.urlString)
        urlComponents?.queryItems = self.parameters?.map({ URLQueryItem(name: $0.key, value: "\($0.value)") })
        
        guard let url = urlComponents?.url else {
            throw GetGeoEntityRequestBuilderError.invalidUrl(url: self.urlString)
        }
        var request = URLRequest(url: url)
        request.httpMethod = self.httpMethod
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        return request
    }

    private func setupParameters() {
        self.parameters = [:]
        parameters?[Parameters.APIKey] = "k9f2Hje7DM03Jyhf73hJ"
        parameters?[Parameters.EntityId] = model.entityId
        parameters?[Parameters.EntityLevel] = model.entity.rawValue
        parameters?[Parameters.Page] = model.page
        parameters?[Parameters.Limit] = model.limit
        parameters?[Parameters.UserId] = model.userId
        parameters?[Parameters.CollectionId] = model.collectionId
    }
    
    private struct Parameters {
        static let
        APIKey = "apisecret",
        EntityLevel = "type",
        EntityId = "entityId",
        
        Page = "page",
        Limit = "pageLimit",
        
        UserId = "userId",
        CollectionId = "collectionId"
    }
    
}

