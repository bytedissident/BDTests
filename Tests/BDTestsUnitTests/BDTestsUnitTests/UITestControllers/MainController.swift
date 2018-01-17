//
//  ViewController.swift
//  BDTestsUITests
//
//  Created by Derek Bronston on 5/22/17.
//  Copyright © 2017 Derek Bronston. All rights reserved.
//

import UIKit
import Alamofire


class Singleton {
    var testValue = "test-value"
    static let sharedInstance = Singleton()
}

extension BDTestsHelper {
    
    public func seed_bd_stubOne(){
        
        //addResetButton(label: "reset-button-1")
        Singleton.sharedInstance.testValue = "test-string-one"
        
    }
    
    public func seed_bd_stubTwo(){
        
        //addResetButton(label: "reset-button-2")
        Singleton.sharedInstance.testValue = "test-string-two"
        
    }
    
    func seed_bd_Alert(){}
    
    func seed_bd_Sheet(){}
    
    func seed_bd_TableCellByIndex(){}
    
    func seed_bd_TableCellByIdentifier_exists(){}
}

class MainController: UIViewController {

    
    @IBOutlet weak var testTextField: UITextField!
    @IBOutlet weak var testSecureTextField: UITextField!
    @IBOutlet weak var testLabel: UILabel!
    @IBOutlet weak var testButton: UIButton!
    @IBOutlet weak var testSwitch: UISwitch!
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        _ = BDTestsEnv().testEnv()
    }
    

    @IBAction func testButtonAction(_ sender: Any) {
        
        self.testLabel.accessibilityLabel =  Singleton.sharedInstance.testValue
        self.testLabel.text =  Singleton.sharedInstance.testValue
            
        
    }
    
    @IBAction func triggerSheet(_ sender: Any) {
        
        let alert = UIAlertController(title: "Sheet Title", message: "Sheet message.", preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "one", style: .default) { action in
            // perhaps use action.title here
            self.testLabel.accessibilityLabel = "One Pressed"
            self.testLabel.text = "One Pressed"
        })
        
        alert.addAction(UIAlertAction(title: "two", style: .default) { action in
            // perhaps use action.title here
        })
        
        self.present(alert, animated: true, completion: nil)

    }
    
    @IBAction func triggerAlert(_ sender: Any) {
        
        let alert = UIAlertController(title: "Alert Title", message: "Alert message.", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "one", style: .default) { action in
            // perhaps use action.title here
            self.testLabel.accessibilityLabel = "One Pressed"
            self.testLabel.text = "One Pressed"
        })
        
        alert.addAction(UIAlertAction(title: "two", style: .default) { action in
            // perhaps use action.title here
        })
        
        self.present(alert, animated: true, completion: nil)
    }
}

