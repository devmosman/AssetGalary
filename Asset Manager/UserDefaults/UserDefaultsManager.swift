//
//  UserDefaultsManager.swift
//  Asset Manager
//
//  Created by Marwan on 17/06/2022.
//

import Foundation

enum UserDefaultKeys: String {
    case authToken = "AuthToken"
    case isAdmin = "isAdmin"
    case baseURL = "baseURL"
}

class UserDefaultsManager {
    static func set(value: Any, key: String) {
        let defaults = UserDefaults.standard
        defaults.set(value, forKey: key)
        defaults.synchronize()
    }
    
    static func setObject<T>(_ object: T, forKey: String) where T: Encodable {
        let encoder = JSONEncoder()
        if let data = try? encoder.encode(object) {
            let defaults = UserDefaults.standard
            defaults.set(data, forKey: forKey)
            defaults.synchronize()

        }
    }
    
    static func remove(key: String) {
        let defaults = UserDefaults.standard
        defaults.removeObject(forKey: key)
    }

    
    private static func check(forKey key: String) -> Bool {
        let defaults = UserDefaults.standard
        if defaults.value(forKey: key) != nil {
            return true
        }
        return false
    }
    
    static func get(key: String) -> Any? {
        if check(forKey: key) {
            let defaults = UserDefaults.standard
            return defaults.value(forKey: key)!
        }
        return nil
    }
    
    static func getObject<T>(forKey key: String, castTo type: T.Type) -> T? where T: Decodable {
        let defaults = UserDefaults.standard
        if let savedData = defaults.object(forKey: key) as? Data {
            let decoder = JSONDecoder()
            if let loadedObj = try? decoder.decode(type.self, from: savedData) {
                return loadedObj
            }
        }
        return nil
    }
}
