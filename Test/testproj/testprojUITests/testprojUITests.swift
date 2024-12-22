//
//  testprojUITests.swift
//  testprojUITests
//
//  Created by marlon von ansale on 07/12/2024.
//

import XCTest

protocol Test {}

final class testprojUITests: XCTestCase {

    class Testerman: Test {}

    func testExample() throws {
        let app = XCUIApplication()
        app.launch()

    }

    func test_e(){
        let testm = Testerman()
        let test: Test = testm

    }

}


