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
		let navVC = getNavigationController(viewController: vc)
		let listAssembly = ListAssembly(navigationController: navVC)
		listAssembly.configure(with: vc)
		
		window?.rootViewController = navVC
		window?.makeKeyAndVisible()
	}
}

func getNavigationController(viewController: UIViewController) -> UINavigationController {
	let navController = UINavigationController(rootViewController: viewController)
	navController.navigationBar.prefersLargeTitles = true
	
	let appearance = UINavigationBarAppearance()
	appearance.configureWithOpaqueBackground()
	appearance.backgroundColor = .darkGray
		
	appearance.titleTextAttributes = [
		.foregroundColor: UIColor(resource: .background),
		.font: UIFont.systemFont(ofSize: 18, weight: .bold)
	]
	
	appearance.largeTitleTextAttributes = [
		.foregroundColor: UIColor(resource: .background),
		.font: UIFont.systemFont(ofSize: 34, weight: .bold)
	]
	
	navController.navigationBar.standardAppearance = appearance
	navController.navigationBar.scrollEdgeAppearance = appearance
	
	return navController
}
