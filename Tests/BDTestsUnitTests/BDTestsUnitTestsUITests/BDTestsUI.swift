//
//  BDTestsUI
//
//  Created by Derek Bronston on 2/16/17.
//  Copyright © 2017 Derek Bronston. All rights reserved.
//
import XCTest

open class BDTestsUI:XCTestCase {
    
    override open func setUp() {
        super.setUp()
        
        continueAfterFailure = false
    }
    
    override open func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    
    
    /**
     If existence of the textfield == true.
     tap and type text. If does not exist only test for that state
     
     -parameter identifier: String
     -parameter text: String?
     -parameter exists: Bool
     -returns: none
     */
    public func textfield(behavior:String,identifier:String,text:String?,exists:Bool){
        
        let app = XCUIApplication()
        
        let doesExist = exists ? "true" : "false"
        
        let field = app.textFields[identifier]
        let exists_field = NSPredicate(format: "exists == \(doesExist)")
        expectation(for: exists_field, evaluatedWith:field, handler: nil)
        waitForExpectations(timeout: 5, handler: nil)
        
        if exists{
            field.tap()
            
            guard let textToEnter = text else { return }
            field.typeText(textToEnter)
        }
    }
    
    /**
     If existence of the secure textfield == true.
     tap and type text. If does not exist only test for that state
     
     - parameter identifier: String
     - parameter text: String?
     - parameter exists: Bool
     - returns: none
     */
    public func secureTextfield(behavior:String,identifier:String,text:String?,exists:Bool){
        
        let app = XCUIApplication()
        
        let doesExist = exists ? "true" : "false"
        
        let field = app.secureTextFields[identifier]
        let exists_field = NSPredicate(format: "exists == \(doesExist)")
        expectation(for: exists_field, evaluatedWith:field, handler: nil)
        waitForExpectations(timeout: 5, handler: nil)
        
        if exists{
            field.tap()
            
            guard let textToEnter = text else { return }
            field.typeText(textToEnter)
        }
    }
    
    /**
     If existence of the label == true.
     Check label.text value. If does not exist only test for that state
     
     - parameter identifier: String
     - parameter text: String?
     - parameter exists: Bool
     - returns: none
     */
    public func label(behavior:String,text:String?,identifier:String,exists:Bool){
        
        let app = XCUIApplication()
        let doesExist = exists ? "true" : "false"
        let label = app.staticTexts[identifier]
        let exists_label = NSPredicate(format: "exists == \(doesExist)")
        expectation(for: exists_label, evaluatedWith:label, handler: nil)
        waitForExpectations(timeout: 5, handler: nil)
        
        if !exists { return }
        //IS STATUS CORRECTLY DISPLAYED
        XCTAssertNotNil(label)
        
        guard let textInLabel = text else { return }
        XCTAssertEqual(label.label, textInLabel)
    }
    
    /**
     If existence of the label == true.
     Check label.text contains string.
     
     - parameter identifier:String
     - parameter text: String
     - returns: none
     */
    public func labelContains(behavior:String,text:String,identifier:String){
        
        let app = XCUIApplication()
        let label = app.staticTexts[identifier]
        let exists_label = NSPredicate(format: "exists == true")
        expectation(for: exists_label, evaluatedWith:label, handler: nil)
        waitForExpectations(timeout: 5, handler: nil)
        
        
        //IS STATUS CORRECTLY DISPLAYED
        XCTAssertNotNil(label)
        XCTAssert(label.label.contains(text))
    }
    
    /**
     Check existence of view
     
     - parameter identifier: String
     - parameter exists: Bool
     - returns: none
     */
    public func view(behavior:String,identifier:String,exists:Bool){
        
        let app = XCUIApplication()
        let doesExist = exists ? "true" : "false"
        let label = app.otherElements[identifier]
        let exists_view = NSPredicate(format: "exists == \(doesExist)")
        expectation(for: exists_view, evaluatedWith:label, handler: nil)
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    /**
     Check existence of UIAlertView.
     Check message text, check title text, check button text, tap button
     
     - parameter title: String
     - parameter message: String?
     - parameter button: String?
     - parameter tap: Bool
     - parameter exists: Bool
     - returns: none
     */
    public func alert(behavior:String,title:String,message:String?,button:String?,tap:Bool,exists:Bool){
        
        let app = XCUIApplication()
        let doesExist = exists ? "true" : "false"
        let alert = app.alerts[title]
        let exists_alert = NSPredicate(format: "exists == \(doesExist)")
        expectation(for: exists_alert , evaluatedWith:alert , handler: nil)
        waitForExpectations(timeout: 2, handler: nil)
        
        if let msg = message {
            XCTAssert(app.alerts[title].staticTexts[msg].exists)
        }
        
        if let btn = button {
            XCTAssert(app.alerts[title].buttons[btn].exists)
        }
        
        if tap {
            if let btn = button {
                app.alerts[title].buttons[btn].tap()
            }else {
                XCTFail()
            }
        }
    }
    
    /**
     Check existence of UIButton.
     Tap button if indicated
     
     - parameter identifier: String
     - parameter tap: Bool
     - parameter exists: Bool
     - returns: none
     */
    public func button(behavior:String,identifier:String,tap:Bool,exists:Bool){
        
        let app = XCUIApplication()
        let doesExist = exists ? "true" : "false"
        let btn = app.buttons[identifier]
        let exists_btn = NSPredicate(format: "exists == \(doesExist)")
        expectation(for: exists_btn , evaluatedWith:btn , handler: nil)
        waitForExpectations(timeout: 5, handler: nil)
        
        if tap {
            btn.tap()
        }
    }
    
    
    /**
     Check existence of UIButton.
     Tap button if indicated
     
     - parameter identifier: String
     - parameter tap: Bool
     - parameter exists: Bool
     - returns: none
     */
    public func buttonInTableCell(behavior:String,identifier:String,cellIndex:UInt,tap:Bool,exists:Bool){
        
        let app = XCUIApplication()
        let doesExist = exists ? "true" : "false"
        let btn = app.tables.children(matching: .any).element(boundBy:cellIndex).buttons[identifier]
        let exists_btn = NSPredicate(format: "exists == \(doesExist)")
        expectation(for: exists_btn , evaluatedWith:btn , handler: nil)
        waitForExpectations(timeout: 5, handler: nil)
        
        if tap {
            btn.tap()
        }
    }
    
    /**
     Check existence of UIButton.
     Tap button if indicated
     
     - parameter identifier: String
     - parameter tap: Bool
     - parameter exists: Bool
     - returns: none
     */
    public func buttonInCollectionCell(behavior:String,identifier:String,cellIndex:UInt,tap:Bool,exists:Bool){
        
        let app = XCUIApplication()
        let doesExist = exists ? "true" : "false"
        let cellsQuery = app.collectionViews.cells
        let btn = cellsQuery.element(boundBy: cellIndex).buttons[identifier]
        let exists_btn = NSPredicate(format: "exists == \(doesExist)")
        expectation(for: exists_btn , evaluatedWith:btn , handler: nil)
        waitForExpectations(timeout: 5, handler: nil)
        
        if tap {
            btn.tap()
        }
    }
    
    public func labelInCollectionCell(behavior:String,identifier:String,text:String,cellIndex:UInt,exists:Bool){
        
        let app = XCUIApplication()
        let doesExist = exists ? "true" : "false"
        let cellsQuery = app.collectionViews.cells
        let btn = cellsQuery.element(boundBy: cellIndex).staticTexts[identifier]
        let exists_btn = NSPredicate(format: "exists == \(doesExist)")
        expectation(for: exists_btn , evaluatedWith:btn , handler: nil)
        waitForExpectations(timeout: 5, handler: nil)
        XCTAssertEqual(btn.value as? String, text)
    }
    
    /**
     Check existence of UIButton and whether button's label == text
     
     - parameter identifier: String
     - parameter text: String
     - returns: none
     */
    public  func buttonLabel(behavior:String,identifier:String,text:String){
        
        let app = XCUIApplication()
        let btn = app.buttons[identifier]
        let exists_btn = NSPredicate(format: "exists == true")
        expectation(for: exists_btn , evaluatedWith:btn , handler: nil)
        waitForExpectations(timeout: 5, handler: nil)
        
        XCTAssertEqual(btn.label, text)
    }
    
    /**
     Check existence of UIStatus
     
     - parameter identifier: String
     - parameter text: String
     - returns: none
     */
    public func statusBar(behavior:String,identifier:String,tap:Bool){
        
        let app = XCUIApplication()
        
        let btn = app.statusBars.buttons[identifier]
        let exists_btn = NSPredicate(format: "exists == true")
        expectation(for: exists_btn , evaluatedWith:btn , handler: nil)
        waitForExpectations(timeout: 5, handler: nil)
        
        if tap  {
            btn.tap()
        }
    }
    
    /**
     Check existence of UIActionSheet, check number of items in sheet if not nil,
     tap button of passed button title
     
     - parameter identifier: String
     - parameter text: String
     - returns: none
     */
    public func sheet(behavior:String,title:String,message:String?,button:String?,tap:Bool,numberOfItems:UInt?){
        
        let app = XCUIApplication()
        
        //ARE THERE CHOICES AVAIL
        let sheet = app.sheets[title]
        let exists_sheet = NSPredicate(format: "exists == true")
        expectation(for: exists_sheet , evaluatedWith:sheet , handler: nil)
        waitForExpectations(timeout: 5, handler: nil)
        
        if let msg = message {
            XCTAssert(app.sheets[title].staticTexts[msg].exists)
        }
        
        if let num = numberOfItems {
            let sht = app.sheets
            XCTAssertEqual(sht.buttons.count, num)
        }
        
        if let btn = button {
            app.sheets[title].buttons[btn].tap()
        }
    }
    
    
    
    /**
     Look for cell in collection view based on label, tap cell
     
     - parameter cellLabel: String
     - parameter tap: Bool
     - returns: none
     */
    public func collectionCell(behavior:String,cellLabel:String,tap:Bool){
        
        let app = XCUIApplication()
        let firstChild = app.collectionViews.children(matching:.any).element(boundBy: 0)
        if firstChild.exists {
            
            let cellLbl = app.collectionViews.children(matching:.any).staticTexts[cellLabel]
            let exists_cellLbl  = NSPredicate(format: "exists == true")
            expectation(for: exists_cellLbl  , evaluatedWith:cellLbl  , handler: nil)
            waitForExpectations(timeout: 5, handler: nil)
            
            if tap {
                firstChild.tap()
            }
        }
    }
    
    public func collectionButton(behavior:String,buttonLabel:String,tap:Bool){
        
        let app = XCUIApplication()
        let firstChild = app.collectionViews.children(matching:.any).element(boundBy: 0)
        
        if firstChild.exists {
            let cellLbl = firstChild.children(matching:.any).buttons[buttonLabel]
            let exists_cellLbl  = NSPredicate(format: "exists == true")
            expectation(for: exists_cellLbl  , evaluatedWith:cellLbl  , handler: nil)
            waitForExpectations(timeout: 5, handler: nil)
            
            if tap {
                cellLbl.tap()
            }
        }
    }
    
    
    /**
     Tap tab bar based on tab index
     
     - parameter: tabIndex: UInt
     - returns: none
     */
    public func tabBar(behavior:String,tabIndex:UInt){
        
        let tabBarsQuery = XCUIApplication().tabBars
        let button = tabBarsQuery.children(matching: .button).element(boundBy: tabIndex)
        button.tap()
    }
    
    /**
     Tap table cell based on IndexPath.row
     
     - parameter cellIndex: UInt
     - returns: none
     */
    public func tableCellByIndex(behavior:String,cellIndex:UInt){
        let app = XCUIApplication()
        app.tables.children(matching: .any).element(boundBy:cellIndex).tap()
    }
    
    
    /**
     Tap table cell based on identifier (cell label text)
     
     - parameter text: String
     - returns: none
     */
    public func tableCellByIdentifier(behavior:String,text:String,tap:Bool,exists:Bool){
        
        let app = XCUIApplication()
        let doesExist = exists ? "true" : "false"
        let label =  app.tables.staticTexts[text]
        let label_exists = NSPredicate(format: "exists == \(doesExist)")
        expectation(for: label_exists  , evaluatedWith:label , handler: nil)
        waitForExpectations(timeout: 5, handler: nil)
        
        if tap {
            label.tap()
        }
    }
    
    
    /**
     Look for nav bar with button, tap nav button
     
     - parameter indentifier: String
     - parameter tap: Bool
     - returns: none
     */
    public func navBar(behavior:String,navIdentifier:String){
        let app = XCUIApplication()
        let bar = app.navigationBars[navIdentifier]
        let navBar_exists = NSPredicate(format: "exists == true")
        expectation(for: navBar_exists  , evaluatedWith:bar  , handler: nil)
        waitForExpectations(timeout: 5, handler: nil)
        
        bar.otherElements.children(matching: .button).element.tap()
    }
    
    
    
    /*********************************************************************************
     **********************************************************************************
     **********************************************************************************
     **********************************************************************************
     **********************************************************************************
     *********************************************************************************/
    
    //MARK: Deprecated Methods
    
    /**
     If existence of the textfield == true.
     tap and type text. If does not exist only test for that state
     
     - parameter identifier: String
     - parameter text: String?
     - parameter exists: Bool
     - returns: none
     */
    @available(*, deprecated, message: "Use textfield(behavior:String, identifier:String,text:String?,exists:Bool) instead")
    public func textfield(identifier:String,text:String?,exists:Bool){
        
        let app = XCUIApplication()
        
        let doesExist = exists ? "true" : "false"
        
        let field = app.textFields[identifier]
        let exists_field = NSPredicate(format: "exists == \(doesExist)")
        expectation(for: exists_field, evaluatedWith:field, handler: nil)
        waitForExpectations(timeout: 5, handler: nil)
        
        if exists{
            field.tap()
            
            guard let textToEnter = text else { return }
            field.typeText(textToEnter)
        }
    }
    
    /**
     If existence of the secure textfield == true.
     tap and type text. If does not exist only test for that state
     
     - parameter identifier: String
     - parameter text: String?
     - parameter exists: Bool
     - returns: none
     */
    @available(*, deprecated, message: "Use secureTextfield(behavior:String, identifier:String,text:String?,exists:Bool) instead")
    public func secureTextfield(identifier:String,text:String?,exists:Bool){
        
        let app = XCUIApplication()
        
        let doesExist = exists ? "true" : "false"
        
        let field = app.secureTextFields[identifier]
        let exists_field = NSPredicate(format: "exists == \(doesExist)")
        expectation(for: exists_field, evaluatedWith:field, handler: nil)
        waitForExpectations(timeout: 5, handler: nil)
        
        if exists{
            field.tap()
            
            guard let textToEnter = text else { return }
            field.typeText(textToEnter)
        }
    }
    
    /**
     If existence of the label == true.
     Check label.text value. If does not exist only test for that state
     
     - parameter identifier: String
     - parameter text: String?
     - parameter exists: Bool
     - returns: none
     */
    @available(*, deprecated, message: "Use label(behavior:String, text:String?, identifier:String,exists:Bool) instead")
    public func label(text:String?,identifier:String,exists:Bool){
        
        let app = XCUIApplication()
        let doesExist = exists ? "true" : "false"
        let label = app.staticTexts[identifier]
        let exists_label = NSPredicate(format: "exists == \(doesExist)")
        expectation(for: exists_label, evaluatedWith:label, handler: nil)
        waitForExpectations(timeout: 5, handler: nil)
        
        if !exists { return }
        //IS STATUS CORRECTLY DISPLAYED
        XCTAssertNotNil(label)
        
        guard let textInLabel = text else { return }
        XCTAssertEqual(label.label, textInLabel)
    }
    
    /**
     If existence of the label == true.
     Check label.text contains string.
     
     - parameter identifier: String
     - parameter text: String
     - returns: none
     */
    @available(*, deprecated, message: "Use labelContains(behavior:String, text:String?, identifier:String) instead")
    public func labelContains(text:String,identifier:String){
        
        let app = XCUIApplication()
        let label = app.staticTexts[identifier]
        let exists_label = NSPredicate(format: "exists == true")
        expectation(for: exists_label, evaluatedWith:label, handler: nil)
        waitForExpectations(timeout: 5, handler: nil)
        
        
        //IS STATUS CORRECTLY DISPLAYED
        XCTAssertNotNil(label)
        XCTAssert(label.label.contains(text))
    }
    
    /**
     Check existence of view
     
     - parameter identifier: String
     - parameter exists: Bool
     - returns: none
     */
    @available(*, deprecated, message: "Use view(behavior:String, identifier:String , exists:Bool) instead")
    public func view(identifier:String,exists:Bool){
        
        let app = XCUIApplication()
        let doesExist = exists ? "true" : "false"
        let label = app.otherElements[identifier]
        let exists_view = NSPredicate(format: "exists == \(doesExist)")
        expectation(for: exists_view, evaluatedWith:label, handler: nil)
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    /**
     Check existence of UIAlertView.
     Check message text, check title text, check button text, tap button
     
     - parameter title: String
     - parameter message: String?
     - parameter button: String?
     - parameter tap: Bool
     - parameter exists: Bool
     - returns: none
     */
    @available(*, deprecated, message: "Use alert(behavior:String, title:String, message:String?,button:String?, tap:Bool, exists:Bool) instead")
    public func alert(title:String,message:String?,button:String?,tap:Bool,exists:Bool){
        
        let app = XCUIApplication()
        let doesExist = exists ? "true" : "false"
        let alert = app.alerts[title]
        let exists_alert = NSPredicate(format: "exists == \(doesExist)")
        expectation(for: exists_alert , evaluatedWith:alert , handler: nil)
        waitForExpectations(timeout: 2, handler: nil)
        
        if let msg = message {
            XCTAssert(app.alerts[title].staticTexts[msg].exists)
        }
        
        if let btn = button {
            XCTAssert(app.alerts[title].buttons[btn].exists)
        }
        
        if tap {
            if let btn = button {
                app.alerts[title].buttons[btn].tap()
            }else {
                XCTFail()
            }
        }
    }
    
    /**
     Check existence of UIButton.
     Tap button if indicated
     
     - parameter identifier: String
     - parameter tap: Bool
     - parameter exists: Bool
     - returns: none
     */
    @available(*, deprecated, message: "Use button(behavior:String, identifier:String,tap:Bool,exists:Bool) instead")
    public func button(identifier:String,tap:Bool,exists:Bool){
        
        let app = XCUIApplication()
        let doesExist = exists ? "true" : "false"
        let btn = app.buttons[identifier]
        let exists_btn = NSPredicate(format: "exists == \(doesExist)")
        expectation(for: exists_btn , evaluatedWith:btn , handler: nil)
        waitForExpectations(timeout: 5, handler: nil)
        
        if tap {
            btn.tap()
        }
    }
    
    /**
     Check existence of UIButton and whether button's label == text
     
     - parameter identifier: String
     - parameter text: String
     - returns: none
     */
    @available(*, deprecated, message: "Use buttonLabel(behavior:String, identifier:String,text:String) instead")
    public  func buttonLabel(identifier:String,text:String){
        
        let app = XCUIApplication()
        let btn = app.buttons[identifier]
        let exists_btn = NSPredicate(format: "exists == true")
        expectation(for: exists_btn , evaluatedWith:btn , handler: nil)
        waitForExpectations(timeout: 5, handler: nil)
        
        XCTAssertEqual(btn.label, text)
    }
    
    /**
     Check existence of UIStatus
     
     - parameter identifier: String
     - parameter text: String
     - returns: none
     */
    @available(*, deprecated, message: "Use buttonLabel(behavior:String, identifier:String,text:String) instead")
    public func statusBar(identifier:String,tap:Bool){
        
        let app = XCUIApplication()
        
        let btn = app.statusBars.buttons[identifier]
        let exists_btn = NSPredicate(format: "exists == true")
        expectation(for: exists_btn , evaluatedWith:btn , handler: nil)
        waitForExpectations(timeout: 5, handler: nil)
        
        if tap  {
            btn.tap()
        }
    }
    
    /**
     Check existence of UIActionSheet, check number of items in sheet if not nil,
     tap button of passed button title
     
     - parameter identifier: String
     - parameter text: String
     - returns: none
     */
    @available(*, deprecated, message: "Use sheet(behavior:String, title:String,message:String?,button:String?,tap:Bool,numberOfItems:UInt?) instead")
    public func sheet(title:String,message:String?,button:String?,tap:Bool,numberOfItems:UInt?){
        
        let app = XCUIApplication()
        
        //ARE THERE CHOICES AVAIL
        let sheet = app.sheets[title]
        let exists_sheet = NSPredicate(format: "exists == true")
        expectation(for: exists_sheet , evaluatedWith:sheet , handler: nil)
        waitForExpectations(timeout: 5, handler: nil)
        
        if let msg = message {
            XCTAssert(app.sheets[title].staticTexts[msg].exists)
        }
        
        if let num = numberOfItems {
            let sht = app.sheets
            XCTAssertEqual(sht.buttons.count, num)
        }
        
        if let btn = button {
            app.sheets[title].buttons[btn].tap()
        }
    }
    
    
    
    /**
     Look for cell in collection view based on label, tap cell
     
     - parameter cellLabel: String
     - parameter tap: Bool
     - returns: none
     */
    @available(*, deprecated, message: "Use collectionCell(behavior:String, cellLabel:String,tap:Bool) instead")
    public func collectionCell(cellLabel:String,tap:Bool){
        
        let app = XCUIApplication()
        let firstChild = app.collectionViews.children(matching:.any).element(boundBy: 0)
        if firstChild.exists {
            
            let cellLbl = app.collectionViews.children(matching:.any).staticTexts[cellLabel]
            let exists_cellLbl  = NSPredicate(format: "exists == true")
            expectation(for: exists_cellLbl  , evaluatedWith:cellLbl  , handler: nil)
            waitForExpectations(timeout: 5, handler: nil)
            
            if tap {
                firstChild.tap()
            }
        }
    }
    @available(*, deprecated, message: "Use collectionButton(behavior:String, buttonLabel:String,tap:Bool) instead")
    public func collectionButton(buttonLabel:String,tap:Bool){
        
        let app = XCUIApplication()
        let firstChild = app.collectionViews.children(matching:.any).element(boundBy: 0)
        
        if firstChild.exists {
            let cellLbl = firstChild.children(matching:.any).buttons[buttonLabel]
            let exists_cellLbl  = NSPredicate(format: "exists == true")
            expectation(for: exists_cellLbl  , evaluatedWith:cellLbl  , handler: nil)
            waitForExpectations(timeout: 5, handler: nil)
            
            if tap {
                cellLbl.tap()
            }
        }
    }
    
    
    /**
     Tap tab bar based on tab index
     
     - parameter tabIndex: UInt
     - returns: none
     */
    @available(*, deprecated, message: "Use tabBar(behavior:String, tabIndex:UInt) instead")
    public func tabBar(tabIndex:UInt){
        
        let tabBarsQuery = XCUIApplication().tabBars
        let button = tabBarsQuery.children(matching: .button).element(boundBy: tabIndex)
        button.tap()
    }
    
    /**
     Tap table cell based on IndexPath.row
     
     - parameter cellIndex: UInt
     - returns: none
     */
    @available(*, deprecated, message: "Use tableCellByIndex(behavior:String, cellIndex:UInt) instead")
    public func tableCellByIndex(cellIndex:UInt){
        let app = XCUIApplication()
        app.tables.children(matching: .any).element(boundBy:cellIndex).tap()
    }
    
    
    /**
     Tap table cell based on identifier (cell label text)
     
     - parameter text: String
     - returns: none
     */
    @available(*, deprecated, message: "Use tableCellByIdentifier(behavior:String, text:String,tap:Bool,exists:Bool) instead")
    public func tableCellByIdentifier(text:String,tap:Bool,exists:Bool){
        
        let app = XCUIApplication()
        let doesExist = exists ? "true" : "false"
        let label =  app.tables.staticTexts[text]
        let label_exists = NSPredicate(format: "exists == \(doesExist)")
        expectation(for: label_exists  , evaluatedWith:label , handler: nil)
        waitForExpectations(timeout: 5, handler: nil)
        
        if tap {
            label.tap()
        }
    }
    
    
    /**
     Look for nav bar with button, tap nav button
     
     - parameter indentifier: String
     - parameter tap: Bool
     - returns: none
     */
    @available(*, deprecated, message: "Use navBar(behavior:String, navIdentifier:String) instead")
    public func navBar(navIdentifier:String){
        let app = XCUIApplication()
        let bar = app.navigationBars[navIdentifier]
        let navBar_exists = NSPredicate(format: "exists == true")
        expectation(for: navBar_exists  , evaluatedWith:bar  , handler: nil)
        waitForExpectations(timeout: 5, handler: nil)
        
        bar.otherElements.children(matching: .button).element.tap()
    }
    
    
    @available(*, deprecated, message: "Use  alert(title:String,message:String?,button:String?,tap:Bool,exists:Bool)")
    public func alert(title:String,message:String?,button:String?,tap:Bool){
        
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
        
        if tap {
            if let btn = button {
                app.alerts[title].buttons[btn].tap()
            }else {
                XCTFail()
            }
        }
    }
    
    
    @available(*, deprecated, message: "Use  collectionCell(cellLabel:String,tap:Bool)")
    public  func collectionCellLabelExists(cellLabel:String,exists:String){
        
        let app = XCUIApplication()
        let firstChild = app.collectionViews.children(matching:.any).element(boundBy: 0)
        if firstChild.exists {
            
            let cellLbl = app.collectionViews.children(matching:.any).staticTexts[cellLabel]
            let exists_cellLbl  = NSPredicate(format: "exists == \(exists)")
            expectation(for: exists_cellLbl  , evaluatedWith:cellLbl  , handler: nil)
            waitForExpectations(timeout: 5, handler: nil)
        }
    }
    
    @available(*, deprecated, message: "Use  collectionCell(cellLabel:String,tap:Bool)")
    public func collectionWithLabel(cellLabel:String,tap:Bool){
        
        let app = XCUIApplication()
        let firstChild = app.collectionViews[cellLabel].children(matching:.any).element(boundBy: 0)
        if firstChild.exists {
            if tap {
                firstChild.tap()
            }
        }else{
            XCTFail()
        }
    }
    
    @available(*, deprecated, message: "Use  alert(title:String,message:String?,button:String?,tap:Bool,exists:Bool) instead")
    public func alertFalse(title:String){
        let app = XCUIApplication()
        
        let alert = app.alerts[title]
        let exists_alert = NSPredicate(format: "exists == false")
        expectation(for: exists_alert , evaluatedWith:alert , handler: nil)
        waitForExpectations(timeout: 2, handler: nil)
        
    }
    
    @available(*, deprecated, message: "Use textfield(identifier:String,text:String?,exists:Bool) instead")
    public  func tableCellByIdentifierDoesNotExist(text:String){
        
        let app = XCUIApplication()
        let label =  app.tables.staticTexts[text]
        let label_exists = NSPredicate(format: "exists == false")
        expectation(for: label_exists  , evaluatedWith:label , handler: nil)
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    @available(*, deprecated, message: "Use textfield(identifier:String,text:String?,exists:Bool) instead")
    public func textfield(identifier:String,text:String){
        
        let app = XCUIApplication()
        
        let field = app.textFields[identifier]
        let exists_field = NSPredicate(format: "exists == true")
        expectation(for: exists_field, evaluatedWith:field, handler: nil)
        waitForExpectations(timeout: 5, handler: nil)
        
        field.tap()
        field.typeText(text)
        
    }
    
    @available(*, deprecated, message: "Use secureTextfield(identifier:String,text:String?,exists:Bool) instead")
    public func secureTextfield(identifier:String,text:String){
        
        let app = XCUIApplication()
        
        let field = app.secureTextFields[identifier]
        let exists_field = NSPredicate(format: "exists == true")
        expectation(for: exists_field, evaluatedWith:field, handler: nil)
        waitForExpectations(timeout: 5, handler: nil)
        
        field.tap()
        field.typeText(text)
        
    }
    
    //TEST LABEL
    @available(*, deprecated, message: "Use label(text:String?,identifier:String,exists:Bool) instead")
    public func label(text:String,identifier:String){
        
        let app = XCUIApplication()
        
        let label = app.staticTexts[identifier]
        let exists_label = NSPredicate(format: "exists == true")
        expectation(for: exists_label, evaluatedWith:label, handler: nil)
        waitForExpectations(timeout: 5, handler: nil)
        
        //IS STATUS CORRECTLY DISPLAYED
        XCTAssertNotNil(label)
        XCTAssertEqual(label.label, text)
    }
    
    @available(*, deprecated, message: "Use view(identifier:String,exists:Bool) instead")
    public func view(exists:String,identifier:String){
        
        let app = XCUIApplication()
        let label = app.otherElements[identifier]
        let exists_view = NSPredicate(format: "exists == \(exists)")
        expectation(for: exists_view, evaluatedWith:label, handler: nil)
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    @available(*, deprecated, message: "Use alert(title:String,message:String?,button:String?,tap:Bool,exists:Bool) instead")
    public func alert(title:String,message:String?,button:String?,tap:Bool?){
        
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
    
    @available(*, deprecated, message: "Use button(identifier:String,tap:Bool,exists:Bool) instead")
    public func button(identifier:String,tap:Bool?,exists:String){
        
        let app = XCUIApplication()
        
        let btn = app.buttons[identifier]
        let exists_btn = NSPredicate(format: "exists == \(exists)")
        expectation(for: exists_btn , evaluatedWith:btn , handler: nil)
        waitForExpectations(timeout: 5, handler: nil)
        
        if tap != nil {
            btn.tap()
        }
    }
    
    @available(*, deprecated, message: "Use label(text:String?,identifier:String,exists:Bool) instead")
    public func statusBar(identifier:String,tap:Bool?){
        
        let app = XCUIApplication()
        
        let btn = app.statusBars.buttons[identifier]
        let exists_btn = NSPredicate(format: "exists == true")
        expectation(for: exists_btn , evaluatedWith:btn , handler: nil)
        waitForExpectations(timeout: 5, handler: nil)
        
        if tap != nil {
            btn.tap()
        }
    }
    
    @available(*, deprecated, message: "Use statusBar(identifier:String,tap:Bool) instead")
    public func sheet(title:String,tap:Bool?,numberOfItems:UInt?){
        
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
    
    @available(*, deprecated, message: "Use collectionWithLabel(cellLabel:String,tap:Bool) instead")
    public func collectionWithLabel(cellLabel:String,tap:Bool?){
        
        let app = XCUIApplication()
        let firstChild = app.collectionViews[cellLabel].children(matching:.any).element(boundBy: 0)
        if firstChild.exists {
            
            if tap != nil {
                firstChild.tap()
            }
        }
    }
    
    @available(*, deprecated, message: "Use collectionCell(cellLabel:String,labelString:String?,tap:Bool) instead")
    public func collectionCell(cellLabel:String,labelString:String?,tap:Bool?){
        
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
    
    
    @available(*, deprecated, message: "Use collectionButton(buttonLabel:String,tap:Bool) instead")
    public  func collectionButton(buttonLabel:String,tap:Bool?){
        
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
}
