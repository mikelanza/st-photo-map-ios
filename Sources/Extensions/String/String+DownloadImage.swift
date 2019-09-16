//
//  String+DownloadImage.swift
//  STPhotoMap-iOS
//
//  Created by Dimitri Strauneanu on 17/05/2019.
//  Copyright © 2019 Streetography. All rights reserved.
//

import UIKit
import Kingfisher

extension String {
    func downloadImage(result: @escaping (UIImage?, Error?) -> Void) {
        DispatchQueue.global().async {
            guard let url = URL(string: self) else {
                result(nil, nil)
                return
            }
            KingfisherManager.shared.retrieveImage(with: url, completionHandler: { imageResult in
                switch imageResult {
                    case .success(let value): result(value.image, nil); break
                    case .failure(let error): result(nil, error); break
                }
            })
        }
    }
}
