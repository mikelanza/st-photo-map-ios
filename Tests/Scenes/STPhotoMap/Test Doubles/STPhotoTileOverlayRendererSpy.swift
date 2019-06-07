//
//  STPhotoTileOverlayRendererSpy.swift
//  STPhotoMap-iOS
//
//  Created by Crasneanu Cristian on 07/06/2019.
//  Copyright © 2019 mikelanza. All rights reserved.
//

@testable import STPhotoMap
import MapKit

class STPhotoTileOverlayRendererSpy: STPhotoTileOverlayRenderer {
    var predownloadCalled: Bool = false
    
    override func predownload(model: STPhotoTileOverlay.Model?, outer tiles: [(MKMapRect, [TileCoordinate])]) {
        self.predownloadCalled = true
    }
}

