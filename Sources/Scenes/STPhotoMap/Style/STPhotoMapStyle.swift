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
    public var noGeoDataViewModel: NoGeoDataViewModel
    
    public var entityLevelViewModel: EntityLevelViewModel
    
    public var userLocationButtonModel: UserLocationButtonModel
    
    private init() {
        self.progressViewModel = ProgressViewModel()
        self.noInternetConnectionViewModel = NoInternetConnectionViewModel()
        self.noGeoDataViewModel = NoGeoDataViewModel()
        self.entityLevelViewModel = EntityLevelViewModel()
        self.userLocationButtonModel = UserLocationButtonModel()
    }
    
    public struct ProgressViewModel {
        public var show: Bool = true
        public var tintColor: UIColor = UIColor.blue
    }
    
    public struct NoInternetConnectionViewModel {
        public var show: Bool = true
        public var titleColor: UIColor = UIColor.white
        public var backgroundColor: UIColor = UIColor.red.withAlphaComponent(0.95)
        public var title: String = ""
    }
    
    public struct NoGeoDataViewModel {
        public var show: Bool = true
        public var titleColor: UIColor = UIColor.white
        public var backgroundColor: UIColor = UIColor.black.withAlphaComponent(0.95)
        public var title: String = ""
    }
    
    public struct EntityLevelViewModel {
        public var show: Bool = true
        public var showDurationInMilliseconds: Int = 1500
        
        public var titleColor: UIColor = UIColor.white
        public var titleFont: UIFont?
        public var backgroundColor: UIColor = UIColor(red: 65/255, green: 171/255, blue: 255/255, alpha: 0.95)
        
        public var locationTitle: String = ""
        public var blockTitle: String = ""
        public var neighborhoodTitle: String = ""
        public var cityTitle: String = ""
        public var countyTitle: String = ""
        public var stateTitle: String = ""
        public var countryTitle: String = ""
        
        public var locationImage: UIImage?
        public var blockImage: UIImage?
        public var neighborhoodImage: UIImage?
        public var cityImage: UIImage?
        public var countyImage: UIImage?
        public var stateImage: UIImage?
        public var countryImage: UIImage?
    }
    
    public struct UserLocationButtonModel {
        public var show: Bool = true
        public var image: UIImage?
    }
}
