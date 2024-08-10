//
//  UserDefaultsManager.swift
//  Itunes
//
//  Created by 홍정민 on 8/10/24.
//

import Foundation

@propertyWrapper
struct UserDefault<T> {
    let storage = UserDefaults.standard
    var key: String
    var defaultValue: T
    var wrappedValue: T {
        get {
            return storage.object(forKey: key) as? T ?? defaultValue
        }
        set {
            storage.set(newValue, forKey: key)
        }
    }
    
}

final class UserDefaultsManager {
    private init() { }
    
    @UserDefault(key: "searchList", defaultValue: [:])
    static var searchList: [Int: String]
}
