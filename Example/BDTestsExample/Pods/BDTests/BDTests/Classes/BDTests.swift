//
//  BDTests.swift
//  BDTest
//
//  Created by Derek Bronston on 2/16/17.
//  Copyright © 2017 Derek Bronston. All rights reserved.
//

import UIKit
import OHHTTPStubs


/*
 Custom pustboard is used, because tests with UIPasteboard has ~x4 execution time
 e.g.
 Custom Pasteboard: Executed 2351 tests, with 0 failures (0 unexpected) in 225.449 (227.031) seconds
 UIPasteboard:      Executed 2350 tests, with 0 failures (0 unexpected) in 808.095 (809.200) seconds
 */
private class Pasteboard {
    static var general = Pasteboard()

    func setItems(_ items: [[String : Any]]) {
        self.items = items
    }

    var items: [[String : Any]] = []

    func addItems(_ items: [[String : Any]]) {
        self.items = self.items + items
    }
}


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
     
     - parameter jsonString: String?
     - parameter jsonFile:String?
     - parameter httpCode:Int32
     
     - return: Bool
     */
    public func createTest(jsonString: String?, jsonFile: String?, httpCode: Int32) -> Bool {
        
        //CLEAR
        //Pasteboard.general.setValue(nil, forKey: "data")
        
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
     ==== BASE ====
     The ref variable is the string representation on the method that we want to call in order to set up test
     ==== BASE ====
     
     - parameter ref: String
     
     - return: Bool
     */
    public func seedDatabase(ref: String) -> Bool {
        
        //CLEAR
        removeModelTest()
        let currentItems = Pasteboard.general.items
        var newItems = [[String: Any]]()
        for item in currentItems {
            if item["model"] == nil {
                newItems.append(item)
            }
        }
        newItems.append(["model": ref])
        Pasteboard.general.addItems(newItems)
        
        return true
    }
    
    /**
     Reads the ref variable out of the clipboard in order to set up the test
     
     - retrun: String?
     */
    public func readDatabaseData() -> String? {
        
        let items =  Pasteboard.general.items
        for item in items {
            if let model = item["model"]  {
                guard let modelData = model as? Data else { return nil }
                guard let methodName = String(data: modelData, encoding: .utf8) else { return nil }
                return methodName
            }
        }
        return nil
    }
    
    
    /**
     Removes all tests. Removes:stubs, pasteboards
     
     - return: none
     */
    public func removeTest() {
        
        let currentItems = Pasteboard.general.items
        var newItems = [[String: Any]]()
        for item in currentItems{
            if item["data"] == nil {
                newItems.append(item)
            }
        }
        Pasteboard.general.items = newItems
    }
    
    
    /**
     removes a model test and stubs
     
     */
    public func removeModelTest() {
        
        let currentItems = Pasteboard.general.items
        var newItems = [[String:Any]]()
        for item in currentItems{
            if item["model"] == nil {
                newItems.append(item)
            }
        }
        Pasteboard.general.items = newItems
    }
    
    /**
     READ DATA FILE INTO STRING
     
     - parameter: urlString:String
     - return: String?
     */
    public func openFileAndReadIntoString(urlString: String) -> String? {
        guard let dir = Bundle.main.path(forResource: urlString, ofType: "json") else { return nil }
        do {
            return try String(contentsOfFile: dir)
        } catch _ as NSError {
            return nil
        }
    }
    
    /**
     READ CLIPBOARD
     
     1. http code
     2. json string?
     3. json file
     
     - return: String?
     */
    public func readClipboard() -> String? {
        
        let items = Pasteboard.general.items
        for item in items {
            if let model = item["data"]  {
                guard let modelData = model as? Data else { return nil }
                guard let methodName = String(data: modelData, encoding: .utf8) else { return nil }
                return methodName
            }
        }
        
        return nil
    }
    
    /**
     SET CLIPBOARD
     pass json into clipboard for later review
     
     1. http code
     2. json string?
     3. json file
     
     - parameter json:String
     - return: Bool
     
     */
    public func setClipboard(json: String) -> Bool {
        
        //CLEAR
        removeTest()
        let currentItems = Pasteboard.general.items
        var newItems = [[String: Any]]()
        for item in currentItems{
            if item["data"] == nil {
                newItems.append(item)
            }
        }
        
        newItems.append(["data":json])
        Pasteboard.general.addItems(newItems)
        return true
    }
    
    /**
     CONVERT JSON TO DICTIONARY
     
     - parameter text:String
     - return: [String:Any]?
     */
    public func convertToDictionary(text: String) -> [String: Any]? {
        guard let data = text.data(using: .utf8) else { return nil }
        do {
            return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
    
    
    /**
     DETERMINE RESPONSE TEXT
     
     - parameter dict[String:Any]
     - return: String?
     */
    public func determineResponseText(dict: [String: Any]) -> String? {
        
        if dict["data"] != nil {
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: dict["data"]!, options: .prettyPrinted)
                // here "jsonData" is the dictionary encoded in JSON data
                guard let responseText = String(data: jsonData, encoding: .utf8) else {
                    assert(false)
                    return nil
                }
                return responseText
            }catch _ as NSError{
                //assert(false);
                return nil
            }
        }
        
        if let dataFileUrl = dict["data-file"] as? String {
            guard let responseText = self.openFileAndReadIntoString(urlString: dataFileUrl) else {
                assert(false)
                return nil
            }
            
            return responseText
        }
        //assert(false);
        return nil
    }
    
    /**
     STUB NETWORK
     */
    public func runTests() -> Bool {
        
        stub(condition: isMethodGET()) { request -> HTTPStubsResponse in
            let data = self.readData()
            guard data.code > 0 else {
                return HTTPStubsResponse(data:Data(), statusCode:400, headers:nil)
            }
            let code = data.code
            let responseText = data.response
            //print(responseText)
            let stubData = responseText.data(using: String.Encoding.utf8)
            return HTTPStubsResponse(data:stubData!, statusCode:code, headers:nil)
        }
        
        stub(condition: isMethodPOST()) { request -> HTTPStubsResponse in
            let data = self.readData()
            if data.code > 0 {
                let code = data.code
                let responseText = data.response
                //print(responseText)
                let stubData = responseText.data(using: String.Encoding.utf8)
                return HTTPStubsResponse(data:stubData!, statusCode:code, headers:nil)
            }else {
                return HTTPStubsResponse(data:Data(), statusCode:400, headers:nil)
            }
        }
        
        stub(condition: isMethodPUT()) { request -> HTTPStubsResponse in
            let data = self.readData()
            if data.code > 0 {
                let code = data.code
                let responseText = data.response
                //print(responseText)
                let stubData = responseText.data(using: String.Encoding.utf8)
                return HTTPStubsResponse(data:stubData!, statusCode:code, headers:nil)
            }else {
                return HTTPStubsResponse(data:Data(), statusCode:400, headers:nil)
            }
        }
        
        stub(condition: isMethodPATCH()) { request -> HTTPStubsResponse in
            let data = self.readData()
            if data.code > 0 {
                let code = data.code
                let responseText = data.response
                // print(responseText)
                let stubData = responseText.data(using: String.Encoding.utf8)
                return HTTPStubsResponse(data:stubData!, statusCode:code, headers:nil)
            }else {
                return HTTPStubsResponse(data:Data(), statusCode:400, headers:nil)
            }
        }
        
        stub(condition: isMethodDELETE()) { request -> HTTPStubsResponse in
            let data = self.readData()
            if data.code > 0 {
                let code = data.code
                let responseText = data.response
                //print(responseText)
                let stubData = responseText.data(using: String.Encoding.utf8)
                return HTTPStubsResponse(data:stubData!, statusCode:code, headers:nil)
            }else {
                return HTTPStubsResponse(data:Data(), statusCode:400, headers:nil)
            }
        }
        return true
    }
    
    public func runTestsAs200()->Bool{
        
        stub(condition: isMethodGET()) { request -> HTTPStubsResponse in
            return HTTPStubsResponse(data:Data(), statusCode:400, headers:nil)
        }
        
        stub(condition: isMethodPOST()) { request -> HTTPStubsResponse in
            return HTTPStubsResponse(data:Data(), statusCode:400, headers:nil)
        }
        
        stub(condition: isMethodPUT()) { request -> HTTPStubsResponse in
            return HTTPStubsResponse(data:Data(), statusCode:400, headers:nil)
        }
        
        stub(condition: isMethodPATCH()) { request -> HTTPStubsResponse in
            return HTTPStubsResponse(data:Data(), statusCode:400, headers:nil)
        }
        
        stub(condition: isMethodDELETE()) { request -> HTTPStubsResponse in
            return HTTPStubsResponse(data:Data(), statusCode:400, headers:nil)
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
     
     - return: none
     */
    public func removeStubs(){
        HTTPStubs.removeAllStubs()
    }
    
    /**
     IS TEST
     
     - return: Bool
     
     */
    public func isTest()->Bool{
        
        if readClipboard() == nil { return false }
        return true
    }
    
    /**
     HAS MODEL TEST
     
     - return: Bool
     
     */
    public func isModelTest()->Bool{
        
        if readDatabaseData() == nil { return false }
        return true
    }
}
