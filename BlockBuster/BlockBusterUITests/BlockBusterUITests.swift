//
//  BlockBusterUITests.swift
//  BlockBusterUITests
//
//  Created by Bill on 15/8/25.
//

import XCTest

final class BlockBusterUITests: XCTestCase {
    var app: XCUIApplication!

    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launchArguments.append("--ui-testing")
        app.launch()
    }

    override func tearDownWithError() throws {
        app = nil
    }

    // Test: Home Page is always visible
    func testHomePageViewExists() throws {
        let homePageView = app.descendants(matching: .any)["HomePageView"]
        XCTAssertTrue(homePageView.waitForExistence(timeout: 5), "HomePageView should exist in the view hierarchy")
    }
    
    // Test: Movie list loads at launch
    func testMovieListLoads() throws {
        let predicate = NSPredicate(format: "identifier BEGINSWITH %@", "MovieCell_")
        let movieCells = app.otherElements.matching(predicate)
        let firstMovie = movieCells.firstMatch
        XCTAssertTrue(firstMovie.waitForExistence(timeout: 5), "At least one Movie cell should be loaded")
        
    }
    
    //Test Movie Page navigation
    func testMoviePageNavigation() throws {
        let moviePageView = app.descendants(matching: .any)["MoviePageView"]
        let predicate = NSPredicate(format: "identifier BEGINSWITH %@", "MovieCell_")
        let movieCells = app.otherElements.matching(predicate)
        let firstMovie = movieCells.firstMatch
        XCTAssertTrue(firstMovie.waitForExistence(timeout: 5), "First Movie should exist in the view hierarchy")
        firstMovie.tap()
        XCTAssertTrue(moviePageView.waitForExistence(timeout: 5), "Movie Page View should exist in the view hierarchy")
    }
    
    // Test: Search is visible
    func testSearchViewExists() throws {
        let searchView = app.descendants(matching: .any)["SearchView"]
        let searchButton = app.descendants(matching: .any)["SearchButton"]
        XCTAssertTrue(searchButton.waitForExistence(timeout: 5), "Search button should exist")
        searchButton.tap()
        XCTAssertTrue(searchView.waitForExistence(timeout: 5), "Search View should exist in the view hierarchy")
    }
}
