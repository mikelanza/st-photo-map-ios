//
//  DefaultReuseIdentifier.swift
//  STPhotoMap-iOS
//
//  Created by Dimitri Strauneanu on 16/05/2019.
//  Copyright © 2019 mikelanza. All rights reserved.
//

import Foundation

protocol DefaultReuseIdentifier: class {
    static var defaultReuseIdentifier: String { get }
}

extension DefaultReuseIdentifier {
    static var defaultReuseIdentifier: String {
        get {
            return String(describing: self)
        }
    }
}
