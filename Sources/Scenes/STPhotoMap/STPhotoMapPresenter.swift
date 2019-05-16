//
//  STPhotoMapPresenter.swift
//  STPhotoMap
//
//  Created by Crasneanu Cristian on 12/04/2019.
//  Copyright (c) 2019 mikelanza. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol STPhotoMapPresentationLogic {
    func presentLoadingState()
    func presentNotLoadingState()
    
    func presentEntityLevel(response: STPhotoMapModels.EntityZoomLevel.Response)
}

class STPhotoMapPresenter: STPhotoMapPresentationLogic {
    weak var displayer: STPhotoMapDisplayLogic?
    
    func presentLoadingState() {
        self.displayer?.displayLoadingState()
    }
    
    func presentNotLoadingState() {
        self.displayer?.displayNotLoadingState()
    }
    
    func presentEntityLevel(response: STPhotoMapModels.EntityZoomLevel.Response) {
        let title: String = self.titleForEntityLevel(entityLevel: response.entityLevel)
        let image: UIImage? = self.imageForEntityLevel(entityLevel: response.entityLevel)
        let viewModel = STPhotoMapModels.EntityZoomLevel.ViewModel(title: title, image: image)
        self.displayer?.displayEntityLevel(viewModel: viewModel)
    }
    
    private func titleForEntityLevel(entityLevel: EntityLevel) -> String {
        switch entityLevel {
        case .location: return STPhotoMapStyle.shared.entityLevelViewModel.locationTitle
        case .block: return STPhotoMapStyle.shared.entityLevelViewModel.blockTitle
        case .neighborhood: return STPhotoMapStyle.shared.entityLevelViewModel.neighborhoodTitle
        case .city: return STPhotoMapStyle.shared.entityLevelViewModel.cityTitle
        case .county: return STPhotoMapStyle.shared.entityLevelViewModel.countyTitle
        case .state: return STPhotoMapStyle.shared.entityLevelViewModel.stateTitle
        case .country: return STPhotoMapStyle.shared.entityLevelViewModel.countryTitle
        case .unknown: return ""
        }
    }
    
    private func imageForEntityLevel(entityLevel: EntityLevel) -> UIImage? {
        switch entityLevel {
        case .location: return STPhotoMapStyle.shared.entityLevelViewModel.locationImage
        case .block: return STPhotoMapStyle.shared.entityLevelViewModel.blockImage
        case .neighborhood: return STPhotoMapStyle.shared.entityLevelViewModel.neighborhoodImage
        case .city: return STPhotoMapStyle.shared.entityLevelViewModel.cityImage
        case .county: return STPhotoMapStyle.shared.entityLevelViewModel.countyImage
        case .state: return STPhotoMapStyle.shared.entityLevelViewModel.stateImage
        case .country: return STPhotoMapStyle.shared.entityLevelViewModel.countryImage
        case .unknown: return nil
        }
    }
}
