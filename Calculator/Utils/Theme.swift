//
//  Theme.swift
//  Calculator
//
//  Created by Pavel on 27.10.22.
//

import UIKit

enum Theme: Int {
    case unspecified
    case light
    case dark
    
    func getUserInterfaceStyle() -> UIUserInterfaceStyle {
        switch self {
        case .unspecified:
            return .unspecified
        case .light:
            return .light
        case .dark:
            return .dark
        }
    }
}
