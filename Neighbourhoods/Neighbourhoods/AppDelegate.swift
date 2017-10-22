//
//  AppDelegate.swift
//  Neighbourhoods
//
//  Created by Weslie on 11/10/2017.
//  Copyright © 2017 NJQL. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        UITabBar.appearance().tintColor = navAndTabBarTintColor
        UINavigationBar.appearance().tintColor = navAndTabBarTintColor
        
        return true
    }

}

