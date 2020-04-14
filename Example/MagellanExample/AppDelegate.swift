//
//  AppDelegate.swift
//  MagellanExample
//
//  Created by Iskander Foatov on 14.04.2020.
//  Copyright © 2020 Iskander Foatov. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        let demoController = DemoViewController()
        demoController.items = [EmptyDemo()]
        
        let navigationController = UINavigationController()
        navigationController.viewControllers = [demoController]
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
        
        return true
    }

}

