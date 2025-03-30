//
//  ListAssembly.swift
//  MVPAPIRickAndMortyApp
//
//  Created by Ярослав Кочкин on 28.03.2025.
//

import UIKit

final class ListAssembly {
	private let navigationController: UINavigationController
	
	init(navigationController: UINavigationController) {
		self.navigationController = navigationController
	}
}

extension ListAssembly: BaseAssembly {
	func configure(with viewController: UIViewController) {
		guard let listVC = viewController as? ListViewController else { return }
		let networkManager = NetworkManager()
		let router = ListRouter(navigationController: navigationController)
		let presenter = ListPresenter(view: listVC, router: router, networkManager: networkManager)
		
		listVC.presenter = presenter
	}
}


