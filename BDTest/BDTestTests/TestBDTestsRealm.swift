//
//  TestBDTestsRealm.swift
//  BDTest
//
//  Created by Derek Bronston on 2/17/17.
//  Copyright © 2017 Derek Bronston. All rights reserved.
//

import XCTest
import RealmSwift

@testable import BDTest

class TestBDTestsRealm: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testMapAndSaveObject(){
    
        //guard let realm = BDTestsRealm().setUpRealm() else { return }
       //let testObjects = realm.objects(BDTestRealmObject.self)
        //XCTAssertEqual(testObjects.count, 0)
        
        let realmTests = BDTestsRealm()
        //realmTests["test-object"] = BDTestRealmObject()
        
        let json = ["name":"test"]
        realmTests.mapAndSaveObject(data: json, obj: BDTestRealmObject(),update:false)
        
        guard let realm = BDTestsRealm().setUpRealm() else { XCTFail(); return }
        let testObjects = realm.objects(BDTestRealmObject.self).last
        XCTAssertEqual(testObjects?.name, "test")
    }
    
    func testJSONTORealm(){
    
        BDTestsRealm().deleteAll()
        let realmTests = BDTestsRealm()
        //realmTests["test-object"] = BDTestRealmObject()
        
        let json = "{\"name\":\"test json\"}"
        let toRealm = realmTests.jsonToRealm(json: json, obj: BDTestRealmObject(),update:false)
        XCTAssert(toRealm)
        guard let realm = BDTestsRealm().setUpRealm() else { XCTFail(); return }
        let testObjects = realm.objects(BDTestRealmObject.self).last
        XCTAssertEqual(testObjects?.name, "test json")
    }
}
