//
//  AppDelegate.swift
//  ChainAnimations
//
//  Created by anyRTC on 2020/9/23.
//  Copyright © 2020 linshun. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        self.window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = PageController(collectionViewLayout: UICollectionViewFlowLayout())
        return true
    }
    
    // MARK: UISceneSession Lifecycle
    
    
    
}

