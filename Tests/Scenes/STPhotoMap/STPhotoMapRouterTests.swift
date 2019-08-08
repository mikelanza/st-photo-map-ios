//
//  STPhotoMapRouterTests.swift
//  STPhotoMapTests-iOS
//
//  Created by Dimitri Strauneanu on 08/08/2019.
//  Copyright © 2019 mikelanza. All rights reserved.
//

@testable import STPhotoMap
import XCTest

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
        self.sut.navigateToPhotoDetails(photoId: "photoId")
        XCTAssertTrue(viewControllerSpy.pushViewControllerCalled)
    }
    
    func testNavigateToPhotoDetailsWhenViewControllerIsNotNavigationController() {
        let viewControllerSpy = UIViewControllerSpy()
        self.sut.viewController = viewControllerSpy
        self.sut.navigateToPhotoDetails(photoId: "photoId")
        XCTAssertTrue(viewControllerSpy.presentCalled)
    }
}
