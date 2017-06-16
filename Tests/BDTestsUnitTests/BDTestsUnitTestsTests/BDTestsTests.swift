//
//  BDTestTests.swift
//  BDTestTests
//
//  Created by Derek Bronston on 2/16/17.
//  Copyright © 2017 Derek Bronston. All rights reserved.
//

import XCTest
@testable import BDTestsUnitTests

class BDTestsTests: XCTestCase {
    
    var sut:BDTests!
    override func setUp() {
        super.setUp()
        
         self.sut = BDTests(enviornmentName: nil)
    
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        
        self.sut = nil
        super.tearDown()
    }
    
    func testCreateTest_jsonString(){
        
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
    
    func testCreateTest_jsonString_multipleStubs(){
        
        //TEST 1
        let test = sut.createTest(jsonString: "{\"key\":\"value\"}" , jsonFile: nil, httpCode: 400)
        XCTAssert(test)
        
        let read = sut.readClipboard()
        if let clippedText = read {
            XCTAssertEqual(clippedText, "{\"code\":400,\"data\":{\"key\":\"value\"}}")
        }else{
            XCTFail()
        }
        
        XCTAssertEqual(sut.httpResponseCode, 400)
        
        //TEST 2
        sut.enviornmentName = "test-2"
        let test2 = sut.createTest(jsonString: "{\"key2\":\"value2\"}" , jsonFile: nil, httpCode: 200)
        XCTAssert(test2)
        
        let read2 = sut.readClipboard()
        if let clippedText2 = read2 {
            XCTAssertEqual(clippedText2, "{\"code\":200,\"data\":{\"key2\":\"value2\"}}")
        }else{
            XCTFail()
        }
        XCTAssertEqual(sut.httpResponseCode, 200)
    }

    
    func testCreateTest_jsonFile(){
        
        let test = sut.createTest(jsonString:nil , jsonFile:"test_data", httpCode: 400)
        XCTAssert(test)
        
        let read = sut.readClipboard()
        if let clippedText = read {
            XCTAssertEqual(clippedText, "{\"code\":400,\"data-file\":\"test_data\"}")
        }else{
            XCTFail()
        }
        
        XCTAssertEqual(sut.httpResponseCode, 400)
    }
    
    func testSeedDatabase(){
        
        //CLEAR
        let paste = UIPasteboard(name: UIPasteboardName(rawValue: sut.enviornmentName+"-model"), create: true)
        paste?.string = ""
        
       let seeded =  sut.seedDatabase(ref: "JSON-STRING")
        XCTAssert(seeded)
        
        let read = UIPasteboard(name: UIPasteboardName(rawValue: sut.enviornmentName+"-model"), create: true)
         XCTAssertEqual(read?.string, "JSON-STRING")
        //sut.se
    }
    
    func testReadDatabase(){
        
        //CLEAR
        let paste = UIPasteboard(name: UIPasteboardName(rawValue: sut.enviornmentName+"-model"), create: true)
        paste?.string = ""
        
        let seeded =  sut.seedDatabase(ref: "{\"key\":\"value\"}")
        XCTAssert(seeded)
        
        _ = sut.readDatabaseData()
       // XCTAssertEqual(read?["key"] as! String, "value")
        //sut.se
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
        //CLIPBOARD SHOULD BE CLEAR AFTER READ
        let readAgain = sut.readClipboard()
        XCTAssertNil(readAgain)
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
    
    
    
    func testSeedDatabase_(){
        
        let json = "{\"key\":\"value\"}"
        let modelData = sut.seedDatabase(ref: json)
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
        let modelData = sut.seedDatabase(ref: json)
        XCTAssert(modelData)
        
        guard let  db = sut.readDatabaseData() else { XCTFail(); return }
        XCTAssertEqual(db,"{\"key\":\"value\"}")
        
        let  db2 = sut.readDatabaseData()
        XCTAssertNil(db2)
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
        _ = sut.seedDatabase(ref: "test-data")
        XCTAssert(sut.isModelTest())
    }
}
