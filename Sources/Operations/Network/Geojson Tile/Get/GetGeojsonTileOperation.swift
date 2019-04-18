//
//  GetGeojsonTileOperation.swift
//  STPhotoMap-iOS
//
//  Created by Dimitri Strauneanu on 11/07/2018.
//  Copyright © 2018 mikelanza. All rights reserved.
//

import Foundation

class GetGeojsonTileOperation: AsynchronousOperation {
    private let model: GetGeojsonTileOperationModel.Request
    private var operationCompletionHandler: ((Result<GetGeojsonTileOperationModel.Response, OperationError>) -> Void)?
    
    private var task: URLSessionDataTask?
    
    init(model: GetGeojsonTileOperationModel.Request, completionHandler: ((Result<GetGeojsonTileOperationModel.Response, OperationError>) -> Void)? = nil) {
        self.model = model
        self.operationCompletionHandler = completionHandler
        super.init()
    }
    
    override func main() {
        guard let request = GetGeojsonTileOperationRequestBuilder(model: self.model).request() else {
            self.noUrlAvailableErrorBlock()
            return
        }
        
        self.task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let data = data {
                do {
                    if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                        if self.shouldCancelOperation() {
                            return
                        }
                        if let geoJSONObject = GeoJSON.init().parse(geoJSON: json) {
                            if self.shouldCancelOperation() {
                                return
                            }
                            self.successBlock(geoJSONObject: geoJSONObject)
                        } else {
                            self.cannotParseResponseErrorBlock()
                        }
                    }
                } catch let error {
                    print("Parsing error: \(error)")
                    self.cannotParseResponseErrorBlock()
                }
            } else {
                self.noDataAvailableErrorBlock()
            }
        }
        self.task?.resume()
    }
    
    override func completeOperation() {
        self.cleanOperation()
        super.completeOperation()
    }
    
    override func cancel() {
        self.task?.cancel()
        super.cancel()
    }
    
    private func shouldCancelOperation() -> Bool {
        if self.isCancelled {
            self.operationCompletionHandler?(Result.failure(OperationError.operationCancelled))
            self.completeOperation()
            return true
        }
        return false
    }
    
    public func getTileCoordinate() -> TileCoordinate {
        return self.model.tileCoordinate
    }
    
    // MARK: - Success
    
    private func successBlock(geoJSONObject: GeoJSONObject) {
        let value = GetGeojsonTileOperationModel.Response(geoJSONObject: geoJSONObject)
        self.operationCompletionHandler?(Result.success(value))
        self.completeOperation()
    }
    
    // MARK: - Operation errors
    
    private func noUrlAvailableErrorBlock() {
        self.operationCompletionHandler?(Result.failure(OperationError.noUrlAvailable))
        self.completeOperation()
    }
    
    private func noDataAvailableErrorBlock() {
        self.operationCompletionHandler?(Result.failure(OperationError.noDataAvailable))
        self.completeOperation()
    }
    
    private func cannotParseResponseErrorBlock() {
        self.operationCompletionHandler?(Result.failure(OperationError.cannotParseResponse))
        self.completeOperation()
    }
    
    // MARK: - Server errors
    
    private func responseErrorBlock(error: Error) {
        self.operationCompletionHandler?(Result.failure(OperationError.error(message: error.localizedDescription)))
        self.completeOperation()
    }
    
    private func cleanOperation() {
        self.operationCompletionHandler = nil
    }
}
