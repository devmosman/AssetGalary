//
//  AppDelegate.swift
//  Asset Manager
//
//  Created by Marwan on 14/06/2022.
//

import UIKit
import IQKeyboardManagerSwift
import SideMenuSwift

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    
    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.shouldResignOnTouchOutside = true
        
        window = UIWindow(frame: UIScreen.main.bounds)
        if LocalData().authToken == "" {
            let navController = UINavigationController(rootViewController: LoginViewController())
            navController.navigationBar.setBackgroundImage(UIImage(), for: .default)
            navController.navigationBar.shadowImage = UIImage()
            navController.navigationBar.tintColor = .black
            navController.navigationBar.titleTextAttributes = [
                NSAttributedString.Key.font : UIFont.systemFont(ofSize: 20, weight: .semibold)
            ]
            window?.rootViewController = navController
            window?.makeKeyAndVisible()
        } else {
            let navController = UINavigationController(rootViewController: AssetsViewController())
            navController.navigationBar.setBackgroundImage(UIImage(), for: .default)
            navController.navigationBar.shadowImage = UIImage()
            navController.navigationBar.tintColor = .black
            navController.navigationBar.titleTextAttributes = [
                NSAttributedString.Key.font : UIFont.systemFont(ofSize: 20, weight: .semibold)
            ]
            let sideMenuVC = SideMenuViewController()
            let sideMenuController = SideMenuController(contentViewController: navController, menuViewController: sideMenuVC)
            window?.rootViewController = sideMenuController
            window?.makeKeyAndVisible()
        }

        
        
        return true
    }


}

