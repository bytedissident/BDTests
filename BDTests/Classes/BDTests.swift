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
     
     - parameter jsonString: String?
     - parameter jsonFile:String?
     - parameter httpCode:Int32
     
     - return: Bool
     */
    public func createTest(jsonString:String?,jsonFile:String?,httpCode:Int32)->Bool{
        
        //CLEAR
        //UIPasteboard.general.setValue(nil, forKey: "data")
        
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
    public func seedDatabase(ref:String)->Bool{
        
        //CLEAR
        removeModelTest()
        let currentItems = UIPasteboard.general.items
        var newItems = [[String:Any]]()
        for item in currentItems{
            if let _ = item["model"] {
                
            }else{
                newItems.append(item)
            }
        }
        newItems.append(["model":ref])
        UIPasteboard.general.addItems(newItems)
        
        return true
    }
    
    /**
     Reads the ref variable out of the clipboard in order to set up the test
     
     - retrun: String?
     */
    public func readDatabaseData()->String?{
        
        let items =  UIPasteboard.general.items
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
    public func removeTest(){
        
        let currentItems = UIPasteboard.general.items
        var newItems = [[String:Any]]()
        for item in currentItems{
            if let _ = item["data"] {
                
            }else{
                newItems.append(item)
            }
        }
        if #available(iOS 10.0, *) {
            UIPasteboard.general.setItems([[:]], options: [:])
        } else {
            UIPasteboard.general.items = [[:]]
        }
        UIPasteboard.general.addItems(newItems)
    }
    
    
    /**
     removes a model test and stubs
     
     */
    public func removeModelTest(){
        
        let currentItems = UIPasteboard.general.items
        var newItems = [[String:Any]]()
        for item in currentItems{
            if let _ = item["model"] {
                
            }else{
                newItems.append(item)
            }
        }
        if #available(iOS 10.0, *) {
            UIPasteboard.general.setItems([[:]], options: [:])
        } else {
            // Fallback on earlier versions
            UIPasteboard.general.items = [[:]]
        }
        UIPasteboard.general.addItems(newItems)
    }
    
    /**
     READ DATA FILE INTO STRING
     
     - parameter: urlString:String
     - return: String?
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
     
     - return: String?
     */
    public func readClipboard()->String?{
        
        let items =  UIPasteboard.general.items
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
    public func setClipboard(json:String)->Bool{
        
        //CLEAR
        removeTest()
        let currentItems = UIPasteboard.general.items
        var newItems = [[String:Any]]()
        for item in currentItems{
            if let _ = item["data"] {
                //newItems.append(item)
            }else{
                newItems.append(item)
            }
        }
        
        newItems.append(["data":json])
        UIPasteboard.general.addItems(newItems)
        return true
    }
    
    /**
     CONVERT JSON TO DICTIONARY
     
     - parameter text:String
     - return: [String:Any]?
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
     DETERMINE RESPONSE TEXT
     
     - parameter dict[String:Any]
     - return: String?
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
    
    public func runTestsAs200()->Bool{
        
        stub(condition: isMethodGET()) { request -> OHHTTPStubsResponse in
            return OHHTTPStubsResponse(data:Data(), statusCode:400, headers:nil)
        }
        
        stub(condition: isMethodPOST()) { request -> OHHTTPStubsResponse in
            return OHHTTPStubsResponse(data:Data(), statusCode:400, headers:nil)
        }
        
        stub(condition: isMethodPUT()) { request -> OHHTTPStubsResponse in
            return OHHTTPStubsResponse(data:Data(), statusCode:400, headers:nil)
        }
        
        stub(condition: isMethodPATCH()) { request -> OHHTTPStubsResponse in
            return OHHTTPStubsResponse(data:Data(), statusCode:400, headers:nil)
        }
        
        stub(condition: isMethodDELETE()) { request -> OHHTTPStubsResponse in
            return OHHTTPStubsResponse(data:Data(), statusCode:400, headers:nil)
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
        OHHTTPStubs.removeAllStubs()
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
