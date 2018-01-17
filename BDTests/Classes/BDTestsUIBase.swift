//
//  BDTestsUIBase.swift
//  BDTestsUITests
//
//  Created by Derek Bronston on 11/14/17.
//  Copyright © 2017 Derek Bronston. All rights reserved.
//
import XCTest
import Foundation


class BDTestsUIBase: BDTestsUI {
    
    var methodCounter = 0
    var methodList: UnsafeMutablePointer<Method?>!
    
    override func setUp() {
        super.setUp()
        
        BDTests(enviornmentName: nil).removeTest()
        setUpRun()
        continueAfterFailure = false
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    /**
     Initial method called by test runner. This will in turn call runThis() which handles the extended test methods
    */
    func testRunMethod(){
      runThis()
    }
    
    /**
     This method gets called in the recursion
    */
    func again(){
        methodCounter = methodCounter + 1
        runThis()
    }
    
    
    func reset(){
        again()
    }
    
    /*################ Methods handling test recursion ##########################*/
    
    /**
     Sets up the counter and gets the initial list
    */
    func setUpRun(){
       
        let myClass = BDTestsUIBase.self
        var methodCount: UInt32 = 0
        methodList = class_copyMethodList(myClass, &methodCount)
        setUpSeederMethods()
    }
    
    func setUpSeederMethods(){
        
        var seedMethods = [String]()
        
        if methodList![methodCounter] == nil {
            return }
        var counter = 0
        while counter == 0 {
            if methodList![methodCounter] == nil{
                counter = 1
            }
            let selName = method_getName(methodList![methodCounter])
            
            if let methodName = selName {
                let stringRep = String(describing: methodName)
                if stringRep.contains("bd_"){
                    seedMethods.append("seed_" + stringRep)
                }
            }
            methodCounter = methodCounter + 1
        }
        
        if let jsonData = try? JSONSerialization.data(withJSONObject: seedMethods, options: []){
            let jsonString = String(data: jsonData, encoding: .utf8)
            //print(jsonString ?? "!!!")
            _ = BDTests(enviornmentName: nil).seedDatabase(ref: jsonString!)
        }
        
        methodCounter = 0
        XCUIApplication().launch()
    }
    
    /**
     
    */
    func runThis(){
        
        let mc = self
        if methodList![methodCounter] == nil { BDTests(enviornmentName: nil).removeTest();
            return }
        let selName = method_getName(methodList![methodCounter])
        if let methodName = selName {
            let stringRep = String(describing: methodName)
            if stringRep.contains("bd_")
            {
                mc.perform(methodName)
                
            }else{
                mc.again()
            }
        }
    }
}
