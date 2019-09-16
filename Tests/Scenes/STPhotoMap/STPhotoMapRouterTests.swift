//
//  STPhotoMapRouterTests.swift
//  STPhotoMapTests-iOS
//
//  Created by Dimitri Strauneanu on 08/08/2019.
//  Copyright © 2019 Streetography. All rights reserved.
//

@testable import STPhotoMap
import XCTest
import STPhotoCore

class STPhotoMapRouterTests: XCTestCase {
    var sut: STPhotoMapRouter!
    
    // MARK: - Test lifecycle
    
    override func setUp() {
        super.setUp()
        self.setupSTPhotoMapRouter()
    }
    
    private func waitForMainQueue() {
        let waitExpectation = expectation(description: "Waiting for main queue.")
        DispatchQueue.main.async {
            waitExpectation.fulfill()
        }
        waitForExpectations(timeout: 1.0)
    }
    
    // MARK: - Test setup
    
    func setupSTPhotoMapRouter() {
        self.sut = STPhotoMapRouter()
    }
    
    // MARK: - Tests
    
    func testNavigateToSafari() {
        let viewControllerSpy = UIViewControllerSpy()
        self.sut.viewController = viewControllerSpy
        self.sut.navigateToSafari(url: URL(string: "https://streetography.com")!)
        XCTAssertTrue(viewControllerSpy.presentCalled)
    }
    
    func testNavigateToLocationSettingsAlert() {
        let viewControllerSpy = UIViewControllerSpy()
        self.sut.viewController = viewControllerSpy
        self.sut.navigateToLocationSettingsAlert(controller: UIAlertController(title: "Title", message: "Message", preferredStyle: .alert))
        XCTAssertTrue(viewControllerSpy.presentCalled)
    }
    
    func testNavigateToPhotoDetailsWhenViewControllerIsNavigationController() {
        let viewControllerSpy = UINavigationControllerSpy(rootViewController: UIViewController())
        self.sut.viewController = viewControllerSpy
        self.sut.navigateToPhotoDetails(viewController: viewControllerSpy, photoId: "photoId")
        XCTAssertTrue(viewControllerSpy.pushViewControllerCalled)
    }
    
    func testNavigateToPhotoDetailsWhenViewControllerIsNotNavigationController() {
        let viewControllerSpy = UIViewControllerSpy()
        self.sut.viewController = viewControllerSpy
        self.sut.navigateToPhotoDetails(viewController: viewControllerSpy, photoId: "photoId")
        XCTAssertTrue(viewControllerSpy.presentCalled)
    }
    
    func testNavigateToPhotoCollectionWhenViewControllerIsNavigationController() {
        let viewControllerSpy = UINavigationControllerSpy(rootViewController: UIViewController())
        self.sut.viewController = viewControllerSpy
        self.sut.navigateToPhotoCollection(location: STLocation(latitude: 50.0, longitude: 50.0), entityLevel: EntityLevel(rawValue: "block")!, userId: nil, collectionId: nil)
        XCTAssertTrue(viewControllerSpy.pushViewControllerCalled)
    }

    func testNavigateToPhotoCollectionWhenViewControllerIsNotNavigationController() {
        let viewControllerSpy = UIViewControllerSpy()
        self.sut.viewController = viewControllerSpy
        self.sut.navigateToPhotoCollection(location: STLocation(latitude: 50.0, longitude: 50.0), entityLevel: EntityLevel(rawValue: "block")!, userId: nil, collectionId: nil)
        XCTAssertTrue(viewControllerSpy.presentCalled)
    }
}
