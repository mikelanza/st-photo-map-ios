//
//  STPhotoMapPresenterTests.swift
//  STPhotoMap
//
//  Created by Dimitri Strauneanu on 12/04/2019.
//  Copyright (c) 2019 mikelanza. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

@testable import STPhotoMap
import XCTest

class STPhotoMapPresenterTests: XCTestCase {
    // MARK: Subject under test
    
    var sut: STPhotoMapPresenter!
    var displayerSpy: STPhotoMapDisplayLogicSpy!
    
    // MARK: Test lifecycle
    
    override func setUp() {
        super.setUp()
        self.setupSTPhotoMapPresenter()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    // MARK: Test setup
    
    func setupSTPhotoMapPresenter() {
        self.sut = STPhotoMapPresenter()
        
        self.displayerSpy = STPhotoMapDisplayLogicSpy()
        self.sut.displayer = self.displayerSpy
    }
    
    // MARK: Test doubles
    
    // MARK: Tests
    
    func testPresentLoadingState() {
        self.sut.presentLoadingState()
        XCTAssertTrue(self.displayerSpy.displayLoadingStateCalled)
    }
    
    func testPresentNotLoadingState() {
        self.sut.presentNotLoadingState()
        XCTAssertTrue(self.displayerSpy.displayNotLoadingStateCalled)
    }
    
    func testPresentEntityLevel() {
        let response = STPhotoMapModels.EntityZoomLevel.Response(photoProperties: PhotoProperties())
        self.sut.presentEntityLevel(response: response)
        
        XCTAssertTrue(self.displayerSpy.displayEntityLevelCalled)
    }
}
