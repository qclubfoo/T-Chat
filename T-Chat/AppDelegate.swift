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
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        FirebaseApp.configure()
        Theme.current.setCurrent()
        
        coreDataStack.didUpdateDataBase = { stack in
            stack.printDataBaseStatistice()
        }
        
        coreDataStack.enableObservers()
        
        return true
    }
    
}
