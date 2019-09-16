//
//  OperationQueueSpy.swift
//  STPhotoMapTests-iOS
//
//  Created by Dimitri Strauneanu on 15/06/2019.
//  Copyright © 2019 Streetography. All rights reserved.
//

@testable import STPhotoMap

class OperationQueueSpy: OperationQueue {
    var cancelAllOperationsCalled: Bool = false
    
    override func cancelAllOperations() {
        self.cancelAllOperationsCalled = true
    }
}
