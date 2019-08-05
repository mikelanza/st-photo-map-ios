//
//  STPhotoMapLocalization.swift
//  STPhotoMap-iOS
//
//  Created by Dimitri Strauneanu on 17/04/2019.
//  Copyright © 2019 mikelanza. All rights reserved.
//

import Foundation
import STPhotoCore

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
        carouselEntityTitle = "STPhotoMap.carousel.entity.title",
        
        locationAccessDeniedMessage = "STPhotoMap.location.access.denied.message",
        locationAccessDeniedSettings = "STPhotoMap.location.access.denied.settings",
        locationAccessDeniedCancel = "STPhotoMap.location.access.denied.cancel"
    }
    
    let noDataAvailableTitle = LocalizedKey.noDataAvailable.localized(in: Bundle.module)
    let noInternetConnectionTitle = LocalizedKey.noInternetConnection.localized(in: Bundle.module)
    
    let dataSourcesTitle = LocalizedKey.dataSources.localized(in: Bundle.module)
    
    let locationLevelTitle = LocalizedKey.locationLevel.localized(in: Bundle.module)
    let blockLevelTitle = LocalizedKey.blockLevel.localized(in: Bundle.module)
    let neighborhoodLevelTitle = LocalizedKey.neighborhoodLevel.localized(in: Bundle.module)
    let cityLevelTitle = LocalizedKey.cityLevel.localized(in: Bundle.module)
    let countyLevelTitle = LocalizedKey.countyLevel.localized(in: Bundle.module)
    let stateLevelTitle = LocalizedKey.stateLevel.localized(in: Bundle.module)
    let countryLevelTitle = LocalizedKey.countryLevel.localized(in: Bundle.module)
    
    let photoDetailsTutorial = LocalizedKey.photoDetailsTutorial.localized(in: Bundle.module)
    
    let locationAccessDeniedMessage = LocalizedKey.locationAccessDeniedMessage.localized(in: Bundle.module)
    let locationAccessDeniedSettings = LocalizedKey.locationAccessDeniedSettings.localized(in: Bundle.module)
    let locationAccessDeniedCancel = LocalizedKey.locationAccessDeniedCancel.localized(in: Bundle.module)
    
    func photoCountTitle(_ count: Int) -> String {
        return String.localizedStringWithFormat(LocalizedKey.photoCount.localized(in: Bundle.module), count)
    }
    
    func entitySelectionTutorial(entityLevel: String) -> String {
        return String.localizedStringWithFormat(LocalizedKey.entitySelectionTutorial.localized(in: Bundle.module), entityLevel)
    }
    
    func carouselBlockEntityTitle(photoCountTitle: String) -> String {
        return String(format: LocalizedKey.carouselBlockEntityTitle.localized(in: Bundle.module), photoCountTitle)
    }
    
    func carouselEntityTitle(photoCountTitle: String, entityName: String) -> String {
        return String(format: LocalizedKey.carouselEntityTitle.localized(in: Bundle.module), photoCountTitle, entityName)
    }
}
