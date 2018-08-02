//
//  ViewController.swift
//  BDTestsUnitTests
//
//  Created by Derek Bronston on 5/22/17.
//  Copyright © 2017 Derek Bronston. All rights reserved.
//

import UIKit
import Alamofire

extension BDTestsHelper {

    /**
     This is a test method that mimics setting up the app with data from the database prior to launching the first view controller. This is hit from the AppDelegate in didFinishLaunchItems. It requires this line in _ = BDTestsEnv().testEnv() in the AppDelegate in didFinishLaunchItems method.
     
        This can be in fact used to do any set up.
    */
    public func testMethod(){
        
        //MIMIC DATABASE(Persitence) WITH USER DEFAULTS.
        UserDefaults.standard.set("test-string", forKey: "test-string")
    }
}

class ViewController: UIViewController {

    @IBOutlet weak var testText: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /**
     PULL DATA FROM DB AND PRINT TO label on screen
    */
    @IBAction func printLocalData(){
        if let testString = UserDefaults.standard.value(forKey: "test-string") as? String{
            testText.text = testString
            testText.accessibilityLabel = testString
        }else{
            testText.text = "NO DATA BASE INTERACTION"
            testText.accessibilityLabel = "NO DATA BASE INTERACTION"
        }
    }
    
    /**
     Handle button press for making an api call
    */
    @IBAction func submitData(_ sender: Any) {
        self.makeApiCall()
    }
    
    /**
     User Alamofire to make an api call and process response into the test label
    */
    func makeApiCall(){
        self.testText.text = "... ... ..."
        Alamofire.request("http://test.com",headers:nil).responseJSON { response in
            if let data = response.value {
                if let d = data as? [String:AnyObject]{
                    
                    self.testText.text = d["key"] as? String
                    self.testText.accessibilityLabel = d["key"] as? String
                }else{
                    self.testText.text = "FAIL 2"
                }
            }else{
                self.testText.text = "FAIL"
            }
        }
    }
}
