//
//  AppDelegate.swift
//  T-Chat
//
//  Created by Дмитрий on 13.09.2020.
//  Copyright © 2020 DP. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        print("Application moved from <Not running> to <Incactive>: <\(#function)>")
        return true
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        print("Application moved from <Background> to <Inactive>: <\(#function)>")
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        print("Application moved from <Inactive> to <Active>: <\(#function)>")
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        print("Application moved from <Active> to <Inactive>: <\(#function)>")
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        print("Application moved from <Inactive> to <Background>: <\(#function)>")
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        print("Application moved from <Background> to <Suspended> or <Not running>: <\(#function)>")
    }
    
    



}

