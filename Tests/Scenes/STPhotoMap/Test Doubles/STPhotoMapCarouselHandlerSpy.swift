//
//  STPhotoMapCarouselHandlerSpy.swift
//  STPhotoMapTests-iOS
//
//  Created by Dimitri Strauneanu on 13/09/2019.
//  Copyright © 2019 Streetography. All rights reserved.
//

@testable import STPhotoMap
import STPhotoCore

class STPhotoMapCarouselHandlerSpy: STPhotoMapCarouselHandler {
    var addActiveDownloadCalled: Bool = false
    var removeActiveDownloadCalled: Bool = false
    var removeAllActiveDownloadsCalled: Bool = false
    var resetCarouselCalled: Bool = false
    var addDownloadedCarouselPhotoCalled: Bool = false
    var updateCarouselForCalled: Bool = false
    
    override func addActiveDownload(_ url: String) {
        self.addActiveDownloadCalled = true
    }
    
    override func removeActiveDownload(_ url: String) {
        self.removeActiveDownloadCalled = true
    }
    
    override func removeAllActiveDownloads() {
        self.removeAllActiveDownloadsCalled = true
    }
    
    override func resetCarousel() {
        self.resetCarouselCalled = true
    }
    
    override func addDownloadedCarouselPhoto(_ photo: STCarousel.Photo) {
        self.addDownloadedCarouselPhotoCalled = true
    }
    
    override func updateCarouselFor(geoEntity: GeoEntity) {
        self.updateCarouselForCalled = true
    }
}
