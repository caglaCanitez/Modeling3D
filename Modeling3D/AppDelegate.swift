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
        var vc: UIViewController!
        
        let isLogin = UserDefaults.standard.bool(forKey: GeneralConstants.UserDefault.isLoginState)
        if isLogin {
            let home = HomeViewController()
            let viewModel = Model3dViewModel()
            home.viewModel = viewModel
            vc = home
        } else {
            let login = LoginViewController()
            let viewModel = AuthenticationViewModel()
            login.viewModel = viewModel
            vc = login
        }
        
        self.window?.rootViewController = vc
        self.window?.makeKeyAndVisible()
        return true
    }
}

