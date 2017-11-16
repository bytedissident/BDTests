//
//  BDTestsEnv.swift
//  BDTestsUnitTests
//
//  Created by Derek Bronston on 5/22/17.
//  Copyright © 2017 Derek Bronston. All rights reserved.
//

import Foundation
import UIKit

class TestCounter {
    var counter = 0
    static let sharedInstance = TestCounter()
}

public class BDTestsEnv {
    
    public init(){}
    
    public func testEnv()->(networkTest:Bool,modelTest:Bool){
        
        var isNetworkTest = false
        var isModelTest = false
        
        //IF A NETWORK TEST HAS BEEN STUBBED
        let bdTests = BDTests(enviornmentName: nil)
        if bdTests.isTest() {
            isNetworkTest = true
            //START STUBBING WITH OHHTTPS
            _ = bdTests.runTests()
        }
        
        //IS THIS A MODEL TEST i.e DO WE HAVE A STUB METHOD(s)
        if bdTests.isModelTest(){
            isModelTest = true
            
            //READ SEEDER STRINGS
            if let model = bdTests.readDatabaseData(){
                
                //IF THIS IS A JSON ARRAY WE HAVE A BUNCH OF METHODS
                if model.contains("["){
                    
                    //PARSE STRING TO DATA
                    let objectData = model.data(using: String.Encoding.utf8)
                    
                    //PARSE DATA TO ARRAY
                    if let array = try! JSONSerialization.jsonObject(with: objectData!, options: []) as? [String] {
                        
                        /*
                         IF WE HAVE ITEMS IN OUR ARRAY THAT HAVE BEEN SCOPED TO BDTestsHelper
                         
                         */
                        let helpClass = BDTestsHelper()
                        
                        //MAKE SURE WE ARE NOT OUT OF BOUNDS
                        if array.count - 1 >= TestCounter.sharedInstance.counter{
                            
                            //DO WE HAVE A METHOD IN THE CLASS
                            if helpClass.responds(to: Selector(array[TestCounter.sharedInstance.counter])){
                                //TRRIGGER METHID
                                helpClass.perform(Selector(array[TestCounter.sharedInstance.counter]))
                                
                                //UPDATE COUNTER SINGLETON
                                TestCounter.sharedInstance.counter += 1
                            }
                        }
                    }
                }else{//WE HAVE A SINGLE STUB
                    let helpClass = BDTestsHelper()
                    if helpClass.responds(to: Selector(model)){
                        helpClass.perform(Selector(model))
                    }
                }
            }
        }
        return (isNetworkTest,isModelTest)
    }
    
    public func runSeederAgain(){
        _ = testEnv()
    }
}
