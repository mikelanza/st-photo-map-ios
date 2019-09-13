//
//  STPhotoMapCarouselHandlerSpy.swift
//  STPhotoMapTests-iOS
//
//  Created by Dimitri Strauneanu on 13/09/2019.
//  Copyright © 2019 mikelanza. All rights reserved.
//

@testable import STPhotoMap

class STPhotoMapCarouselHandlerSpy: STPhotoMapCarouselHandler {
    var addActiveDownloadCalled: Bool = false
    var removeActiveDownloadCalled: Bool = false
    var removeAllActiveDownloadsCalled: Bool = false
    
    override func addActiveDownload(_ url: String) {
        self.addActiveDownloadCalled = true
    }
    
    override func removeActiveDownload(_ url: String) {
        self.removeActiveDownloadCalled = true
    }
    
    override func removeAllActiveDownloads() {
        self.removeAllActiveDownloadsCalled = true
    }
}
