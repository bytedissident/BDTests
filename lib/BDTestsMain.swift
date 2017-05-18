//
//  BDTestsMain.swift
//  BDTest
//
//  Created by Derek Bronston on 2/16/17.
//  Copyright © 2017 Derek Bronston. All rights reserved.
//

import UIKit
import OHHTTPStubs
import Alamofire

class BDTestsMain  {
    
    //DEFAULT ENVIORNMENT NAME, USED TO DETERMINE IF WE ARE IN TEST MODE. CHANGE FTO YOUR ENVIORMENT
    var enviornmentName = "BD-UI-TEST"
    
    //DEFAULT HTTP RESPONSE CODE TO 200
    var httpResponseCode:Int32 = 200
    
    init(enviornmentName:String?){
        if let envName = enviornmentName {
            self.enviornmentName = envName
        }
    }
    
    /*
     CREATE TEST
     */
    func createTest(jsonString:String?,jsonFile:String?,httpCode:Int32)->Bool{
        print("CREATE TEST")
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
    
    /*
     seed database
     */
    func seedDatabase(json:String)->Bool{
        
        let paste = UIPasteboard(name: UIPasteboardName(rawValue: self.enviornmentName+"-model"), create: true)
        paste?.string = ""
        paste?.string = json
        
        if paste == nil { return false }
        return true
    }
    
    /**
     read database data
     */
    func readDatabaseData()->[String:Any]?{
        
        let paste = UIPasteboard(name: UIPasteboardName(rawValue: self.enviornmentName+"-model"), create: true)
        if paste == nil { return nil }
        
        guard let json = paste?.string else { return nil }
        guard let dict = self.convertToDictionary(text: json) else { return nil }
        
        return dict
    }
    
    
    
    func removeTest(){
        self.removeStubs()
        UIPasteboard.remove(withName: UIPasteboardName(rawValue: self.enviornmentName))
        UIPasteboard.remove(withName: UIPasteboardName(rawValue: self.enviornmentName+"-model"))
    }
    
    func removeModelTest(){
        self.removeStubs()
        UIPasteboard.remove(withName: UIPasteboardName(rawValue: self.enviornmentName+"-model"))
    }
    
    /*
     READ DATA FILE INTO STRING
     */
    func openFileAndReadIntoString(urlString:String)->String?{
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
    
    /*
     READ CLIPBOARD
     
     1. http code
     2. json string?
     3. json file
     
     */
    func readClipboard()->String?{
        
        let paste = UIPasteboard(name: UIPasteboardName(rawValue: self.enviornmentName), create: true)
        
        if paste == nil { return nil }
        return paste?.string
    }
    
    /*
     SET CLIPBOARD
     pass json into clipboard for later review
     
     
     1. http code
     2. json string?
     3. json file
     */
    func setClipboard(json:String)->Bool{
        
        let paste = UIPasteboard(name: UIPasteboardName(rawValue: self.enviornmentName), create: true)
        paste?.string = ""
        paste?.string = json
        
        if paste == nil { return false }
        return true
    }
    
    /*
     CONVERT JSON TO DICTIONARY
     */
    func convertToDictionary(text: String) -> [String: Any]? {
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
    
    
    /*
     DETERMINE RESOPNSE TEXT
     */
    func determineResponseText(dict:[String:Any])->String?{
        
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
    
    /*
     STUB NETWORK
     */
    func runTests()->Bool{
        
        guard let json = self.readClipboard() else { assert(false); return false }
        guard let dict = self.convertToDictionary(text: json) else { assert(false); return false }
        guard let responseText = self.determineResponseText(dict:dict) else { assert(false); return false }
        guard let httpCode = dict["code"] else { assert(false); return false }
        guard let code =  httpCode as? Int32 else { assert(false); return false }
        
        stub(condition: isMethodGET()) { request -> OHHTTPStubsResponse in
            let stubData = responseText.data(using: String.Encoding.utf8)
            return OHHTTPStubsResponse(data:stubData!, statusCode:code, headers:nil)
        }
        
        stub(condition: isMethodPOST()) { request -> OHHTTPStubsResponse in
            let stubData = responseText.data(using: String.Encoding.utf8)
            return OHHTTPStubsResponse(data:stubData!, statusCode:code, headers:nil)
        }
        
        stub(condition: isMethodPUT()) { request -> OHHTTPStubsResponse in
            let stubData = responseText.data(using: String.Encoding.utf8)
            return OHHTTPStubsResponse(data:stubData!, statusCode:code, headers:nil)
        }
        
        stub(condition: isMethodPATCH()) { request -> OHHTTPStubsResponse in
            let stubData = responseText.data(using: String.Encoding.utf8)
            return OHHTTPStubsResponse(data:stubData!, statusCode:code, headers:nil)
        }
        
        stub(condition: isMethodDELETE()) { request -> OHHTTPStubsResponse in
            let stubData = responseText.data(using: String.Encoding.utf8)
            return OHHTTPStubsResponse(data:stubData!, statusCode:code, headers:nil)
        }
        return true
    }
    
    /**
     REMOVE STUBS
     */
    func removeStubs(){
        OHHTTPStubs.removeAllStubs()
    }
    
    /*
     IS TEST
     */
    func isTest()->Bool{
        
        let paste = UIPasteboard(name: UIPasteboardName(rawValue: self.enviornmentName), create: false)
        if paste?.string != nil {
            
            return true
        }
        return false
    }
    
    
    /*
     HAS MODEL TEST
     */
    func isModelTest()->Bool{
        
        let paste = UIPasteboard(name: UIPasteboardName(rawValue: self.enviornmentName+"-model"), create: false)
        if paste?.string != nil {
            
            return true
        }
        return false
    }
}
