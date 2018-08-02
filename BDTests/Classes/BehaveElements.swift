//
//  BDElements.swift
//  BDTestsUnitTests
//
//  Created by Derek Bronston on 8/2/18.
//  Copyright © 2018 Derek Bronston. All rights reserved.
//
import UIKit

struct BDUIElement{
    let type:BDElementType
    let element:[String:Any]
}

enum  BDElementType {
    case button
    case tabbar
    case table
    case collection
}

struct BDTable {
    let outlet:UITableView
    let indexPath:IndexPath
    let select:Bool
}

struct BDCollection {
    let outlet:UICollectionView
    let indexPath:IndexPath
    let select:Bool
}

struct BDButton {
    let outlet:UIButton?
    let identifier:String?
    let action:UIControlEvents
    let parent:UIView?
}

struct BDTabBar {
    let index:Int
    let outlet:UITabBarController
}
