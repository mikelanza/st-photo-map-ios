//
//  STPhotoMapStyle.swift
//  STPhotoMap-iOS
//
//  Created by Dimitri Strauneanu on 17/04/2019.
//  Copyright © 2019 mikelanza. All rights reserved.
//

import UIKit

public class STPhotoMapStyle {
    public static let shared = STPhotoMapStyle()
    
    public var progressViewModel: ProgressViewModel
    public var noInternetConnectionViewModel: NoInternetConnectionViewModel
    public var noDataViewModel: NoDataViewModel
    
    public var entityLevelViewModel: EntityLevelViewModel
    public var locationOverlayViewModel: LocationOverlayViewModel
    
    public var userLocationButtonModel: UserLocationButtonModel
    
    private init() {
        self.progressViewModel = ProgressViewModel()
        self.noInternetConnectionViewModel = NoInternetConnectionViewModel()
        self.noDataViewModel = NoDataViewModel()
        self.entityLevelViewModel = EntityLevelViewModel()
        self.locationOverlayViewModel = LocationOverlayViewModel()
        self.userLocationButtonModel = UserLocationButtonModel()
    }
    
    public struct ProgressViewModel {
        public var show: Bool = true
        public var tintColor: UIColor = UIColor(red: 65/255, green: 171/255, blue: 255/255, alpha: 1.0)
    }
    
    public struct NoInternetConnectionViewModel {
        public var show: Bool = true
        public var titleColor: UIColor = UIColor.white
        public var backgroundColor: UIColor = UIColor.red.withAlphaComponent(0.95)
        public var title: String = STPhotoMapLocalization.shared.noInternetConnectionTitle
    }
    
    public struct NoDataViewModel {
        public var show: Bool = true
        public var titleColor: UIColor = UIColor.white
        public var backgroundColor: UIColor = UIColor.black.withAlphaComponent(0.95)
        public var title: String = STPhotoMapLocalization.shared.noDataAvailableTitle
    }
    
    public struct EntityLevelViewModel {
        public var show: Bool = true
        public var showDuration: Int = 1500 // Milliseconds
        
        public var titleColor: UIColor = UIColor.white
        public var titleFont: UIFont = UIFont.systemFont(ofSize: 17.0, weight: UIFont.Weight.medium)
        public var backgroundColor: UIColor = UIColor(red: 65/255, green: 171/255, blue: 255/255, alpha: 0.95)
        public var cornerRadius: CGFloat = 8.0
        public var shadowColor: CGColor = UIColor(white: 0.0, alpha: 0.2).cgColor
        public var shadowRadius: CGFloat = 2.0
        
        public var locationTitle: String = STPhotoMapLocalization.shared.locationLevelTitle
        public var blockTitle: String = STPhotoMapLocalization.shared.blockLevelTitle
        public var neighborhoodTitle: String = STPhotoMapLocalization.shared.neighborhoodLevelTitle
        public var cityTitle: String = STPhotoMapLocalization.shared.cityLevelTitle
        public var countyTitle: String = STPhotoMapLocalization.shared.countyLevelTitle
        public var stateTitle: String = STPhotoMapLocalization.shared.stateLevelTitle
        public var countryTitle: String = STPhotoMapLocalization.shared.countryLevelTitle
        
        public var locationImage: UIImage? = UIImage(named: "st_entity_location_level")
        public var blockImage: UIImage? = UIImage(named: "st_entity_block_level")
        public var neighborhoodImage: UIImage? = UIImage(named: "st_entity_neighborhood_level")
        public var cityImage: UIImage? = UIImage(named: "st_entity_city_level")
        public var countyImage: UIImage? = UIImage(named: "st_entity_county_level")
        public var stateImage: UIImage? = UIImage(named: "st_entity_state_level")
        public var countryImage: UIImage? = UIImage(named: "st_entity_country_level")
    }
    
    public struct LocationOverlayViewModel {
        public var show: Bool = true
    }
    
    public struct UserLocationButtonModel {
        public var show: Bool = true
        public var image: UIImage?
    }
}
