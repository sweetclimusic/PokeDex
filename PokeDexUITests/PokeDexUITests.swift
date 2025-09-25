//
//  PokeDexUITests.swift
//  PokeDexUITests
//
//  Created by Ashlee Muscroft on 19/01/2025.
//

import XCTest

final class PokeDexUITests: XCTestCase {
    static let Interval: TimeInterval = 0.5
    
    @MainActor
    func test_ViewDetails() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()
        let bulbasaurButton = app.buttons["#001, BULBASAUR"]
        let closeButton = app.buttons["xmark"]
        let detailViewBackgroundImage = app.images["ForestBG"]
        awaitElement(bulbasaurButton)
        XCTAssertTrue(bulbasaurButton.isHittable)
        bulbasaurButton.tap()
        
        awaitElement(detailViewBackgroundImage)
        awaitElement(closeButton)
        XCTAssertTrue(closeButton.isHittable)
        closeButton.tap()
        
        
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
}

extension XCTestCase {
    @MainActor @discardableResult
    public func awaitElement(
        _ element: XCUIElement,
        file: StaticString = #file,
        line: UInt = #line
    ) -> Self {
        let elementExists = NSPredicate(format: "exists == true")
        let elementExistsExpectation = self.expectation(
            for: elementExists,
            evaluatedWith: element,
            handler: nil
        )
        
        let result = XCTWaiter().wait(
            for: [elementExistsExpectation],
            timeout: PokeDexUITests.Interval
        )
        
        if result != .completed {
            XCTAssertTrue(
                element.exists,
                "Bulbasaur button does not exist"
                ,file: #file,
                line: #line)
        }
        return self
    }
}

