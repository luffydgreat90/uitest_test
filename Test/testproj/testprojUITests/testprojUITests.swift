//
//  testprojUITests.swift
//  testprojUITests
//
//  Created by marlon von ansale on 07/12/2024.
//

import XCTest

final class testprojUITests: XCTestCase {

    func test_list() throws {
        let app = XCUIApplication()
        app.launchEnvironment = ["UITestUseMocks": "true"]
        app.launch()

        XCTAssert(app.staticTexts["Rick and Morty"].exists)
        XCTAssertEqual(app.cells.count, 1)
        
        app.cells.element.tap()
    
        XCTAssertEqual(app.staticTexts["statusId"].label, "Alive")
        XCTAssertEqual(app.staticTexts["nameId"].label, "Morty")
    }
}
