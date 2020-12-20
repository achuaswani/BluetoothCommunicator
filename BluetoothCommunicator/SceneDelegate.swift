//
//  SceneDelegate.swift
//  BluetoothCommunicator
//
//  Created by Aswani G on 12/17/20.
//

import UIKit

@available(iOS 13.0, *)
class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }

        let window = UIWindow(windowScene: windowScene)
        window.rootViewController = BluetoothHomeViewController()
        self.window = window
        window.makeKeyAndVisible()
    }
}

