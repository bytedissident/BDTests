//
//  BDTestsRealm.swift
//  BDTest
//
//  Created by Derek Bronston on 2/16/17.
//  Copyright © 2017 Derek Bronston. All rights reserved.
//

import XCTest

class BDTestsRealm:XCTTestCase {
    
    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        ///XCUIApplication().launch()
        
        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDown() {
        
        let test = BDTestsMain(enviornmentName: nil)
        test.removeTest()
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func seedTest(spec:String){
        
        let test = BDTestsMain(enviornmentName: nil)
        let model = test.seedDatabase(json: "{\"\(spec)\":true}")
        XCTAssert(model)
        
        let app = XCUIApplication()
        app.launch()
    }
    
    //TEST LABEL
    func label(text:String,identifier:String){
        
        let app = XCUIApplication()
        
        let label = app.staticTexts[identifier]
        let exists_label = NSPredicate(format: "exists == true")
        expectation(for: exists_label, evaluatedWith:label, handler: nil)
        waitForExpectations(timeout: 5, handler: nil)
        
        //IS STATUS CORRECTLY DISPLAYED
        XCTAssertNotNil(label)
        XCTAssertEqual(label.label, text)
    }
    
    //TEST ALERT
    func alert(title:String,message:String?,button:String?,tap:Bool?){
        
        let app = XCUIApplication()
        
        let alert = app.alerts[title]
        let exists_alert = NSPredicate(format: "exists == true")
        expectation(for: exists_alert , evaluatedWith:alert , handler: nil)
        waitForExpectations(timeout: 2, handler: nil)
        
        if let msg = message {
            XCTAssert(app.alerts[title].staticTexts[msg].exists)
        }
        
        if let btn = button {
            XCTAssert(app.alerts[title].buttons[btn].exists)
        }
        
        if tap != nil {
            if let btn = button {
                app.alerts[title].buttons[btn].tap()
            }else {
                XCTFail()
            }
        }
    }
    
    //TEST BUTTON
    func button(identifier:String,tap:Bool?,exists:String){
        
        let app = XCUIApplication()
        
        let btn = app.buttons[identifier]
        let exists_btn = NSPredicate(format: "exists == \(exists)")
        expectation(for: exists_btn , evaluatedWith:btn , handler: nil)
        waitForExpectations(timeout: 5, handler: nil)
        
        if tap != nil {
            btn.tap()
        }
    }
    
    //ACTION SHEET
    func sheet(title:String,tap:Bool?,numberOfItems:UInt?){
        
        let app = XCUIApplication()
        
        //ARE THERE CHOICES AVAIL
        let weeklyOrderChoice1 = app.sheets.buttons[title]
        let exists_weeklyOrderChoice1 = NSPredicate(format: "exists == true")
        expectation(for: exists_weeklyOrderChoice1 , evaluatedWith:weeklyOrderChoice1 , handler: nil)
        waitForExpectations(timeout: 5, handler: nil)
        
        if let num = numberOfItems {
            let sht = app.sheets
            XCTAssertEqual(sht.buttons.count, num)
        }
        
        if tap != nil {
            weeklyOrderChoice1.tap()
        }
    }
    
    func collectionCell(cellLabel:String,labelString:String?,tap:Bool?){
        
        let app = XCUIApplication()
        let firstChild = app.collectionViews.children(matching:.any).element(boundBy: 0)
        if firstChild.exists {
            
            if tap != nil {
                firstChild.tap()
            }
            
            let cellLbl = app.collectionViews.children(matching:.any).staticTexts[cellLabel]
            let exists_cellLbl  = NSPredicate(format: "exists == true")
            expectation(for: exists_cellLbl  , evaluatedWith:cellLbl  , handler: nil)
            waitForExpectations(timeout: 5, handler: nil)
            
            if let lblString = labelString {
                XCTAssertEqual(cellLbl.label, lblString)
            }
        }
    }
    
}
