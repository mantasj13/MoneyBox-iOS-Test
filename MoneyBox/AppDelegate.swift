//
//  AppDelegate.swift
//  MoneyBox
//
//  Created by Zeynep Kara on 15.01.2022.
//

import UIKit
import SwiftUI

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    private let coordinator: MainCoordinator = {
        let navigationController = UINavigationController()
        let coordinator = MainCoordinator(navigationController: navigationController)
        return coordinator
    }()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        let window = UIWindow(frame: UIScreen.main.bounds)
        window.rootViewController = coordinator.navigationController
        window.makeKeyAndVisible()

        self.window = window
        coordinator.start()
        return true
    }
}
