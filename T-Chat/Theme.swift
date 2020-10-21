//
//  Theme.swift
//  T-Chat
//
//  Created by Дмитрий on 07.10.2020.
//  Copyright © 2020 DP. All rights reserved.
//

import UIKit

enum Theme: Int {
    case classic, day, night
    
    private enum Keys {
        static let selectedTheme = "SelectedTheme"
    }
    
    static var current: Theme {
        let storedTheme = UserDefaults.standard.integer(forKey: Keys.selectedTheme)
        return Theme(rawValue: storedTheme) ?? .classic
    }
        
    var backgroundColor: UIColor {
        switch self {
        case .classic:
            return UIColor.white
        case .day:
            return UIColor(red: 229 / 255, green: 229 / 255, blue: 229 / 255, alpha: 1)
        case .night:
            return UIColor.darkGray
        }
    }
    
    var textColor: UIColor {
        switch self {
        case .classic, .day:
            return UIColor.black
        case .night:
            return UIColor.white
        }
    }
    
    var incomingMessageColor: UIColor {
        switch self {
        case .classic:
                return UIColor(red: 220 / 255, green: 247 / 255, blue: 197 / 255, alpha: 1)
        case .day:
            return UIColor(red: 64 / 255, green: 137 / 255, blue: 250 / 255, alpha: 1)
        case .night:
            return UIColor(red: 92 / 255, green: 92 / 255, blue: 92 / 255, alpha: 1)
        }
    }
    
    var outgoingMessageColor: UIColor {
        switch self {
        case .classic:
                return UIColor(red: 223 / 255, green: 223 / 255, blue: 223 / 255, alpha: 1)
        case .day:
            return UIColor(red: 234 / 255, green: 235 / 255, blue: 237 / 255, alpha: 1)
        case .night:
            return UIColor(red: 47 / 255, green: 47 / 255, blue: 47 / 255, alpha: 1)
        }
    }
    
    var messageBorderColor: CGColor {
        switch self {
        case .classic, .day:
            return UIColor.darkGray.cgColor
        case .night:
            return UIColor.white.cgColor
        }
    }
        
    var themeViewControllerBackgorundColor: UIColor {
        switch self {
        case .classic:
            return UIColor.white
        case .day:
            return UIColor(red: 229 / 255, green: 229 / 255, blue: 229 / 255, alpha: 1)
        case .night:
            return UIColor.darkGray
        }
    }
    
    func setCurrent() {
          UserDefaults.standard.set(rawValue, forKey: Keys.selectedTheme)
    }
}
