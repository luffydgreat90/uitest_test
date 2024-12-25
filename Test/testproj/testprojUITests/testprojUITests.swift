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

        XCTAssertEqual(app.title, "Rick and Morty")
        XCTAssertEqual(app.cells.count, 1)
    }
}
