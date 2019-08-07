//
//  STPhotoMapEntityLevelHandler.swift
//  STPhotoMap-iOS
//
//  Created by Crasneanu Cristian on 13/05/2019.
//  Copyright © 2019 mikelanza. All rights reserved.
//

import Foundation
import STPhotoCore

protocol STPhotoMapEntityLevelHandlerDelegate: class {
    func photoMapEntityLevelHandler(newEntityLevel level: EntityLevel)
    func photoMapEntityLevelHandler(location level: EntityLevel)
}

class STPhotoMapEntityLevelHandler {
    var entityLevel: EntityLevel
    var activeDownloads: SynchronizedArray<String>
    weak var delegate: STPhotoMapEntityLevelHandlerDelegate?
    
    init() {
        self.entityLevel = EntityLevel.unknown
        self.activeDownloads = SynchronizedArray<String>()
    }
    
    func hasActiveDownload(_ url: String) -> Bool {
        return self.activeDownloads.contains(url)
    }
    
    func addActiveDownload(_ url: String) {
        self.activeDownloads.append(url)
    }
    
    func removeActiveDownload(_ url: String) {
        self.activeDownloads.remove(where: { $0 == url })
    }
    
    func removeAllActiveDownloads() {
        self.activeDownloads.removeAll()
    }
    
    func change(entityLevel: EntityLevel) {
        if entityLevel != .unknown && self.entityLevel != entityLevel {
            self.entityLevel = entityLevel

            switch self.entityLevel {
                case .location: self.delegate?.photoMapEntityLevelHandler(location: .location); break
                default: self.delegate?.photoMapEntityLevelHandler(newEntityLevel: self.entityLevel);
            }
            
        }
    }
}

