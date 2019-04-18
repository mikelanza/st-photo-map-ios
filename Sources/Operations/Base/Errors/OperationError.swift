//
//  OperationError.swift
//  STPhotoMap-iOS
//
//  Created by Dimitri Strauneanu on 04/09/2018.
//  Copyright © 2018 mikelanza. All rights reserved.
//

import Foundation

public enum OperationError: LocalizedError {
    case noUrlAvailable
    case noDataAvailable
    case cannotParseResponse
    case noInternetConnection
    case operationCancelled
    
    case error(message: String)
    
    var errorDescription: String {
        switch self {
            case .noUrlAvailable: return "No url available."
            case .noDataAvailable: return "No data available."
            case .cannotParseResponse: return "Cannot parse response."
            case .noInternetConnection: return "No internet connection."
            case .operationCancelled: return ""
            case .error(let message): return message
        }
    }
}
