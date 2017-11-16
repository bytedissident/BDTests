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
        let bdTests = BDTests(enviornmentName: nil)
        if bdTests.isTest() {
            isNetworkTest = true
            _ = bdTests.runTests()
        }
        
        if bdTests.isModelTest(){
            isModelTest = true
            if let model = bdTests.readDatabaseData(){
                if model.contains("["){
                    let objectData = model.data(using: String.Encoding.utf8)
                    if let array = try! JSONSerialization.jsonObject(with: objectData!, options: []) as? [String] {
                    
                        let helpClass = BDTestsHelper()
                        if array.count - 1 >= TestCounter.sharedInstance.counter{
                            if helpClass.responds(to: Selector(array[TestCounter.sharedInstance.counter])){
                               helpClass.perform(Selector(array[TestCounter.sharedInstance.counter]))
                                
                                TestCounter.sharedInstance.counter += 1
                            }
                        }
                    }
                }else{
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
