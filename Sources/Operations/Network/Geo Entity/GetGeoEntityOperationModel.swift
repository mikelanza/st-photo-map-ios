//
//  GetEntityOperationModel.swift
//  STPhotoMap-iOS
//
//  Created by Crasneanu Cristian on 23/01/2019.
//  Copyright © 2019 mikelanza. All rights reserved.
//

import Foundation

enum GetGeoEntityOperationModel {
    struct Request {
        let entityId: Int
        var entity: EntityLevel
        var page: Int
        var limit: Int
    }
    
    struct Response {
        let geoEntity: GeoEntity
        
        init(geoEntity: GeoEntity) {
            self.geoEntity = geoEntity
        }
    }
    
    struct DecodedResponse: Codable {
        let result: [Entity]
    }
    
    struct Entity: Codable {
        var id: Int?
        
        var entity: String?
        var name: String?
        
        var nameLocal: String?
        
        var bbox: Bbox?
        
        var center: Center?
        var centroid: Center?
        
        var geom: String?
        var area: Double?
        
        var label: Label?
        var label2: Label?
        
        var page: String?
        var numberOfPhotos: String?
        var photos: [Photo]?
        
        enum CodingKeys: String, CodingKey {
            case id
            case entity
            case name
            case nameLocal = "name_local"
            case bbox
            case center
            case centroid
            case geom
            case area
            case label
            case label2
            case page
            case numberOfPhotos
            case photos
        }
        
        init(from decoder: Decoder) throws {
            let values = try decoder.container(keyedBy: CodingKeys.self)
            
            self.id = try values.decodeIfPresent(Int.self, forKey: .id)
            
            self.entity = try values.decodeIfPresent(String.self, forKey: .entity)
            self.name = try values.decodeIfPresent(String.self, forKey: .name)
            self.nameLocal = try values.decodeIfPresent(String.self, forKey: .nameLocal)
            
            self.bbox = try values.decodeIfPresent(Bbox.self, forKey: .bbox)
            self.center = try values.decodeIfPresent(Center.self, forKey: .center)
            self.centroid = try values.decodeIfPresent(Center.self, forKey: .centroid)
            
            self.geom = try values.decodeIfPresent(String.self, forKey: .geom)
            
            self.label = try values.decodeIfPresent(Label.self, forKey: .label)
            self.label2 = try values.decodeIfPresent(Label.self, forKey: .label2)
            
            self.page = try values.decodeIfPresent(String.self, forKey: .page)
            self.numberOfPhotos = try values.decodeIfPresent(String.self, forKey: .numberOfPhotos)
            self.photos = try values.decodeIfPresent([Photo].self, forKey: .photos)
        }
        
        func toGeoEntity() throws -> GeoEntity {
            guard let id = self.id else {
                throw NSError(domain: "No id available for geo entity.", code: 404, userInfo: nil)
            }
            guard let entity = self.entity, let entityLevel = EntityLevel.init(rawValue: entity) else {
                throw NSError(domain: "No entity level available for geo entity.", code: 404, userInfo: nil)
            }
            guard let boundingBox = self.bbox?.toBoundingBox() else {
                throw NSError(domain: "No bounding box available for geo entity.", code: 404, userInfo: nil)
            }
            
            var geoJSONObject: GeoJSONObject?
            if let geom = self.geom {
               geoJSONObject = try WKTReader().read(string: geom)
            }
            
            let numberOfPhotos: Int? = self.numberOfPhotos != nil ? Int( self.numberOfPhotos!) : 0
            
            let photos = self.photos?.compactMap({$0.toSTPhoto()}) ?? []
            let geoLabel = self.geoLabel(label: self.label)

            return GeoEntity(id: id, name: self.name, entityLevel: entityLevel, boundingBox: boundingBox, center: self.center?.toCoordinate(), geoJSONPolygons: [], area: self.area, geoJSONObject: geoJSONObject, numberOfPhotos: numberOfPhotos, photos: photos, label: geoLabel)
        }
        
        private func geoLabel(label: Label?) -> GeoLabel? {
            guard let latitude = label?.lat, let longitude = label?.lng, let radius = label?.radius else {
                return nil
            }
            return GeoLabel(latitude: latitude, longitude: longitude, radius: radius)
        }
    }
    
    struct Photo: Codable {
        var objectId: String?
        var imageUrl: String?
        var image1200Url: String?
        var image750Url: String?
        var image650Url: String?
        
        enum CodingKeys: String, CodingKey {
            case objectId
            case imageUrl = "imageOriginalURL"
            case image1200Url = "imageWidth1200URL"
            case image750Url = "imageWidth750URL"
            case image650Url = "imageWidth650URL"
        }
        
        func toSTPhoto() -> STPhoto? {
            guard let id = self.objectId else {
                return nil
            }
            var photo = STPhoto(id: id, createdAt: Date())
            photo.imageUrl = self.imageUrl
            photo.image1200Url = self.image1200Url
            photo.image750Url = self.image750Url
            photo.image650Url = self.image650Url
            return photo
        }
    }
    
    struct Bbox: Codable {
        var west: Double?
        var south: Double?
        var east: Double?
        var north: Double?
        var center: Center?
        
        func toBoundingBox() -> BoundingBox? {
            guard let north = north, let east = east,
                let south = south, let west = west else {
                    return nil
            }
            let boundingCoordinates = BoundingCoordinates(west, south, east, north)
            return BoundingBox(boundingCoordinates: boundingCoordinates)
        }
    }

    struct Center: Codable {
        var lat: Double?
        var lng: Double?
        
        func toCoordinate() -> Coordinate? {
            guard let latitude = lat, let longitude = lng else {
                    return nil
            }
            return Coordinate(longitude: longitude, latitude: latitude)
        }
    }

    struct Label: Codable {
        var lat: Double?
        var lng: Double?
        var radius: Double?
        var yscale: Double?
    }
}
