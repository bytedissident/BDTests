//
//  BDTests.swift
//  BDTest
//
//  Created by Derek Bronston on 2/16/17.
//  Copyright © 2017 Derek Bronston. All rights reserved.
//

import UIKit
import OHHTTPStubs


public class BDTests  {
    
    //DEFAULT ENVIORNMENT NAME, USED TO DETERMINE IF WE ARE IN TEST MODE. CHANGE FTO YOUR ENVIORMENT
    public var enviornmentName = "BD-UI-TEST"
    
    //DEFAULT HTTP RESPONSE CODE TO 200
    public var httpResponseCode:Int32 = 200
    
    public init(enviornmentName:String?){
        if let envName = enviornmentName {
            self.enviornmentName = envName
        }
    }
    
    /**
     Creates a test
     
     @param jsonString:String?, jsonFile:String?, httpCode:Int32
     @return Bool
     
     */
    public func createTest(jsonString:String?,jsonFile:String?,httpCode:Int32)->Bool{
        
        //CLEAR 
        UIPasteboard.general.string = ""
        
        var created = false
        
        //SET THE HTTP RESPONSE CODE
        self.httpResponseCode = httpCode
        
        //DID WE PASS A STRING
        if jsonString != nil {
            let json = "{\"code\":\(httpResponseCode),\"data\":\(jsonString!)}"
            created = self.setClipboard(json: json)
            //assert(created)
        }
        
        //DID WE PASS A FILE URL
        if jsonFile != nil {
            
            //set clipboard data
            let json = "{\"code\":\(httpResponseCode),\"data-file\":\"\(jsonFile!)\"}"
            created = self.setClipboard(json: json)
            //assert(created)
        }
        //return success message
        return created
    }
    
    /**
     the ref variable is the string representation on the method that we want to call in order to set up test
     
     @param ref:String
     @return Bool
     */
    public func seedDatabase(ref:String)->Bool{
        
        let paste = UIPasteboard(name: UIPasteboardName(rawValue: self.enviornmentName+"-model"), create: true)
        paste?.string = ""
        paste?.string = ref
        
        if paste == nil { return false }
        return true
    }
    
    /**
     Reads the ref variable out of the clipboard in order to set up the test
     
     @param: None
     @retrun: String?
     */
    public func readDatabaseData()->String?{
        
        let paste = UIPasteboard(name: UIPasteboardName(rawValue: self.enviornmentName+"-model"), create: true)
        if paste == nil { return nil }
        let string = paste?.string
        //guard let json = paste?.string else { return nil }
        //guard let dict = self.convertToDictionary(text: json) else { return nil }
        
        //CLEAR CLIPBOARD
        UIPasteboard.remove(withName: UIPasteboardName(rawValue: self.enviornmentName+"-model"))
        
        return string
    }
    
    
    /**
     Removes all tests. Removes:stubs, pasteboards
     
     @param: none
     @return : none
     */
    public func removeTest(){
        self.removeStubs()
        UIPasteboard.remove(withName: UIPasteboardName(rawValue: self.enviornmentName))
        UIPasteboard.remove(withName: UIPasteboardName(rawValue: self.enviornmentName+"-model"))
    }
    
    
    /**
     removes a model test and stubs
     
     @param: none
     @return: none
     */
    public func removeModelTest(){
        self.removeStubs()
        UIPasteboard.remove(withName: UIPasteboardName(rawValue: self.enviornmentName+"-model"))
    }
    
    /**
     READ DATA FILE INTO STRING
     
     @param: urlString:String
     @return:String?
     
     */
    public func openFileAndReadIntoString(urlString:String)->String?{
        if let dir = Bundle.main.path(forResource: urlString, ofType:"json"){
            do {
                let text2 = try String(contentsOfFile: dir)
                return text2
            }catch _ as NSError{
                return nil
            }
        }
        return nil
    }
    
    /**
     READ CLIPBOARD
     
     1. http code
     2. json string?
     3. json file
     
     @param: none
     @return String?
     */
    public func readClipboard()->String?{
        
        let paste =  UIPasteboard.general.string
        
        if paste == nil { return nil }
        //print("READ CLIPBOARD \(clipString )")
        //clean clipboard
        UIPasteboard.general.string = ""
        
        //print(clipString)
        return paste
        
    }
    
    /**
     SET CLIPBOARD
     pass json into clipboard for later review
     
     
     1. http code
     2. json string?
     3. json file
     
     @return: Bool
     */
    public func setClipboard(json:String)->Bool{
        
        UIPasteboard.general.string = json
        return true
    }
    
    /**
     CONVERT JSON TO DICTIONARY
     
     @param: textString
     @return: [String:Any]?
     */
    public func convertToDictionary(text: String) -> [String: Any]? {
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
    
    
    /**
     DETERMINE RESOPNSE TEXT
     
     @param: dict[String:Any]
     @return: String?
     */
    public func determineResponseText(dict:[String:Any])->String?{
        
        if dict["data"] != nil {
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: dict["data"]!, options: .prettyPrinted)
                // here "jsonData" is the dictionary encoded in JSON data
                let response = String.init(data: jsonData, encoding: .utf8)
                guard let responseText = response else { assert(false); return nil}
                return responseText
            }catch _ as NSError{
                //assert(false);
                return nil
            }
        }
        
        if dict["data-file"] as? String != nil {
            
            guard let responseText = self.openFileAndReadIntoString(urlString: dict["data-file"]! as! String) else { assert(false); return nil }
            
            return responseText
        }
        //assert(false);
        return nil
    }
    
    /**
     STUB NETWORK
     */
    public func runTests()->Bool{
        
        stub(condition: isMethodGET()) { request -> OHHTTPStubsResponse in
            let data = self.readData()
            if data.code > 0 {
                let code = data.code
                let responseText = data.response
                //print(responseText)
                let stubData = responseText.data(using: String.Encoding.utf8)
                return OHHTTPStubsResponse(data:stubData!, statusCode:code, headers:nil)
            }else {
                return OHHTTPStubsResponse(data:Data(), statusCode:400, headers:nil)
            }
        }
        
        stub(condition: isMethodPOST()) { request -> OHHTTPStubsResponse in
            let data = self.readData()
            if data.code > 0 {
                let code = data.code
                let responseText = data.response
                //print(responseText)
                let stubData = responseText.data(using: String.Encoding.utf8)
                return OHHTTPStubsResponse(data:stubData!, statusCode:code, headers:nil)
            }else {
                return OHHTTPStubsResponse(data:Data(), statusCode:400, headers:nil)
            }
        }
        
        stub(condition: isMethodPUT()) { request -> OHHTTPStubsResponse in
            let data = self.readData()
            if data.code > 0 {
                let code = data.code
                let responseText = data.response
                //print(responseText)
                let stubData = responseText.data(using: String.Encoding.utf8)
                return OHHTTPStubsResponse(data:stubData!, statusCode:code, headers:nil)
            }else {
                return OHHTTPStubsResponse(data:Data(), statusCode:400, headers:nil)
            }
        }
        
        stub(condition: isMethodPATCH()) { request -> OHHTTPStubsResponse in
            let data = self.readData()
            if data.code > 0 {
                let code = data.code
                let responseText = data.response
                // print(responseText)
                let stubData = responseText.data(using: String.Encoding.utf8)
                return OHHTTPStubsResponse(data:stubData!, statusCode:code, headers:nil)
            }else {
                return OHHTTPStubsResponse(data:Data(), statusCode:400, headers:nil)
            }
        }
        
        stub(condition: isMethodDELETE()) { request -> OHHTTPStubsResponse in
            let data = self.readData()
            if data.code > 0 {
                let code = data.code
                let responseText = data.response
                //print(responseText)
                let stubData = responseText.data(using: String.Encoding.utf8)
                return OHHTTPStubsResponse(data:stubData!, statusCode:code, headers:nil)
            }else {
                return OHHTTPStubsResponse(data:Data(), statusCode:400, headers:nil)
            }
        }
        return true
    }
    
    func readData()->(code:Int32,response:String){
        
        let resp = (code:Int32(0),response:"")
        guard let json = self.readClipboard() else { return resp }
        guard let dict = self.convertToDictionary(text: json) else { return resp }
        guard let responseText = self.determineResponseText(dict:dict) else { return resp }
        guard let httpCode = dict["code"] else { return resp }
        guard let code =  httpCode as? Int32 else { return resp }
        
        return (code:code,response:responseText)
    }
    
    /**
     REMOVE STUBS
     
     @return: none
     */
    public func removeStubs(){
        OHHTTPStubs.removeAllStubs()
    }
    
    /**
     IS TEST
     
     @return: Bool
     */
    public func isTest()->Bool{
        
        let paste = UIPasteboard.general.string
        if let pasteString = paste {
            
            if pasteString.characters.count > 0 {
                return true
            }
            
            return false
        }
        return false
    }
    
    
    /**
     HAS MODEL TEST
     
     @return: Bool
     */
    public func isModelTest()->Bool{
        
        let paste = UIPasteboard(name: UIPasteboardName(rawValue: self.enviornmentName+"-model"), create: false)
        if paste?.string != nil {
            
            return true
        }
        return false
    }
    
    /*
     Tests if there's a memroy leak
     - parameter: sut: a View Controller that will get tests
     */
    public func checkMemoryLeak(inout sut:UIViewController) {
        var sut  = UIViewController
        weak var weakSut = sut
        sut = nil
        XCTAssertNil(weakSut)
    }
    
    /*
     Tests Fatal Error
     - parameter: expectedMessage: the expected message of the fatar errorError
     - parameter: testCase: callBack
     - return: a callback
     */
    public func checkFatalError(expectedMessage: String, testcase: @escaping () -> Void) {
        
        let expectation = self.expectation(description: "expectingFatalError")
        var assertionMessage: String? = nil
        
        FatalErrorUtil.replaceFatalError { message, _, _ in
            assertionMessage = message
            expectation.fulfill()
            self.unreachable()
        }
        
        DispatchQueue.global(qos: .userInitiated).async(execute: testcase)
        
        waitForExpectations(timeout: 2) { _ in
            XCTAssertEqual(assertionMessage, expectedMessage)
            
            FatalErrorUtil.restoreFatalError()
        }
    }
    
    
    func unreachable() -> Never {
        repeat {
            RunLoop.current.run()
        } while (true)
    }
    
}
