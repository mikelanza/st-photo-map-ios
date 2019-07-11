//
//  STPhotoMapParametersHandler.swift
//  STPhotoMap-iOS
//
//  Created by Crasneanu Cristian on 21/06/2019.
//  Copyright © 2019 mikelanza. All rights reserved.
//

import Foundation

class STPhotoMapParametersHandler {
    public static let shared = STPhotoMapParametersHandler()
    
    var parameters: [KeyValue] = []
    
    private init() {
        self.parameters = self.defaultParameters()
    }
    
    public func defaultParameters() -> [KeyValue] {
        return [
            (Parameters.Keys.basemap, "yes"),
            (Parameters.Keys.shadow, "yes"),
            (Parameters.Keys.sort, "popular"),
            (Parameters.Keys.tileSize, "256"),
            (Parameters.Keys.pinOptimize, "4"),
            (Parameters.Keys.client, "iOS"),
            (Parameters.Keys.sessionId, UUID().uuidString)
        ]
    }
    
    func update(parameter: KeyValue) {
        self.parameters.removeAll(where: { $0.key == parameter.key })
        self.parameters.append(parameter)
    }
    
    func remove(parameter: KeyValue) {
        self.parameters.removeAll(where: { $0.key == parameter.key })
    }
    
    func reset() {
        self.parameters = self.defaultParameters()
    }
    
    func userId() -> String? {
        return self.parameters.first(where: { $0.key == Parameters.Keys.userId })?.value
    }
    
    func collectionId() -> String? {
        return self.parameters.first(where: { $0.key == Parameters.Keys.collectionId })?.value
    }
}
