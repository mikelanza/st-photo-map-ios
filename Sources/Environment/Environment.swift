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
    
    private static let infoDictionary: [String: Any]? = {
        guard let dictionary = Bundle.main.infoDictionary else {
            return nil
        }
        return dictionary
    }()
    
    private static func urlStringFor(_ key: String) -> String? {
        guard let urlString = Environment.infoDictionary?[key] as? String else {
            return nil
        }
        return urlString
    }
    
    public static let getPhotoURL: String = {
        return Environment.urlStringFor(Keys.getPhotoURL) ?? "https://prod.streetography.com/v1/photos/%@"
    }()
    
    public static let bboxmongoURL: String = {
        return Environment.urlStringFor(Keys.bboxmongoURL) ?? "https://tiles.streetography.com/bboxmongo"
    }()
    
    public static let tilesGeojsonURL: String = {
        return Environment.urlStringFor(Keys.tilesGeojsonURL) ?? "https://tiles.streetography.com/tile/%d/%d/%d.geojson"
    }()
    
    public static let tilesJpegURL: String = {
        return Environment.urlStringFor(Keys.tilesJpegURL) ?? "https://tiles.streetography.com/tile/%d/%d/%d.jpeg"
    }()
}
