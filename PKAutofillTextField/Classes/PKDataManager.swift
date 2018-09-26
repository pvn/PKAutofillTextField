//
//  PKDataManager.swift
//  PKAutofillTextField_Example
//
//  Created by Praveen Kumar Shrivastava on 19/09/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import Foundation

private let _DataManagerSharedInstance = PKDataManager()

enum DataError: Error {
    case EmptyDictionary
    case InvalidKey
}

class PKDataManager {
    
    static let defaults = UserDefaults.standard
    
//    class var sharedInstance: PKDataManager {
//        
//        struct Static {
//            static let instance: PKDataManager = PKDataManager()
//        }
//        
//        return Static.instance
//    }
//    
//    var values: Set<String>? {
//        get {
//            let decoded = UserDefaults.standard.value(forKey: "server") as! Data
//            let decodedTeams = NSKeyedUnarchiver.unarchiveObject(with: decoded)
//            return decodedTeams as? Set<String>
//        }
//    }
    
    static func isKeyPresentInUserDefaults(key: String) -> Bool {
        return defaults.object(forKey: key) != nil
    }
    
    static func set(_ values: Set<String>, forKey key: String) {
        
        let encodedData = NSKeyedArchiver.archivedData(withRootObject: values)
        defaults.set(encodedData, forKey: key)
        synchronize()
    }
    
    static func get(forKey key: String) -> Set<String>{
        
        if isKeyPresentInUserDefaults(key: key) {
            
            let decoded = defaults.value(forKey: key)
            let decodedTeams = NSKeyedUnarchiver.unarchiveObject(with: decoded as! Data )
            return (decodedTeams as? Set<String>)!
        }
        else {
            print("Key \(key) is not found")
        }
        return []
    }
    
    static func clearAll(forKey key: String) {
        if isKeyPresentInUserDefaults(key: key) {
            defaults.removeObject(forKey: key)
            synchronize()
        }
    }
    
    static func synchronize() {
        defaults.synchronize()
    }
    
    
    static func remove(_ value: String, forKey key: String) {
        var items = self.get(forKey: key)
        items.remove(value)
        
        clearAll(forKey: key)
        
        set(items, forKey: key)
        
        synchronize()
    }
    
}



