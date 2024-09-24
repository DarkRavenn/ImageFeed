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
        
        app.launchArguments = ["testMode"]
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
        sleep(1)
        loginTextFiled.typeText("<Ваш email>")
        
        let passwordTextfield = webView.descendants(matching: .secureTextField).element
        XCTAssertTrue(passwordTextfield.waitForExistence(timeout: 5))
        
        passwordTextfield.tap()
        passwordTextfield.typeText("<Ваш пароль>")
        
        webView.buttons["Login"].tap()
        
        let tablesQuery = app.tables
        let cell = tablesQuery.children(matching: .cell).element(boundBy: 0)
        
        XCTAssertTrue(cell.waitForExistence(timeout: 5))
    }
    
    func testFeed() throws {
        let tablesQuery = app.tables
        
        let cell = tablesQuery.children(matching: .cell).element(boundBy: 0)
        cell.swipeUp()
        
        sleep(3)
        
        let cellToLike = tablesQuery.children(matching: .cell).element(boundBy: 1)
        
        sleep(3)
        
        cellToLike.buttons["like button"].tap()
        
        sleep(3)
        
        cellToLike.buttons["like button"].tap()
        
        sleep(2)
        
        cellToLike.tap()
        
        sleep(2)
        
        let image = app.scrollViews.images.element(boundBy: 0)
        image.pinch(withScale: 3, velocity: 1)
        image.pinch(withScale: 0.5, velocity: -1)
        
        let navBackButtonWhiteButton = app.buttons["nav back button white"]
        navBackButtonWhiteButton.tap()
    }
    
    func testProfile() throws {
        sleep(3)
        app.tabBars.buttons.element(boundBy: 1).tap()
       
        XCTAssertTrue(app.staticTexts["Aleksandr "].exists) 
        XCTAssertTrue(app.staticTexts["@darkravenn"].exists)
        
        app.buttons["logout button"].tap()
        
        app.alerts["Bye bye!"].scrollViews.otherElements.buttons["Yes"].tap()
    }
}
