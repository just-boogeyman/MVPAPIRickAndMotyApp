//
//  SceneDelegate.swift
//  MVPAPIRickAndMortyApp
//
//  Created by Ярослав Кочкин on 28.03.2025.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

	var window: UIWindow?
	
	func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
		guard let windowScene = scene as? UIWindowScene else { return }
		window = UIWindow(windowScene: windowScene)
		
		let vc = ListViewController()
		let navVC = UINavigationController(rootViewController: vc)
		
		window?.rootViewController = navVC
		window?.makeKeyAndVisible()
	}
}

