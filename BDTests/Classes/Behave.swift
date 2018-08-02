//
//  BDTestsBDD.swift
//  BDTestsUnitTests
//
//  Created by Derek Bronston on 7/31/18.
//  Copyright © 2018 Derek Bronston. All rights reserved.
//
import UIKit

extension UIViewController {
    
    func givenTheUser(doesThis:String,withThis:BDUIElement,weExpect:String, letsVerify: @escaping() -> Void, orDoSomethingElse:@escaping() -> Void) -> Bool{
        
        switch withThis.type {
        case .button:
            let executed = button(uiElement: withThis.element)
            if executed {
                letsVerify()
                orDoSomethingElse()
                return true
            }
            return false
            
        case .table:
            let executed = table(uiElement: withThis.element)
            if executed{
                letsVerify()
                orDoSomethingElse()
                return true
            }
            return false
            
        case .tabbar:
            return false
            
        case .collection:
            let executed = collection(uiElement: withThis.element)
            if executed{
                letsVerify()
                orDoSomethingElse()
                return true
            }
            return false 
        }
    }
    
    //MARK: UI ELEMENTS
    private func table(uiElement:[String:Any]) -> Bool {
        guard let tbl = uiElement["table"] as? BDTable else { return false }
        return tableWithOutlet(table: tbl)
    }
    
    private func collection(uiElement:[String:Any]) -> Bool {
        guard let cltion = uiElement["collection"] as? BDCollection else { return false }
        return collectionWithOutlet(collection: cltion)
    }
    
    private func button(uiElement:[String:Any]) -> Bool {
        guard let theButton = uiElement["button"] as? BDButton else { return false }
        if let _ = theButton.outlet {
            return buttonWithOutlet(button:theButton)
        } else if let _ = theButton.identifier {
            return buttonWithIdentifier(button: theButton)
        }
        return false
    }
    
    private func tableWithOutlet(table:BDTable) -> Bool{
        if table.select {
            table.outlet.selectRow(at: table.indexPath, animated: false, scrollPosition: .none)
            table.outlet.delegate?.tableView!(table.outlet, didSelectRowAt: table.indexPath)
            return true
        }
        return false
    }
    
    private func collectionWithOutlet(collection:BDCollection) -> Bool{
        if collection.select {
            collection.outlet.selectItem(at: collection.indexPath, animated: true, scrollPosition: .centeredHorizontally)
            collection.outlet.delegate?.collectionView!(collection.outlet, didDeselectItemAt: collection.indexPath)
            return true
        }
        return false
    }
    
    //PRESS THE BUTTON ASSOCIATED WITH THE OUTLET
    private func buttonWithOutlet(button:BDButton) -> Bool {
        guard let outlet = button.outlet else { return false }
        outlet.sendActions(for: button.action)
        return true
    }
    
    //FIND THE BUTTON BASED ON THE IDENTIFIER. RECURSIVELY SEARCH ITS PARENT VIEW
    private func buttonWithIdentifier(button:BDButton) -> Bool{
        if let identifier = button.identifier {
            guard let parent = button.parent else { return false }
            if let returnedButton = findView(view: parent, identifier: identifier) as? UIButton {
                returnedButton.sendActions(for: button.action)
                return true
            }
        }
        return false
    }
    
    private func findView(view:UIView,identifier:String) -> UIView? {
        for subview in view.subviews {
            if subview.accessibilityIdentifier == identifier {
                return subview
            } else {
                if let view = childView(view: subview,identifier:identifier){
                    return view
                }
            }
        }
        return nil
    }
    
    private func childView(view:UIView,identifier:String) -> UIView? {
        for subview in view.subviews {
            if subview.accessibilityIdentifier == identifier {
                return subview
            } else {
                if let view = childView(view: subview,identifier:identifier){
                    return view
                }
            }
        }
        return nil
    }
}
