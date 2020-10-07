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
    
    var mainColor: UIColor {
      switch self {
      case .classic:
        return UIColor.systemBlue
      case .day:
        return UIColor.white
      case .night:
        return UIColor.black
      }
    }
    
    var backgroundColor: UIColor {
        switch self {
        case .classic:
            return UIColor.blue.withAlphaComponent(0.2)
        case .day:
            return UIColor.white
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
    
    var themeViewControllerBackgorundColor: UIColor {
        switch self {
        case .classic:
            return UIColor(red: 213/255, green: 247/255, blue: 185/255, alpha: 1)
        case .day:
            return UIColor(red: 53/255, green: 113/255, blue: 249/255, alpha: 1)
        case .night:
            return UIColor.darkGray
        }
    }
    
    func setCurrent() {
          UserDefaults.standard.set(rawValue, forKey: Keys.selectedTheme)
    }
}
