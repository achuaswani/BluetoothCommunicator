//
//  AppDelegate.swift
//  BluetoothCommunicator
//
//  Created by Aswani G on 12/17/20.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        UIApplication.shared.applicationIconBadgeNumber = 0
        window = UIWindow()
        window?.rootViewController = BluetoothHomeViewController()
        window?.makeKeyAndVisible()
        return true
    }
}

