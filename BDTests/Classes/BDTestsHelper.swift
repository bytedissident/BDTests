//
//  BDTestsHelper.swift
//  BDTestsUnitTests
//
//  Created by Derek Bronston on 5/22/17.
//  Copyright © 2017 Derek Bronston. All rights reserved.
//

import Foundation
import UIKit

public class BDTestsHelper: NSObject {
    
    let bdTestsEnv = BDTestsEnv()
    public override init() {}

    /**
     Add a reset button to the UI so we can reset the next test in the sequence
     
     - parameter label:String
    */
    public func addResetButton(label: String) {
    
        let resetButton = UIButton()
        resetButton.tag = 99999
        resetButton.accessibilityLabel = label
        resetButton.frame = CGRect(x: 0.0, y: 0.0, width: 40.0, height: 40.0)
        resetButton.backgroundColor = UIColor.clear
        /*resetButton.add(for: .touchUpInside){
            _ = BDTestsEnv().testEnv()
        }*/
        let window = UIApplication.shared.windows.first!
        window.addSubview(resetButton)
        window.bringSubviewToFront(resetButton)
    }
}
