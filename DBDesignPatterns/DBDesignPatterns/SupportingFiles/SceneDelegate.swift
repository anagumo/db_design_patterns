//
//  SceneDelegate.swift
//  DBDesignPatterns
//
//  Created by Ariana Rodríguez on 18/03/25.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let scene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: scene)
        let rootController = SplashBuilder().build()
        window?.rootViewController = rootController
        window?.makeKeyAndVisible()
    }
}
