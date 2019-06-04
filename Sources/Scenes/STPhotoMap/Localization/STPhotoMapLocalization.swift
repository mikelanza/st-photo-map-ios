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
        noDataAvailable = "STPhotoMap.no.data.available.title",
        noInternetConnection = "STPhotoMap.no.internet.connection.title",
        
        dataSources = "STPhotoMap.data.sources.title",
        
        locationLevel = "STPhotoMap.location.level.title",
        blockLevel = "STPhotoMap.block.level.title",
        neighborhoodLevel = "STPhotoMap.neighborhood.level.title",
        cityLevel = "STPhotoMap.city.level.title",
        countyLevel = "STPhotoMap.county.level.title",
        stateLevel = "STPhotoMap.state.level.title",
        countryLevel = "STPhotoMap.country.level.title",
        
        photoCount = "STPhotoMap.photo.count",
        
        photoDetailsTutorial = "STPhotoMap.photo.details.tutorial",
        entitySelectionTutorial = "STPhotoMap.entity.selection.tutorial",
        
        carouselBlockEntityTitle = "STPhotoMap.carousel.block.entity.title",
        carouselEntityTitle = "STPhotoMap.carousel.entity.title"
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
    
    let photoDetailsTutorial = LocalizedKey.photoDetailsTutorial.localized()
    
    func photoCountTitle(_ count: Int) -> String {
        return String.localizedStringWithFormat(LocalizedKey.photoCount.localized(), count)
    }
    
    func entitySelectionTutorial(entityLevel: String) -> String {
        return String.localizedStringWithFormat(LocalizedKey.entitySelectionTutorial.localized(), entityLevel)
    }
    
    func carouselBlockEntityTitle(photoCountTitle: String) -> String {
        return String(format: LocalizedKey.carouselBlockEntityTitle.localized(), photoCountTitle)
    }
    
    func carouselEntityTitle(photoCountTitle: String, entityName: String) -> String {
        return String(format: LocalizedKey.carouselEntityTitle.localized(), photoCountTitle, entityName)
    }
}
