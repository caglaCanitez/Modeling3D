//
//  AppDelegate.swift
//  Modeling3D
//
//  Created by Cagla Canitez on 24.12.2022.
//

import UIKit
import FirebaseCore
@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        FirebaseApp.configure()
        
        self.window = UIWindow(frame: UIScreen.main.bounds)
//        var vc: UIViewController!
        var vc = LoginViewController()
        var viewModel = AuthenticationViewModel()
        vc.viewModel = viewModel
        
        self.window?.rootViewController = vc
        self.window?.makeKeyAndVisible()
        return true
    }
}

