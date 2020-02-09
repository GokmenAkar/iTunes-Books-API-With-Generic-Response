//
//  UserDefaults+Extensions.swift
//  iTunes
//
//  Created by Developer on 8.02.2020.
//

import Foundation

extension UserDefaults {
    var favoritesData: Data? {
        get {
            UserDefaults.standard.data(forKey: #function)
        } set {
            UserDefaults.standard.setValue(newValue, forKey: #function)
        }
    }
}
