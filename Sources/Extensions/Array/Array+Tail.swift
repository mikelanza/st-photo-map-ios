//
//  Array+Tail.swift
//  STPhotoMap-iOS
//
//  Created by Crasneanu Cristian on 17/04/2019.
//  Copyright © 2019 mikelanza. All rights reserved.
//

import Foundation

extension Array {
    var tail: Array? {
        let tail = Array(self.dropFirst())
        if tail.isEmpty { return nil }
        return tail
    }
}
