//
//  EntityLevel+CoordinateSpan.swift
//  STPhotoMap-iOS
//
//  Created by Dimitri Strauneanu on 06/06/2019.
//  Copyright © 2019 mikelanza. All rights reserved.
//

import MapKit

extension EntityLevel {
    func coordinateSpan() -> MKCoordinateSpan {
        switch self {
            case .location: return MKCoordinateSpan(latitudeDelta: 0.0005, longitudeDelta: 0.0005)
            case .block: return MKCoordinateSpan(latitudeDelta: 0.008, longitudeDelta: 0.008)
            case .neighborhood: return MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
            case .city: return MKCoordinateSpan(latitudeDelta: 0.15, longitudeDelta: 0.15)
            case .county: return MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5)
            case .state: return MKCoordinateSpan(latitudeDelta: 10, longitudeDelta: 10)
            case .country: return MKCoordinateSpan(latitudeDelta: 30, longitudeDelta: 30)
            case .unknown: return MKCoordinateSpan(latitudeDelta: 0, longitudeDelta: 0)
        }
    }
}
