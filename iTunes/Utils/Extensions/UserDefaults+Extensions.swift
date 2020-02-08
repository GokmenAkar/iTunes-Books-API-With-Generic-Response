//
//  UserDefaults+Extensions.swift
//  iTunes
//
//  Created by Developer on 8.02.2020.
//

import Foundation

extension UserDefaults {
    var favorites: [String]? {
        get {
            UserDefaults.standard.array(forKey: #function) as? [String]
        } set {
            UserDefaults.standard.setValue(newValue, forKey: #function)
        }
    }
}
