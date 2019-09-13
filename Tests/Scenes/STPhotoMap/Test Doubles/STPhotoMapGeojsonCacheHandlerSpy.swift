//
//  STPhotoMapGeojsonCacheHandlerSpy.swift
//  STPhotoMapTests-iOS
//
//  Created by Dimitri Strauneanu on 12/09/2019.
//  Copyright © 2019 mikelanza. All rights reserved.
//

@testable import STPhotoMap

class STPhotoMapGeojsonCacheHandlerSpy: STPhotoMapGeojsonCacheHandler {
    var addActiveDownloadCalled: Bool = false
    var removeAllActiveDownloadsCalled: Bool = false
    
    override func addActiveDownload(_ url: String) {
        self.addActiveDownloadCalled = true
    }
    
    override func removeAllActiveDownloads() {
        self.removeAllActiveDownloadsCalled = true
    }
}
