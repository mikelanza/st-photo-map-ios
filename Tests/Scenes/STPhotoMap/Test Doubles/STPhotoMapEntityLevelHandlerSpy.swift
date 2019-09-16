//
//  STPhotoMapEntityLevelHandlerSpy.swift
//  STPhotoMapTests-iOS
//
//  Created by Dimitri Strauneanu on 12/09/2019.
//  Copyright © 2019 Streetography. All rights reserved.
//

@testable import STPhotoMap
import STPhotoCore

class STPhotoMapEntityLevelHandlerSpy: STPhotoMapEntityLevelHandler {
    var changeEntityLevelCalled: Bool = false
    var addActiveDownloadCalled: Bool = false
    var removeActiveDownloadCalled: Bool = false
    
    override func change(entityLevel: EntityLevel) {
        self.changeEntityLevelCalled = true
    }
    
    override func addActiveDownload(_ url: String) {
        self.addActiveDownloadCalled = true
    }
    
    override func removeActiveDownload(_ url: String) {
        self.removeActiveDownloadCalled = true
    }
}
