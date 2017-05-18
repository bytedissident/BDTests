//
//  BDTestsRealm.swift
//  BDTest
//
//  Created by Derek Bronston on 2/16/17.
//  Copyright © 2017 Derek Bronston. All rights reserved.
//

import Foundation
import RealmSwift
import ObjectMapper

class BDTestsRealm:Object {
    
    func jsonToRealm<T:Mappable>(json:String,obj:T,update:Bool)->Bool{
        
        guard let parsedJSON = self.convert(json: json) else { return false }
        self.mapAndSaveObject(data: parsedJSON, obj: obj,update:update)
        
        return true
    }
    
    func mapAndSaveObject<T:Mappable>(data:[String:Any],obj:T,update:Bool){
        let m = Mapper<T>().map(JSON:data)
        if update {
            self.update(item:m)
        }else{
            self.save(item: m)
        }
    }
    
    func convert(json:String)->[String:Any]?{
        
        let data = json.data(using: .utf8)
        do{
            let object = try JSONSerialization.jsonObject(with: data! as Data, options: .allowFragments)
            
            if let dictionnary : NSDictionary = object as? NSDictionary {
                if let dict = dictionnary as? [String : Any]{
                    return dict
                }else{
                    assert(false)
                    return nil
                }
            }else{
                assert(false)
                return nil
            }
        }catch _ as NSError{
            assert(false)
            return nil
        }
    }
    
    func save<T>(item:T){
        
        do {
            let realm = try Realm()
            try realm.write {
                if let i = item as? Object {
                    //print(i)
                    realm.add(i)
                }
            }
        }catch _ as NSError {
            assert(false)
            return
        }
    }
    
    func update<T>(item:T){
        
        do {
            let realm = try Realm()
            try realm.write {
                if let i = item as? Object {
                    //print(i)
                    realm.add(i,update:true)
                }
            }
        }catch _ as NSError {
            return
        }
    }
    
    func delete<T>(item:T){
        
        do {
            let realm = try Realm()
            try realm.write {
                if let i = item as? Object {
                    realm.delete(i)
                }
            }
        }catch _ as NSError {
            return
        }
    }
    
    func deleteAll(){
        
        do {
            let realm = try Realm()
            try realm.write {
                realm.deleteAll()
            }
        }catch _ as NSError {
            return
        }
    }
    
    
    func setUpRealm()->Realm?{
        
        var r:Realm?
        do{
            r = try Realm()
        }catch _ as NSError {
            //throw error
            return nil
        }
        return r
    }
    
}
