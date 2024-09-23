//
//  ImageFeedUITests.swift
//  ImageFeedUITests
//
//  Created by Aleksandr Dugaev on 23.09.2024.
//

import XCTest

final class ImageFeedUITests: XCTestCase {
    private let app = XCUIApplication()
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        
        app.launch()
    }
    
    func testAuth() throws {
        XCTAssertTrue(app.buttons["Authenticate"].waitForExistence(timeout: 5))
        app.buttons["Authenticate"].tap()
        
        let webView = app.webViews["UnsplashWebView"]
        XCTAssertTrue(webView.waitForExistence(timeout: 5))
        
        let loginTextFiled = webView.descendants(matching: .textField).element
        XCTAssertTrue(loginTextFiled.waitForExistence(timeout: 5))
        
        loginTextFiled.tap()
        loginTextFiled.typeText("aleksandrdugaev@gmail.com")
        webView.swipeUp()
        
        let passwordTextfield = webView.descendants(matching: .secureTextField).element
        XCTAssertTrue(passwordTextfield.waitForExistence(timeout: 5))
        
        passwordTextfield.tap()
        passwordTextfield.typeText("Swwsfse24523")
        webView.swipeUp()
        
        webView.buttons["Login"].tap()
        
        let tablesQuery = app.tables
        let cell = tablesQuery.children(matching: .cell).element(boundBy: 0)
        
        XCTAssertTrue(cell.waitForExistence(timeout: 5))
    }
    
    func testFeed() throws {
        
    }
    
    func testProfile() throws {
        
    }

    
}
