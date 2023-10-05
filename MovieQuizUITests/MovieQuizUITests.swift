//
//  MovieQuizUITests.swift
//  MovieQuizUITests
//
//  Created by Admin on 22.09.2023.
//

import XCTest

final class MovieQuizUITests: XCTestCase {
    var app: XCUIApplication!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        app = XCUIApplication()
        app.launch()
        continueAfterFailure = false
    }
    
    override func tearDownWithError() throws {
        try super.tearDownWithError()
        app.terminate()
        app = nil
    }
    
    func testYesButton() {
        sleep(3)
        let firstPoster = app.images["Poster"]
        let firstPosterData = firstPoster.screenshot().pngRepresentation
        
        app.buttons["Yes"].tap()
        sleep(3)
        
        let secondPoster = app.images["Poster"]
        let secondPosterData = secondPoster.screenshot().pngRepresentation
        
        let indexLabel = app.staticTexts["Index"]
        XCTAssertNotEqual(firstPosterData, secondPosterData)
        XCTAssertEqual(indexLabel.label, "2/10")
        
    }
    
    func testNoButton() {
        sleep(3)
        let firstPoster = app.images["Poster"]
        let firstPosterData = firstPoster.screenshot().pngRepresentation
        
        app.buttons["No"].tap()
        sleep(3)
        
        let secondPoster = app.images["Poster"]
        let secondPosterData = secondPoster.screenshot().pngRepresentation
        let indexLabel = app.staticTexts["Index"]
        
        XCTAssertNotEqual(firstPosterData, secondPosterData)
        XCTAssertEqual(indexLabel.label, "2/10")
    }
    
    func testShowAlertResult() {
        sleep(2)
        for _ in 0..<10 {
            app.buttons["Yes"].tap()
            sleep(2)
        }
        
        let alertResult = app.alerts["AlertResult"]
        XCTAssertTrue(alertResult.exists)
        
        let label = alertResult.label
        XCTAssertEqual(label, "Этот раунд окончен!")
        
        let buttonText = alertResult.buttons.firstMatch.label
        XCTAssertEqual(buttonText, "Сыграть еще раз")
    }
    
    func testDismissAlertResult() {
        sleep(2)
        for _ in 0..<10 {
            app.buttons["Yes"].tap()
            sleep(2)
        }
        
        let alertResult = app.alerts["AlertResult"]
        alertResult.buttons.firstMatch.tap()
        sleep(2)
        
        XCTAssertFalse(alertResult.exists)
        
        let indexLabel = app.staticTexts["Index"]
        XCTAssertEqual(indexLabel.label, "1/10")
    }
}
