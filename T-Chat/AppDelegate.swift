//
//  AppDelegate.swift
//  T-Chat
//
//  Created by Дмитрий on 13.09.2020.
//  Copyright © 2020 DP. All rights reserved.
//

import UIKit
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    var coreDataStack = CoreDataStack()
    
    static var coreDataStack: CoreDataStack {
        return (UIApplication.shared.delegate as? AppDelegate)?.coreDataStack ?? CoreDataStack()
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        FirebaseApp.configure()
        Theme.current.setCurrent()
        
        AppDelegate.coreDataStack.didUpdateDataBase = { stack in
            stack.printDataBaseStatistice()
        }
        
        AppDelegate.coreDataStack.enableObservers()
        
        return true
    }
    
}
