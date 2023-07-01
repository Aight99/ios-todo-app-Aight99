//
//  SceneDelegate.swift
//  ToDo
//
//  Created by ios_developer on 15.06.2023.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        let taskTableVC = TaskTableController()
        let navigationController = UINavigationController(rootViewController: taskTableVC)
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }
}

