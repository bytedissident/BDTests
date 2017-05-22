//
//  ViewController.swift
//  BDTestsExample
//
//  Created by Derek Bronston on 5/18/17.
//  Copyright © 2017 Derek Bronston. All rights reserved.
//

import UIKit
import Alamofire

class ViewController: UIViewController {
    
    @IBOutlet weak var valueLabel: UILabel!
    @IBOutlet weak var modelDataLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        
        self.valueLabel.text = "TRY"
        Alamofire.request("http://test.com",headers:nil).responseJSON { response in
            
            if let data = response.value {
                if let d = data as? [String:AnyObject]{
                    
                    self.valueLabel.text = d["key"] as? String
                    self.valueLabel.accessibilityLabel = d["key"] as? String
                }else{
                    self.valueLabel.text = "FAIL 2"
                }
            }else{
                self.valueLabel.text = "FAIL"
            }
        }
    }
}

