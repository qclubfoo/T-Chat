//
//  AppDelegate.swift
//  T-Chat
//
//  Created by Дмитрий on 13.09.2020.
//  Copyright © 2020 DP. All rights reserved.
//

import UIKit

// включение/выключение логов
let logIsEnabled = false

func logMessage(message: String) {
    if logIsEnabled {
        print(message)
    }
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        Theme.current.setCurrent()
        return true
    }
    
    func application(_ application: UIApplication, willFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        
        logMessage(message: "Application moved from <Not running> to <Incactive>: <\(#function)>")
        return true
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        logMessage(message: "Application moved from <Background> to <Inactive>: <\(#function)>")
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        logMessage(message: "Application moved from <Inactive> to <Active>: <\(#function)>")
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        logMessage(message: "Application moved from <Active> to <Inactive>: <\(#function)>")
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        logMessage(message: "Application moved from <Inactive> to <Background>: <\(#function)>")
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        logMessage(message: "Application moved from <Background> to <Suspended> or <Not running>: <\(#function)>")
    }
}
