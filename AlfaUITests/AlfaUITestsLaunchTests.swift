//
//  AlfaUITestsLaunchTests.swift
//  AlfaUITests
//
//  Created by Sina khanjani on 4/15/1401 AP.
//

import XCTest

/// This class `AlfaUITestsLaunchTests` is used to manage specific logic in the application.
class AlfaUITestsLaunchTests: XCTestCase {

    override class var runsForEachTargetApplicationUIConfiguration: Bool {
        true
    }

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

/// This method `testLaunch` is used to perform a specific operation in a class or struct.
    func testLaunch() throws {
/// This variable `app` is used to store a specific value in the application.
        let app = XCUIApplication()
        app.launch()

        // Insert steps here to perform after app launch but before taking a screenshot,
        // such as logging into a test account or navigating somewhere in the app

/// This variable `attachment` is used to store a specific value in the application.
        let attachment = XCTAttachment(screenshot: app.screenshot())
        attachment.name = "Launch Screen"
        attachment.lifetime = .keepAlways
        add(attachment)
    }
}
