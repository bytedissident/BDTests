//
//  BDTestsRealm.swift
//  BDTest
//
//  Created by Derek Bronston on 2/16/17.
//  Copyright © 2017 Derek Bronston. All rights reserved.
//

import XCTest
import BDTests

class BDUITestBase: XCTestCase {
    
    override func setUp() {
        super.setUp()
        
        continueAfterFailure = true
    }
    
    override func tearDown() {
        
        let test = BDTests(enviornmentName: nil)
        test.removeTest()
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        
        let app = XCUIApplication()
        app.launch()
        app.children(matching: .window).element(boundBy: 0).children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.tap()
        
        let usernameTextField = app.textFields["username"]
        usernameTextField.tap()
        usernameTextField.typeText("tyeestst")
        app.typeText("\n")
        
    }
    
    func seedTest(spec:String){
        
        let test = BDTests(enviornmentName: nil)
        let model = test.seedDatabase(json: "{\"\(spec)\":true}")
        XCTAssert(model)
        //XCUIApplication().launch()
        let app = XCUIApplication()
        app.launch()
    }
    
    func textfield(identifier:String,text:String){
        
        let app = XCUIApplication()
        
        let field = app.textFields[identifier]
        let exists_field = NSPredicate(format: "exists == true")
        expectation(for: exists_field, evaluatedWith:field, handler: nil)
        waitForExpectations(timeout: 5, handler: nil)
        
        field.tap()
        field.typeText(text)
        
    }
    
    func secureTextfield(identifier:String,text:String){
        
        let app = XCUIApplication()
        
        let field = app.secureTextFields[identifier]
        let exists_field = NSPredicate(format: "exists == true")
        expectation(for: exists_field, evaluatedWith:field, handler: nil)
        waitForExpectations(timeout: 5, handler: nil)
        
        field.tap()
        field.typeText(text)
        
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
    
    func labelContains(text:String,identifier:String){
        
        let app = XCUIApplication()
        
        let label = app.staticTexts[identifier]
        let exists_label = NSPredicate(format: "exists == true")
        expectation(for: exists_label, evaluatedWith:label, handler: nil)
        waitForExpectations(timeout: 5, handler: nil)
        
        //IS STATUS CORRECTLY DISPLAYED
        XCTAssertNotNil(label)
        XCTAssert(label.label.contains(text))
    }
    
    
    func view(exists:String,identifier:String){
        
        let app = XCUIApplication()
        let label = app.otherElements[identifier]
        let exists_view = NSPredicate(format: "exists == \(exists)")
        expectation(for: exists_view, evaluatedWith:label, handler: nil)
        waitForExpectations(timeout: 5, handler: nil)
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
    
    func alertFalse(title:String){
        let app = XCUIApplication()
        
        let alert = app.alerts[title]
        let exists_alert = NSPredicate(format: "exists == false")
        expectation(for: exists_alert , evaluatedWith:alert , handler: nil)
        waitForExpectations(timeout: 2, handler: nil)
        
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
    
    func buttonLabel(identifier:String,text:String){
        let app = XCUIApplication()
        
        let btn = app.buttons[identifier]
        let exists_btn = NSPredicate(format: "exists == true")
        expectation(for: exists_btn , evaluatedWith:btn , handler: nil)
        waitForExpectations(timeout: 5, handler: nil)
        
        
        XCTAssertEqual(app.label, text)
    }
    
    func statusBar(identifier:String,tap:Bool?){
        
        let app = XCUIApplication()
        
        let btn = app.statusBars.buttons[identifier]
        let exists_btn = NSPredicate(format: "exists == true")
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
    
    func collectionWithLabel(cellLabel:String,tap:Bool?){
        
        let app = XCUIApplication()
        let firstChild = app.collectionViews[cellLabel].children(matching:.any).element(boundBy: 0)
        if firstChild.exists {
            
            if tap != nil {
                firstChild.tap()
            }
        }
    }
    
    func collectionCell(cellLabel:String,labelString:String?,tap:Bool?){
        
        let app = XCUIApplication()
        let firstChild = app.collectionViews.children(matching:.any).element(boundBy: 0)
        if firstChild.exists {
            
            if tap != nil {
                firstChild.tap()
            }
            if labelString ==  nil { return }
            let cellLbl = app.collectionViews.children(matching:.any).staticTexts[cellLabel]
            let exists_cellLbl  = NSPredicate(format: "exists == true")
            expectation(for: exists_cellLbl  , evaluatedWith:cellLbl  , handler: nil)
            waitForExpectations(timeout: 5, handler: nil)
            
            if let lblString = labelString {
                XCTAssertEqual(cellLbl.label, lblString)
            }
        }
    }
    
    func collectionCellLabelExists(cellLabel:String,exists:String){
        
        let app = XCUIApplication()
        let firstChild = app.collectionViews.children(matching:.any).element(boundBy: 0)
        if firstChild.exists {
            
            let cellLbl = app.collectionViews.children(matching:.any).staticTexts[cellLabel]
            let exists_cellLbl  = NSPredicate(format: "exists == \(exists)")
            expectation(for: exists_cellLbl  , evaluatedWith:cellLbl  , handler: nil)
            waitForExpectations(timeout: 5, handler: nil)
            
            
        }
    }
    
    func collectionButton(buttonLabel:String,tap:Bool?){
        
        let app = XCUIApplication()
        let firstChild = app.collectionViews.children(matching:.any).element(boundBy: 0)
        if firstChild.exists {
            
            
            let cellLbl = firstChild.children(matching:.any).buttons[buttonLabel]
            let exists_cellLbl  = NSPredicate(format: "exists == true")
            expectation(for: exists_cellLbl  , evaluatedWith:cellLbl  , handler: nil)
            waitForExpectations(timeout: 5, handler: nil)
            
            if tap != nil {
                cellLbl.tap()
            }
        }
    }
    
    func tabBar(tabIndex:UInt){
        
        let tabBarsQuery = XCUIApplication().tabBars
        let button = tabBarsQuery.children(matching: .button).element(boundBy: tabIndex)
        button.tap()
        button.tap()
        
    }
    
    func tableCellByIndex(cellIndex:UInt){
        let app = XCUIApplication()
        app.tables.children(matching: .any).element(boundBy:cellIndex).tap()
    }
    
    
    func tableCellByIdentifier(text:String,tap:Bool){
        
        let app = XCUIApplication()
        let label =  app.tables.staticTexts[text]
        let label_exists = NSPredicate(format: "exists == true")
        expectation(for: label_exists  , evaluatedWith:label , handler: nil)
        waitForExpectations(timeout: 5, handler: nil)
        
        if tap {
            label.tap()
        }
    }
    
    func tableCellByIdentifierDoesNotExist(text:String){
        
        let app = XCUIApplication()
        let label =  app.tables.staticTexts[text]
        let label_exists = NSPredicate(format: "exists == false")
        expectation(for: label_exists  , evaluatedWith:label , handler: nil)
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func navBar(navIdentifier:String){
        let app = XCUIApplication()
        let bar = app.navigationBars[navIdentifier]
        let navBar_exists = NSPredicate(format: "exists == true")
        expectation(for: navBar_exists  , evaluatedWith:bar  , handler: nil)
        waitForExpectations(timeout: 5, handler: nil)
        
        bar.otherElements.children(matching: .button).element.tap()
    }
    
    
    func login(){
        
        let test = BDTests(enviornmentName: nil)
        _ = test.createTest(jsonString: nil, jsonFile: "TestDataInitialData", httpCode: 200)
        
        
        let app = XCUIApplication()
        app.launch()
        sleep(1 )
        
        let usernameTextField = app.textFields["username"]
        usernameTextField.tap()
        usernameTextField.typeText("derek.bronston+demo@freshly.com")
        
        //CLOSE
        //CLOSE
        let userInterface = UIDevice.current.model
        if userInterface.contains("iPad") {
            app.buttons["Done"].tap()
        }
        
        let passwordSecureTextField = app.secureTextFields["password"]
        passwordSecureTextField.tap()
        passwordSecureTextField.typeText("09871234")
        
        //close
        if userInterface.contains("iPad") {
            app.buttons["Done"].tap()
        }
        
        
        app.buttons["submit-button"].tap()
    }
}
