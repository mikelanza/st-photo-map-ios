//
//  STPhotoMapEntityLevelHandler.swift
//  STPhotoMap-iOS
//
//  Created by Crasneanu Cristian on 13/05/2019.
//  Copyright © 2019 mikelanza. All rights reserved.
//

import Foundation

protocol STPhotoMapEntityLevelHandlerDelegate {
    func photoMapEntityLevelHandler(newEntityLevel level: EntityLevel)
}

class STPhotoMapEntityLevelHandler {
    var entityLevel: EntityLevel
    var activeDownloads: SynchronizedArray<String>
    public var delegate: STPhotoMapEntityLevelHandlerDelegate?
    
    init() {
        self.entityLevel = EntityLevel.unknown
        self.activeDownloads = SynchronizedArray<String>()
    }
    
    public func change(entityLevel: EntityLevel) {
        if entityLevel != .unknown && self.entityLevel != entityLevel {
            self.entityLevel = entityLevel
            self.delegate?.photoMapEntityLevelHandler(newEntityLevel: self.entityLevel)
        }
    }
}

