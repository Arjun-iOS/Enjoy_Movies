//
//  Architecture_Demo_By_ArjunUITestsLaunchTests.swift
//  Architecture_Demo_By_ArjunUITests
//
//  Created by Arjun Thakur on 15/11/24.
//

import XCTest

final class Architecture_Demo_By_ArjunUITestsLaunchTests: XCTestCase {

    override class var runsForEachTargetApplicationUIConfiguration: Bool {
        true
    }

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    func testLaunch() throws {
        let app = XCUIApplication()
        app.launch()

        // Insert steps here to perform after app launch but before taking a screenshot,
        // such as logging into a test account or navigating somewhere in the app

        let attachment = XCTAttachment(screenshot: app.screenshot())
        attachment.name = "Launch Screen"
        attachment.lifetime = .keepAlways
        add(attachment)
    }
}
