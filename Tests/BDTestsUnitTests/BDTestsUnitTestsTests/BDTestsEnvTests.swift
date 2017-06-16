//
//  BDTestsEnvTests.swift
//  BDTestsUnitTests
//
//  Created by Derek Bronston on 5/22/17.
//  Copyright © 2017 Derek Bronston. All rights reserved.
//

import XCTest
@testable import BDTestsUnitTests

class BDTestsEnvTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
  
    func testTestEnv_isNetworkTestTrue(){
        
        //SET UP
        
        let test = BDTests(enviornmentName: nil)
        test.removeTest()
        test.removeModelTest()
        _ = test.createTest(jsonString: "{\"key\":\"value\"}", jsonFile: nil, httpCode: 200)
        
        
        let sut = BDTestsEnv()
        let envCheck = sut.testEnv()
        
        XCTAssert(envCheck.networkTest)
        XCTAssertFalse(envCheck.modelTest)
    }
    
    func testTestEnv_isModelTestTrue_selectorDoesNotExist(){
        
        //SET UP
        
        let test = BDTests(enviornmentName: nil)
        test.removeTest()
        test.removeModelTest()
        _ = test.seedDatabase(ref: "testMe-method_does_not_exist")
        
        
        let sut = BDTestsEnv()
        let envCheck = sut.testEnv()
        
        XCTAssertFalse(envCheck.networkTest)
        XCTAssert(envCheck.modelTest)
    }
    
    func testTestEnv_isModelTestTrue_selectorDoesExist(){
        
        //SET UP
        
        let test = BDTests(enviornmentName: nil)
        test.removeTest()
        test.removeModelTest()
        _ = test.seedDatabase(ref: "testMethod")
        
        
        let sut = BDTestsEnv()
        let envCheck = sut.testEnv()
        
        XCTAssertFalse(envCheck.networkTest)
        XCTAssert(envCheck.modelTest)
    }

}
