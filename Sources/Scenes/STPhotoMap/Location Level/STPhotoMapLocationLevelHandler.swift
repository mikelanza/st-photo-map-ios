//
//  STPhotoMapLocationLevelHandler.swift
//  STPhotoMap-iOS
//
//  Created by Crasneanu Cristian on 17/05/2019.
//  Copyright © 2019 mikelanza. All rights reserved.
//

import Foundation
import STPhotoCore

class STPhotoMapLocationLevelHandler {
    var activeDownloads: SynchronizedArray<String>
    
    init() {
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
}


