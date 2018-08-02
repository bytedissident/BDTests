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
    var sutTable:TableController!
    var sutCollection:CollectionController!
    var sutTab:UITabBarController!
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func setUp(type:BDElementType){
        switch type {
            case .button:
                setUpControllerForButton()
                return
            case .table:
                setUpControllerForTable()
                return
            case .tabbar:
                setUpControllerForTabBar()
                return
            case .collection:
                setUpControllerForCollection()
                return
        }
    }
    
    func setUpControllerForButton(){
        let story = UIStoryboard(name: "Main", bundle: nil)
        sut = story.instantiateViewController(withIdentifier: "MainView") as! MainController
        sut.loadView()
        sut.viewDidLoad()
    }
    
    func setUpControllerForTable(){
        let story = UIStoryboard(name: "Main", bundle: nil)
        sutTable = story.instantiateViewController(withIdentifier: "Table") as! TableController
        sutTable.loadView()
        sutTable.viewDidLoad()
    }
    
    func setUpControllerForCollection(){
        let story = UIStoryboard(name: "Main", bundle: nil)
        sutCollection = story.instantiateViewController(withIdentifier: "Collection") as! CollectionController
        sutCollection.loadView()
        sutCollection.viewDidLoad()
    }
    
    func setUpControllerForTabBar(){
        sutTab = UITabBarController()
        sutTab.viewControllers = [UIViewController(),UIViewController()]
    }
    
    //MARK: BUTTON
    func testGivenTheUser_successfullyExecutesTestOnAButtonOutlet(){
        
        setUp(type: .button)
        
        //TEST
        let button = BDButton(outlet: sut.testButton, identifier: nil, action: .touchUpInside, parent: nil)
        let bdUIElement = BDUIElement(type: .button, element: ["button":button])
        let executed = sut.givenTheUser(doesThis: "Presses the Test Button", withThis: bdUIElement, weExpect: "To see test-value in the label", letsVerify: {
            XCTAssertEqual(self.sut.testLabel.text, "test-value")
        }, orDoSomethingElse: {})
        XCTAssert(executed)
    }
    
    func testGivenTheUser_failsToExecutesTestOnAButtonOutlet_badKey(){
        setUp(type: .button)
        //TEST
        let button = BDButton(outlet: sut.testButton, identifier: nil, action: .touchUpInside, parent: nil)
        let bdUIElement = BDUIElement(type: .button, element: ["btn":button])
        let executed = sut.givenTheUser(doesThis: "Presses the Test Button", withThis: bdUIElement, weExpect: "To see test-value in the label", letsVerify: {
            XCTFail()
        }, orDoSomethingElse: {})
        XCTAssertFalse(executed)
    }
    
    func testGivenTheUser_failsToExecutesTest_noOutlet_noIdentifier(){
        setUp(type: .button)
        //TEST
        let button = BDButton(outlet: nil, identifier: nil, action: .touchUpInside, parent: nil)
        let bdUIElement = BDUIElement(type: .button, element: ["button":button])
        let executed = sut.givenTheUser(doesThis: "Presses the Test Button", withThis: bdUIElement, weExpect: "To see test-value in the label", letsVerify: {
            XCTFail()
        }, orDoSomethingElse: {})
        XCTAssertFalse(executed)
    }
    
    func testGivenTheUser_failsToExecutesTestButtonWithIdentifier_noParent(){
        setUp(type: .button)
        //TEST
        let button = BDButton(outlet: nil, identifier: nil, action: .touchUpInside, parent: nil)
        let bdUIElement = BDUIElement(type: .button, element: ["button":button])
        let executed = sut.givenTheUser(doesThis: "Presses the Test Button", withThis: bdUIElement, weExpect: "To see test-value in the label", letsVerify: {
            XCTFail()
        }, orDoSomethingElse: {})
        XCTAssertFalse(executed)
    }
    
    func testGivenTheUser_successfullyExecutesTestOnAButtonWithAnIdentifier(){
        setUp(type: .button)
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
    
    func testGivenTheUser_successfullyExecutesTestOnANestedButtonWithAnIdentifier(){
        setUp(type: .button)
        //SET UP
        let subview = UIView()
        let subview2 = UIView()
        let buttonWithID = UIButton()
        buttonWithID.accessibilityIdentifier = "test-button-id"
        buttonWithID.addTarget(sut, action: #selector(sut.testButtonAction), for: .touchUpInside)
        subview2.addSubview(buttonWithID)
        subview.addSubview(subview2)
        sut.view.addSubview(subview)
        
        //TEST
        let button = BDButton(outlet: nil, identifier: "test-button-id", action: .touchUpInside, parent: sut.view)
        let bdUIElement = BDUIElement(type: .button, element: ["button":button])
        let executed = sut.givenTheUser(doesThis: "Presses the Button", withThis: bdUIElement, weExpect: "To see test-value in the label", letsVerify: {
            XCTAssertEqual(self.sut.testLabel.text, "test-value")
        }, orDoSomethingElse: {})
        XCTAssert(executed)
    }
    
    func testGivenTheUser_failsToExecutesTestNestedButtonWithIdentifier_noSubviews(){
        setUp(type: .button)
        //TEST
        let v = UIView()
        let button = BDButton(outlet: nil, identifier: "test", action: .touchUpInside, parent: v)
        let bdUIElement = BDUIElement(type: .button, element: ["button":button])
        let executed = sut.givenTheUser(doesThis: "Presses the Test Button", withThis: bdUIElement, weExpect: "To see test-value in the label", letsVerify: {
            XCTFail()
        }, orDoSomethingElse: {})
        XCTAssertFalse(executed)
    }
    
    //MARK: TABLE
    func testGivenTheUser_successfullyExecutesTestOnATableOutlet(){
        setUp(type: .table)
        
        //TEST
        let indexPath = IndexPath(row: 0, section: 0)

        let table = BDTable(outlet: sutTable.tView, indexPath: indexPath, select: true)
        let bdUIElement = BDUIElement(type: .table, element: ["table":table])
        let executed = sutTable.givenTheUser(doesThis: "Presses the cell at row 0, section 0", withThis: bdUIElement, weExpect: "To see Test Value printed to the label", letsVerify: {
            XCTAssertEqual(self.sutTable.testLabel.text,"Test Value")
            
        }, orDoSomethingElse: {})
        XCTAssert(executed)
    }
    
    func testGivenTheUser_failesToExecuteTestOnATableOutlet_badKey(){
        setUp(type: .table)
        
        //TEST
        let indexPath = IndexPath(row: 0, section: 0)
        
        let table = BDTable(outlet: sutTable.tView, indexPath: indexPath, select: true)
        let bdUIElement = BDUIElement(type: .table, element: ["t-ble":table])
        let executed = sutTable.givenTheUser(doesThis: "Presses the cell at row 0, section 0", withThis: bdUIElement, weExpect: "To see a system alert", letsVerify: {
            XCTFail()
            
        }, orDoSomethingElse: {})
        XCTAssertFalse(executed)
    }
    
    func testGivenTheUser_failesToExecuteTestOnATableOutlet_noSelect(){
        setUp(type: .table)
        
        //TEST
        let indexPath = IndexPath(row: 0, section: 0)
        
        let table = BDTable(outlet: sutTable.tView, indexPath: indexPath, select: false)
        let bdUIElement = BDUIElement(type: .table, element: ["table":table])
        let executed = sutTable.givenTheUser(doesThis: "Presses the cell at row 0, section 0", withThis: bdUIElement, weExpect: "To see a system alert", letsVerify: {
            XCTFail()
            
        }, orDoSomethingElse: {})
        XCTAssertFalse(executed)
    }
    
    //MARK: Collection
    func testGivenTheUser_successfullyExecutesTestOnACollectionOutlet(){
        setUp(type: .collection)
        
        //TEST
        let indexPath = IndexPath(row: 0, section: 0)
        let collection = BDCollection(outlet: sutCollection.collection, indexPath: indexPath, select: true)
        let bdUIElement = BDUIElement(type: .collection, element: ["collection":collection])
        let executed = sutCollection.givenTheUser(doesThis: "Presses the cell at row 0, section 0", withThis: bdUIElement, weExpect: "To see Test Value printed to the label", letsVerify: {
            XCTAssertEqual(self.sutCollection.testLabel.text,"Test Value")
            
        }, orDoSomethingElse: {})
        XCTAssert(executed)
    }

    func testGivenTheUser_failedToExecuteTestOnACollectionOutlet_badKey(){
        setUp(type: .collection)
        
        //TEST
        let indexPath = IndexPath(row: 0, section: 0)
        let collection = BDCollection(outlet: sutCollection.collection, indexPath: indexPath, select: true)
        let bdUIElement = BDUIElement(type: .collection, element: ["c-llection":collection])
        let executed = sutCollection.givenTheUser(doesThis: "Presses the cell at row 0, section 0", withThis: bdUIElement, weExpect: "To see a system alert", letsVerify: {
           XCTFail()
            
        }, orDoSomethingElse: {})
        XCTAssertFalse(executed)
    }
    
    func testGivenTheUser_failedToExecuteTestOnACollectionOutlet_noSelect(){
        setUp(type: .collection)
        
        //TEST
        let indexPath = IndexPath(row: 0, section: 0)
        let collection = BDCollection(outlet: sutCollection.collection, indexPath: indexPath, select: false)
        let bdUIElement = BDUIElement(type: .collection, element: ["collection":collection])
        let executed = sutCollection.givenTheUser(doesThis: "Presses the cell at row 0, section 0", withThis: bdUIElement, weExpect: "To see a system alert", letsVerify: {
            XCTFail()
            
        }, orDoSomethingElse: {})
        XCTAssertFalse(executed)
    }
    
    //MARK: TabBar
    func testGivenTheUser_successfullyExecutesTestOnATabBar(){
        setUp(type: .tabbar)
        
        //TEST
        let index = sutTab.selectedIndex
        XCTAssertEqual(index, 0)
        let tab = BDTabBar(index: 1, outlet: sutTab)
        let bdUIElement = BDUIElement(type: .tabbar, element: ["tabbar":tab])
        let executed = sutTab.givenTheUser(doesThis: "Presses the cell at row 0, section 0", withThis: bdUIElement, weExpect: "To see Test Value printed to the label", letsVerify: {
            XCTAssertEqual(self.sutTab.selectedIndex,1)
        }, orDoSomethingElse: {})
        XCTAssert(executed)
    }
}
