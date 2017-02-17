//
//  BDTestRealmObject.swift
//  BDTest
//
//  Created by Derek Bronston on 2/17/17.
//  Copyright © 2017 Derek Bronston. All rights reserved.
//

import Foundation
import RealmSwift
import ObjectMapper

class BDTestRealmObject:Object,Mappable{

   
    dynamic var name:String?

    //Impl. of Mappable protocol
    required convenience init?(map: Map) {
        self.init()
    }
    
    
    public func mapping(map: Map) {
        
       
        name <- map["name"]
    }
}
