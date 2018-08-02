//
//  BDTestsBDDTests.swift
//  BDTestsUnitTestsTests
//
//  Created by Derek Bronston on 8/2/18.
//  Copyright © 2018 Derek Bronston. All rights reserved.
//
import XCTest
@testable import BDTestsUnitTests

class BDTestsBDDTests: XCTestCase {
    
    var sut:MainController!
    
    override func setUp() {
        super.setUp()
        
        let story = UIStoryboard(name: "Main", bundle: nil)
        sut = story.instantiateViewController(withIdentifier: "MainView") as! MainController
        sut.loadView()
        sut.viewDidLoad()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testGivenTheUser_failsToExecute(){
    
        //TEST
        let bdUIElement = BDUIElement(type: .button, element: ["":0])
        let executed = sut.givenTheUser(doesThis: "Tries to do something", withThis: bdUIElement, weExpect: "this to fail", letsVerify: {}, orDoSomethingElse: {})
        XCTAssertFalse(executed)
    }
    
    func testGivenTheUser_successfullyExecutesTestOnAButtonOutlet(){
        
        //TEST
        let button = BDButton(outlet: sut.testButton, identifier: nil, action: .touchUpInside, parent: nil)
        let bdUIElement = BDUIElement(type: .button, element: ["button":button])
        let executed = sut.givenTheUser(doesThis: "Presses the Test Button", withThis: bdUIElement, weExpect: "To see test-value in the label", letsVerify: {
            XCTAssertEqual(self.sut.testLabel.text, "test-value")
        }, orDoSomethingElse: {})
        XCTAssert(executed)
    }
    
    func testGivenTheUser_successfullyExecutesTestOnAButtonWithAnIdentifier(){
        
        //SET UP
        let buttonWithID = UIButton()
        buttonWithID.accessibilityIdentifier = "test-button-id"
        buttonWithID.addTarget(sut, action: #selector(sut.testButtonAction), for: .touchUpInside)
        sut.view.addSubview(buttonWithID)
        
        //TEST
        let button = BDButton(outlet: nil, identifier: "test-button-id", action: .touchUpInside, parent: sut.view)
        let bdUIElement = BDUIElement(type: .button, element: ["button":button])
        let executed = sut.givenTheUser(doesThis: "Presses the Button", withThis: bdUIElement, weExpect: "To see test-value in the label", letsVerify: {
            XCTAssertEqual(self.sut.testLabel.text, "test-value")
        }, orDoSomethingElse: {})
        XCTAssert(executed)
    }
}
