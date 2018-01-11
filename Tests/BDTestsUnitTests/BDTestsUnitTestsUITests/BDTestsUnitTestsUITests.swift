//
//  BDTestsUnitTestsUITests.swift
//  BDTestsUnitTestsUITests
//
//  Created by Derek Bronston on 5/22/17.
//  Copyright © 2017 Derek Bronston. All rights reserved.
import XCTest
@testable import BDTestsUnitTests

class BDTestsUnitTestsUITests: BDTestsUI {
        
    override func setUp() {
        super.setUp()
        continueAfterFailure = false
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testGivenTheUserTriggersNothingWeOnlySeeDefaultData(){
        
        let app = XCUIApplication()
        app.launch()
        
        label(behavior: "We should now see the label display", text: "NO DATA YET", identifier: "NO DATA YET", exists: true)
    }
    
    func testGivenTheUserTriggersCachedDataFromTheDatabaseThenCallsApi(){
        
        let bdTests = BDTests(enviornmentName: nil)
        _ = bdTests.seedDatabase(ref: "testMethod")
        
        let app = XCUIApplication()
        app.launch()
        
        button(behavior: "Press the button to trigger an db action", identifier: "Two", tap: true, exists: true)
        
        label(behavior: "We should now see the label display", text: "test-string", identifier: "test-string", exists: true)
        
        //ADD A SECOND STUB RESPONSE
        _ = bdTests.createTest(jsonString: "{\"key\":\"value 2\"}", jsonFile: nil, httpCode: 200)
        
        button(behavior: "Press the button to trigger an api call", identifier: "One", tap: true, exists: true)
        
        label(behavior: "We should now see the label display", text: "value 2", identifier: "value 2", exists: true)
    }
    
    func testGivenTheUserTriggersCachedDataFromTheDatabse(){
        
        let bdTests = BDTests(enviornmentName: nil)
        _ = bdTests.seedDatabase(ref: "testMethod")
        
        let app = XCUIApplication()
        app.launch()
        
        button(behavior: "Press the button to trigger an db action", identifier: "Two", tap: true, exists: true)
        
        label(behavior: "We should now see the label display", text: "test-string", identifier: "test-string", exists: true)
    }
    
    func testGivenTheUserMakesOneAPICall(){
        
        let bdTests = BDTests(enviornmentName: nil)
        _ = bdTests.createTest(jsonString: "{\"key\":\"value\"}", jsonFile: nil, httpCode: 200)
        
        let app = XCUIApplication()
        app.launch()
        
        button(behavior: "Press the button to trigger an api call", identifier: "One", tap: true, exists: true)
        
        
        label(behavior: "We should now see the label display", text: "value", identifier: "value", exists: true)
    }
    
    func testGivenTheUserMakesTwoAPICalls(){
      
        let bdTests = BDTests(enviornmentName: nil)
        _ = bdTests.createTest(jsonString: "{\"key\":\"value\"}", jsonFile: nil, httpCode: 200)
        
        let app = XCUIApplication()
        app.launch()
        
         button(behavior: "Press the button to trigger an api call", identifier: "One", tap: true, exists: true)
        
 
        label(behavior: "We should now see the label display", text: "value", identifier: "value", exists: true)
        
        //ADD A SECOND STUB RESPONSE
        _ = bdTests.createTest(jsonString: "{\"key\":\"value 2\"}", jsonFile: nil, httpCode: 200)
        
        button(behavior: "Press the button to trigger an api call", identifier: "One", tap: true, exists: true)
        
        label(behavior: "We should now see the label display", text: "value 2", identifier: "value 2", exists: true)
    }
}
