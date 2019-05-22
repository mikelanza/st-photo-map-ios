//
//  STPhotoMapLocalization.swift
//  STPhotoMap-iOS
//
//  Created by Dimitri Strauneanu on 17/04/2019.
//  Copyright © 2019 mikelanza. All rights reserved.
//

import Foundation

class STPhotoMapLocalization {
    static let shared = STPhotoMapLocalization()
    
    private init() {
        
    }
    
    struct LocalizedKey {
        static let
        noDataAvailable = "PhotoMap.no.data.available.title",
        noInternetConnection = "PhotoMap.no.internet.connection.title",
        
        dataSources = "PhotoMap.data.sources.title",
        
        locationLevel = "PhotoMap.location.level.title",
        blockLevel = "PhotoMap.block.level.title",
        neighborhoodLevel = "PhotoMap.neighborhood.level.title",
        cityLevel = "PhotoMap.city.level.title",
        countyLevel = "PhotoMap.county.level.title",
        stateLevel = "PhotoMap.state.level.title",
        countryLevel = "PhotoMap.country.level.title"
    }
    
    let noDataAvailableTitle = LocalizedKey.noDataAvailable.localized()
    let noInternetConnectionTitle = LocalizedKey.noInternetConnection.localized()
    
    let dataSourcesTitle = LocalizedKey.dataSources.localized()
    
    let locationLevelTitle = LocalizedKey.locationLevel.localized()
    let blockLevelTitle = LocalizedKey.blockLevel.localized()
    let neighborhoodLevelTitle = LocalizedKey.neighborhoodLevel.localized()
    let cityLevelTitle = LocalizedKey.cityLevel.localized()
    let countyLevelTitle = LocalizedKey.countyLevel.localized()
    let stateLevelTitle = LocalizedKey.stateLevel.localized()
    let countryLevelTitle = LocalizedKey.countryLevel.localized()
}
