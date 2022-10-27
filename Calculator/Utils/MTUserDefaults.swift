//
//  MTUserDefaults.swift
//  Calculator
//
//  Created by Pavel on 27.10.22.
//

import Foundation

struct MTUserDefaults {
    
    // MARK: - Singleton
    static var shared = MTUserDefaults()
    
    var theme: Theme {
        get {
            Theme(rawValue: UserDefaults.standard.integer(forKey: "theme")) ?? .unspecified
        }
        set {
            UserDefaults.standard.set(newValue.rawValue, forKey: "theme")
        }
    }
}
