//
//  DownloadImageOperation.swift
//  STPhotoMap-iOS
//
//  Created by Crasneanu Cristian on 06/02/2019.
//  Copyright © 2019 Streetography. All rights reserved.
//

import UIKit
import Kingfisher
import STPhotoCore

class DownloadImageOperation: AsynchronousOperation {
    private let model: DownloadImageOperationModel.Request
    private var operationCompletionHandler: ((Result<DownloadImageOperationModel.Response, OperationError>) -> Void)?
    
    init(model: DownloadImageOperationModel.Request, completionHandler: ((Result<DownloadImageOperationModel.Response, OperationError>) -> Void)? = nil) {
        self.model = model
        self.operationCompletionHandler = completionHandler
        super.init()
    }
    
    override func main() {
        guard let urlString = model.url, let url = URL(string: urlString) else {
            self.noUrlAvailableErrorBlock()
            return
        }

        KingfisherManager.shared.retrieveImage(with: url, options: [.downloadPriority(self.model.priority)], progressBlock: nil, completionHandler: { imageResult in
            switch imageResult {
                case .success(let value): self.successBlock(data: value.image.jpegData(compressionQuality: 1.0), image: value.image, error: nil); break
                case .failure(let error): self.responseErrorBlock(error: error); break
            }
        })
    }
    
    override func completeOperation() {
        self.cleanOperation()
        super.completeOperation()
    }
    
    override func cancel() {
        super.cancel()
    }
    
    // MARK: - Success
    
    private func successBlock(data: Data?, image: UIImage, error: Error?) {
        let value = DownloadImageOperationModel.Response(data: data, image: image, error: error)
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

