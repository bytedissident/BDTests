//
//  BDTestsUITestsUITests.swift
//  BDTestsUITestsUITests
//
//  Created by Derek Bronston on 5/22/17.
//  Copyright © 2017 Derek Bronston. All rights reserved.
//

import XCTest
class BDTestsUITestsUITests: BDTestsUI {
    
    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        XCUIApplication().launch()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testTextfield_exists_typeText() {
        
        tabBar(behavior: "Tap tab 1", tabIndex: 1)
        
        //EXISTS, ENTER TEXT
        textfield(behavior:"We should see the string text",identifier: "test-text-field", text: "text",exists: true)
    }
    
    func testTextField_doesNotExist(){
        
        tabBar(behavior: "Tap tab 1", tabIndex: 1)
        textfield(behavior:"We should see the string text",identifier: "no-test-text-field", text: "text",exists: false)
    }
    
    func testSecureTextfield_exists_typeText() {
        
        tabBar(behavior: "Tap tab 1", tabIndex: 1)
        //EXISTS, ENTER TEXT
        secureTextfield(behavior:"We should see the string text",identifier: "test-secure-text-field", text: "text",exists: true)
    }
    
    func testSecureTextField_doesNotExist(){
        
        tabBar(behavior: "Tap tab 1", tabIndex: 1)
        secureTextfield(behavior: "Tap tab 2",identifier: "no-test-text-field", text: "text",exists: false)
    }
    
    func testLabel_exists_accessoryLabelHasCorrectText(){
        tabBar(behavior: "Tap tab 1", tabIndex: 1)
        label(behavior: "Tap tab 2",text: "test-label", identifier: "test-label", exists: true)
    }
    
    func testLabel_doesNotExist(){
        tabBar(behavior: "Tap tab 1", tabIndex: 1)
        label(behavior: "Tap tab 2",text: nil, identifier: "label-does-not-exist", exists: false)
    }
    
    func testLabelContains_accessoryContainsText(){
        tabBar(behavior: "Tap tab 1", tabIndex: 1)
        labelContains(behavior: "Tap tab 2",text: "test-", identifier: "test-label")
    }
    
    func testView_exists(){
        tabBar(behavior: "Tap tab 1", tabIndex: 1)
        view(behavior: "Tap tab 2",identifier: "blue-view", exists: true)
    }
    
    func testView_doesNotExist(){
       tabBar(behavior: "Tap tab 1", tabIndex: 1)
        view(behavior: "Tap tab 2",identifier: "blue-view-does-not-exist", exists: false)
    }
    
    func testButton_doesNotExist(){
        tabBar(behavior: "Tap tab 1", tabIndex: 1)
        button(behavior: "Tap tab 2",identifier: "test-button-no", tap: false, exists: false)
    }
    
    func testButton_exists_tap(){
        tabBar(behavior: "Tap tab 1", tabIndex: 1)
        button(behavior: "Tap tab 2",identifier: "test-button", tap: true, exists: true)
        label(behavior: "Tap tab 2",text: "test-value", identifier: "test-value", exists: true)
    }
    
    func testButtonLabel(){
        tabBar(behavior: "Tap tab 1", tabIndex: 1)
        buttonLabel(behavior: "Tap tab 2",identifier: "test-button", text: "test-button")
    }
    
    func testAlert(){
        tabBar(behavior: "Tap tab 1", tabIndex: 1)
        button(behavior: "Tap tab 2",identifier: "button-alert-trigger", tap: true, exists: true)
        
        alert( title: "Alert Title", message: "Alert message.", button: "one", tap: true)
        
        label(behavior: "Tap tab 2",text: "One Pressed", identifier: "One Pressed", exists: true)
    }
    
    func testSheet(){
        tabBar(behavior: "Tap tab 1", tabIndex: 1)
        button(behavior: "Tap tab 2",identifier: "test-button-sheet-trigger", tap: true, exists: true)
        
        sheet(behavior: "Tap tab 2",title: "Sheet Title", message: "Sheet message.", button: "one", tap: true, numberOfItems: 2)
        
        label(behavior: "Tap tab 2",text: "One Pressed", identifier: "One Pressed", exists: true)
    }
    
    func testTableCellByIndex(){
        
        tabBar(behavior: "Tap tab 2",tabIndex: 2)
        
        tableCellByIndex(behavior: "Tap tab 2",cellIndex: 1)
        
        alert( title: "Alert Title", message: "Alert message.", button: "one", tap: false)
    }
    
    func testTableCellByIdentifier_exists(){
        
        tabBar(behavior: "Tap tab 2",tabIndex: 2)
        
        tableCellByIdentifier(behavior: "Tap cell 0",text: "cell 0", tap: true, exists: true)
        
        alert(title: "Alert Title", message: "Alert message.", button: "one", tap: false)
    }
    
    func testTableCellByIdentifier_doesNotExist(){
        
        tabBar(behavior: "Tap tab 2",tabIndex: 2)
        
        tableCellByIdentifier(behavior: "Tap cell 0",text: "cell 0 - does not exist", tap: false, exists:false)
    }
    
    func testCollectionCell(){
        
        tabBar(behavior: "Tap tab 3",tabIndex: 3)
        collectionCell(behavior: "We should see this in the collection cell",cellLabel: "Test", tap:false)
    }
}
