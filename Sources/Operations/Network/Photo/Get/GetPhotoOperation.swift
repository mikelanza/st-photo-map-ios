//
//  GetPhotoOperation.swift
//  STPhotoMap-iOS
//
//  Created by Dimitri Strauneanu on 20/05/2019.
//  Copyright © 2019 mikelanza. All rights reserved.
//

import Foundation

class GetPhotoOperation: AsynchronousOperation {
    private let model: GetPhotoOperationModel.Request
    private var operationCompletionHandler: ((Result<GetPhotoOperationModel.Response, OperationError>) -> Void)?
    
    private var task: URLSessionDataTask?
    
    init(model: GetPhotoOperationModel.Request, completionHandler: ((Result<GetPhotoOperationModel.Response, OperationError>) -> Void)? = nil) {
        self.model = model
        self.operationCompletionHandler = completionHandler
        super.init()
    }
    
    override func main() {
        guard let request = GetPhotoOperationRequestBuilder(model: self.model).request() else {
            self.noUrlAvailableErrorBlock()
            return
        }
        
        self.task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data else {
                self.noDataAvailableErrorBlock()
                return
            }
            do {
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .formatted(DateFormatter.iso8601)
                let response = try decoder.decode(GetPhotoOperationModel.Response.self, from: data)
                self.successBlock(response: response)
            } catch {
                self.cannotParseResponseErrorBlock()
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
    
    // MARK: - Success
    
    private func successBlock(response: GetPhotoOperationModel.Response) {
        self.operationCompletionHandler?(Result.success(response))
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
