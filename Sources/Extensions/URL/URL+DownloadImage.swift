//
//  URL+DownloadImage.swift
//  STPhotoMap-iOS
//
//  Created by Dimitri Strauneanu on 16/05/2019.
//  Copyright © 2019 mikelanza. All rights reserved.
//

import Foundation
import Kingfisher

extension URL {
    func downloadImage(downloadPriority: Float = 1.0, result: @escaping (Data?, Error?) -> Void) {
        DispatchQueue.global().async {
            let downloadPriority = KingfisherOptionsInfoItem.downloadPriority(downloadPriority)
            let options = KingfisherOptionsInfo(arrayLiteral: downloadPriority)
            
            KingfisherManager.shared.retrieveImage(with: self, options: options, progressBlock: nil, completionHandler: { imageResult in
                switch imageResult {
                case .success(let value): result(value.image.jpegData(compressionQuality: 1.0), nil); break
                case .failure(let error): result(nil, error); break
                }
            })
        }
    }
}
