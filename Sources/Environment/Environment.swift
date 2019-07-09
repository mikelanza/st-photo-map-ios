//
//  Environment.swift
//  STPhotoMap-iOS
//
//  Created by Dimitri Strauneanu on 09/07/2019.
//  Copyright © 2019 mikelanza. All rights reserved.
//

import Foundation

public enum Environment {
    private enum Keys {
        static let getPhotoURL = "GET_PHOTO_URL"
        static let bboxmongoURL = "BBOXMONGO_URL"
        static let tilesGeojsonURL = "TILES_GEOJSON_URL"
        static let tilesJpegURL = "TILES_JPEG_URL"
    }
    
    private static let infoDictionary: [String: Any] = {
        guard let dictionary = Bundle.module.infoDictionary else {
            fatalError("Info.plist file not found.")
        }
        return dictionary
    }()
    
    private static func urlStringFor(_ key: String) -> String {
        guard let urlString = Environment.infoDictionary[key] as? String else {
            fatalError("\(key) is not set in plist for this environment.")
        }
        return urlString
    }
    
    public static let getPhotoURL: String = {
        return Environment.urlStringFor(Keys.getPhotoURL)
    }()
    
    public static let bboxmongoURL: String = {
        return Environment.urlStringFor(Keys.bboxmongoURL)
    }()
    
    public static let tilesGeojsonURL: String = {
        return Environment.urlStringFor(Keys.tilesGeojsonURL)
    }()
    
    public static let tilesJpegURL: String = {
        return Environment.urlStringFor(Keys.tilesJpegURL)
    }()
}
