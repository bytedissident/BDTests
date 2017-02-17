//
//  BDTestTests.swift
//  BDTestTests
//
//  Created by Derek Bronston on 2/16/17.
//  Copyright © 2017 Derek Bronston. All rights reserved.
//

import XCTest
import Alamofire

@testable import BDTest

class BDTestTests: XCTestCase {
    
    var sut:BDTestsMain!
    override func setUp() {
        super.setUp()
        self.sut = BDTestsMain(enviornmentName: nil)
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        self.sut = nil
        super.tearDown()
    }
    
    func testSetClipboard(){
        
        let paste = sut.setClipboard(json: "{\"key\":\"value\"}")
        XCTAssert(paste)
        
        let  readPaste = UIPasteboard(name: UIPasteboardName(rawValue: sut.enviornmentName), create: false)
        if let myString = readPaste?.string {
           XCTAssertEqual(myString, "{\"key\":\"value\"}")
        }else{
            XCTFail()
        }
    }
    
    func testReadClipboard(){
        
        //SET UP
        let paste = sut.setClipboard(json: "{\"key\":\"value\"}")
        XCTAssert(paste)
        
        let  readPaste = UIPasteboard(name: UIPasteboardName(rawValue: sut.enviornmentName), create: false)
        if let myString = readPaste?.string {
            XCTAssertEqual(myString, "{\"key\":\"value\"}")
        }else{
            XCTFail()
        }
        
        //TEST
        let read = sut.readClipboard()
        if let clippedText = read {
            XCTAssertEqual(clippedText, "{\"key\":\"value\"}")
        }else{
            XCTFail()
        }
    }
    
    func testConvertToDictionary(){
        
        //SET UP
        _ = sut.setClipboard(json: "{\"key\":\"value\"}")
        let paste = sut.readClipboard()
        guard let parsedString = paste else { XCTFail(); return }
        
        //TEST
        let dict = sut.convertToDictionary(text: parsedString)
        XCTAssertEqual(dict?["key"] as! String,"value")
     }
    
    func testCreateTest_json_string(){
        
        let test = sut.createTest(jsonString: "{\"key\":\"value\"}" , jsonFile: nil, httpCode: 400)
        XCTAssert(test)
        
        let read = sut.readClipboard()
        if let clippedText = read {
            XCTAssertEqual(clippedText, "{\"code\":400,\"data\":{\"key\":\"value\"}}")
        }else{
            XCTFail()
        }
        
        XCTAssertEqual(sut.httpResponseCode, 400)
    }
    
    func testCreateTest_json_file(){
        
        let test = sut.createTest(jsonString:nil , jsonFile:"test_data", httpCode: 400)
        XCTAssert(test)
        
        let read = sut.readClipboard()
        if let clippedText = read {
            XCTAssert(clippedText.trimmingCharacters(in: .whitespacesAndNewlines).contains("\"data\":data"))
        }else{
            XCTFail()
        }
        
        XCTAssertEqual(sut.httpResponseCode, 400)
    }
    
    func testIsTest_false(){
        //SET UP
        UIPasteboard.remove(withName: UIPasteboardName(rawValue: sut.enviornmentName))
        XCTAssertFalse(sut.isTest())
    
        
    }
    
    func testIsTest_true(){
        //SET UP
        UIPasteboard.remove(withName: UIPasteboardName(rawValue: sut.enviornmentName))
        XCTAssertFalse(sut.isTest())
        
        //TEST
        _ = sut.createTest(jsonString: "value", jsonFile: nil, httpCode: 400)
        XCTAssert(sut.isTest())

    }
    
    func testRunTests_network(){
        
        let test = sut.createTest(jsonString: "{\"key\":\"value\"}" , jsonFile: nil, httpCode: 200)
        XCTAssert(test)
        
        let run = sut.runTests()
        XCTAssert(run)

    }
    
    func testDetermineResponseText_string(){
        
        _ = sut.createTest(jsonString: "{}" , jsonFile: nil, httpCode: 400)
        let clip = sut.readClipboard()
        let dict = sut.convertToDictionary(text: clip!)
        let responseText = sut.determineResponseText(dict: dict!)
        
        XCTAssertEqual(responseText?.trimmingCharacters(in: .whitespacesAndNewlines), "{\n\n}")
    }
    
    func testDetermineResponseText_file(){
        
        _ = sut.createTest(jsonString: nil , jsonFile: "test_local_json", httpCode: 400)
        guard let clip = sut.readClipboard() else { XCTFail(); return }
        guard let dict = sut.convertToDictionary(text: clip) else { XCTFail(); return}
        let responseText = sut.determineResponseText(dict: dict)
        
        XCTAssertEqual(responseText?.trimmingCharacters(in: .whitespacesAndNewlines), "{\"key\":\"value\"}")
    }
    
    
    
    func testSeedDatabase(){
        
        let json = "{\"key\":\"value\"}"
        let modelData = sut.seedDatabase(json: json)
        XCTAssert(modelData)
        
        let  readPaste = UIPasteboard(name: UIPasteboardName(rawValue: sut.enviornmentName+"-model"), create: false)
        if let myString = readPaste?.string {
            XCTAssertEqual(myString, "{\"key\":\"value\"}")
        }else{
            XCTFail()
        }
    }
    
    func testReadDatabaseData(){
        
        let json = "{\"key\":\"value\"}"
        let modelData = sut.seedDatabase(json: json)
        XCTAssert(modelData)
        
        guard let  db = sut.readDatabaseData() else { XCTFail(); return }
        XCTAssertEqual(db["key"] as? String, "value")
    }
    
    func testIsModelTest_false(){
        //SET UP
        UIPasteboard.remove(withName: UIPasteboardName(rawValue: sut.enviornmentName+"-model"))
        XCTAssertFalse(sut.isModelTest())
    }
    
    func testIsModelTest_true(){
        //SET UP
        UIPasteboard.remove(withName: UIPasteboardName(rawValue: sut.enviornmentName+"-model"))
        XCTAssertFalse(sut.isModelTest())
        
        //TEST
        _ = sut.seedDatabase(json: "test-data")
        XCTAssert(sut.isModelTest())
    }
}
