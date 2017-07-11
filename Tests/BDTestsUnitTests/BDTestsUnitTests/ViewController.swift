//
//  ViewController.swift
//  BDTestsUnitTests
//
//  Created by Derek Bronston on 5/22/17.
//  Copyright © 2017 Derek Bronston. All rights reserved.
//

import UIKit
import Alamofire

class ViewController: UIViewController {

    @IBOutlet weak var testText: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        testText.text = "HELLO"
        testText.accessibilityLabel = "HELLO"
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func submitData(_ sender: Any) {
        self.makeApiCall()
    }
    
    func makeApiCall(){
        
        
        self.testText.text = "TRY"
        Alamofire.request("http://test.com",headers:nil).responseJSON { response in
            print(response.value)
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

