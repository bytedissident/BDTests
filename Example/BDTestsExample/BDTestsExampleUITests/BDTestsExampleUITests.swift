//
//  BDTestsExampleUITests.swift
//  BDTestsExampleUITests
//
//  Created by Derek Bronston on 5/18/17.
//  Copyright © 2017 Derek Bronston. All rights reserved.
//

import XCTest
import BDTests

class BDTestsExampleUITests: BDTestsUIBase{
    
    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        
        
        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample_string() {
        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
        let bdTests = BDTests(enviornmentName: nil)
        _ = bdTests.createTest(jsonString: "{\"key\":\"value\"}", jsonFile: nil, httpCode: 200)
        
        
        let app = XCUIApplication()
        app.launch()
        app.buttons["Submit"].tap()
        sleep(1)
        XCTAssertEqual(app.staticTexts["value-label"].label , "value")
    }
    
    func testExample_file() {
        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
        let bdTests = BDTests(enviornmentName: nil)
        _ = bdTests.createTest(jsonString: nil, jsonFile: "test_local_json", httpCode: 200)
        
        
        let app = XCUIApplication()
        app.launch()
        app.buttons["Submit"].tap()
        sleep(1)
        XCTAssertEqual(app.staticTexts["value-label"].label , "value")
    }
    
    func testExample_model_data() {
        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
        let bdTests = BDTests(enviornmentName: nil)
        //_ = bdTests.createTest(jsonString: nil, jsonFile: "test_local_json", httpCode: 200)
        let model = bdTests.seedDatabase(json: "{\"data-object\":\"model value\"}")
        XCTAssert(model)
        
        let app = XCUIApplication()
        app.launch()
        app.buttons["Submit"].tap()
        sleep(1)
        XCTAssertEqual(app.staticTexts["model-data"].label , "Test Name")
}
}
