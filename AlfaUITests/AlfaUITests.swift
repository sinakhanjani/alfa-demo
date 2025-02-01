//
//  AlfaUITests.swift
//  AlfaUITests
//
//  Created by Sina khanjani on 4/15/1401 AP.
//

import XCTest

/// This class `AlfaUITests` is used to manage specific logic in the application.
class AlfaUITests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

/// This method `testExample` is used to perform a specific operation in a class or struct.
    func testExample() throws {
        // UI tests must launch the application that they test.
/// This variable `app` is used to store a specific value in the application.
        let app = XCUIApplication()
        app.launch()

        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

/// This method `testLaunchPerformance` is used to perform a specific operation in a class or struct.
    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
}
