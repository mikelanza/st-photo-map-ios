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
        self.entityLevelViewModel = EntityLevelViewModel(bundle: Bundle(for: type(of: self)))
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
        public var bundle: Bundle
        
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
        
        public var locationImage: UIImage?
        public var blockImage: UIImage?
        public var neighborhoodImage: UIImage?
        public var cityImage: UIImage?
        public var countyImage: UIImage?
        public var stateImage: UIImage?
        public var countryImage: UIImage?
        
        init(bundle: Bundle) {
            self.bundle = bundle
            
            self.locationImage = UIImage(named: "st_entity_location_level", in: bundle, compatibleWith: nil)
            self.blockImage = UIImage(named: "st_entity_block_level", in: bundle, compatibleWith: nil)
            self.neighborhoodImage = UIImage(named: "st_entity_neighborhood_level", in: bundle, compatibleWith: nil)
            self.cityImage = UIImage(named: "st_entity_city_level", in: bundle, compatibleWith: nil)
            self.countyImage = UIImage(named: "st_entity_county_level", in: bundle, compatibleWith: nil)
            self.stateImage = UIImage(named: "st_entity_state_level", in: bundle, compatibleWith: nil)
            self.countryImage = UIImage(named: "st_entity_country_level", in: bundle, compatibleWith: nil)
        }
    }
    
    public struct LocationOverlayViewModel {
        public var show: Bool = true
        public var backgroundColor: UIColor = UIColor.white
        public var borderWidth: CGFloat = 5.0
        public var borderColor: CGColor = UIColor(red: 73/255, green: 175/255, blue: 253/255, alpha: 1.0).cgColor
        public var cornerRadius: CGFloat = 10.0
        public var titleColor: UIColor = UIColor(red: 53/255, green: 61/255, blue: 75/255, alpha: 1)
        public var titleFont: UIFont = UIFont.systemFont(ofSize: 16.0, weight: UIFont.Weight.semibold)
        public var timeColor: UIColor = UIColor.darkGray
        public var timeFont: UIFont = UIFont.systemFont(ofSize: 13.0)
        public var descriptionColor: UIColor = UIColor.darkGray
        public var descriptionFont: UIFont = UIFont.systemFont(ofSize: 13.0)
    }
    
    public struct UserLocationButtonModel {
        public var show: Bool = true
        public var image: UIImage?
    }
}
