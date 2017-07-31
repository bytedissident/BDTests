//
//  BDTestsUnitTestsUITests.swift
//  BDTestsUnitTestsUITests
//
//  Created by Derek Bronston on 5/22/17.
//  Copyright © 2017 Derek Bronston. All rights reserved.
//

import XCTest


@testable import BDTestsUnitTests

class BDTestsUnitTestsUITests: XCTestCase {
        
    override func setUp() {
        super.setUp()
        continueAfterFailure = false
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testMultiStub(){
      
        let bdTests = BDTests(enviornmentName: nil)
        _ = bdTests.createTest(jsonString: "{\"key\":\"value\"}", jsonFile: nil, httpCode: 200)
        //UIPasteboard.general.string = "Hello world"
        
        
        let app = XCUIApplication()
        app.launch()
        app.buttons["One"].tap()
        
 
        //UIPasteboard.general.string = "Hello world 2"
        _ = bdTests.createTest(jsonString: "{\"key\":\"value 2\"}", jsonFile: nil, httpCode: 200)
        //bdTests.setClipboard(json: "{\"key\":\"value 2\"}")
        
         app.buttons["One"].tap()
        //app.buttons["Submit"].tap()
        
    }
    
}
