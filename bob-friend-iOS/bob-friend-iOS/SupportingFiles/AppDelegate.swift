//
//  AppDelegate.swift
//  bob-friend-iOS
//
//  Created by 김수진 on 2021/08/25.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = ViewContoller()
        window?.makeKeyAndVisible()
        
        return true
    }

}

