//
//  STPhotoTileOverlayRendererSpy.swift
//  STPhotoMap-iOS
//
//  Created by Crasneanu Cristian on 07/06/2019.
//  Copyright © 2019 Streetography. All rights reserved.
//

@testable import STPhotoMap
import MapKit
import STPhotoCore

class STPhotoTileOverlayRendererSpy: STPhotoTileOverlayRenderer {
    var predownloadCalled: Bool = false
    
    override func predownload(outer tiles: [(MKMapRect, [TileCoordinate])]) {
        self.predownloadCalled = true
    }
}

