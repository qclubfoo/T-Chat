//
//  AppDelegate.swift
//  T-Chat
//
//  Created by Дмитрий on 13.09.2020.
//  Copyright © 2020 DP. All rights reserved.
//

import UIKit

// включение/выключение логов
let logIsEnabled = true

func logMessage(message: String, _ isEnabled: Bool) {
    if isEnabled {
        print(message)
    }
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        logMessage(message: "Application moved from <Not running> to <Incactive>: <\(#function)>", logIsEnabled)
        return true
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        logMessage(message: "Application moved from <Background> to <Inactive>: <\(#function)>", logIsEnabled)
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        logMessage(message: "Application moved from <Inactive> to <Active>: <\(#function)>", logIsEnabled)
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        logMessage(message: "Application moved from <Active> to <Inactive>: <\(#function)>", logIsEnabled)
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        logMessage(message: "Application moved from <Inactive> to <Background>: <\(#function)>", logIsEnabled)
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        logMessage(message: "Application moved from <Background> to <Suspended> or <Not running>: <\(#function)>", logIsEnabled)
    }
    
    



}

