//
//  DetailAssembly.swift
//  MVPAPIRickAndMortyApp
//
//  Created by Ярослав Кочкин on 30.03.2025.
//

import UIKit


final class DetailAssembly {
	
	private let navigationController: UINavigationController
	private let item: Character
	
	init(navigationController: UINavigationController, item: Character) {
		self.navigationController = navigationController
		self.item = item
	}
}

// MARK: - BaseAssembly

extension DetailAssembly: BaseAssembly {
	func configure(with viewController: UIViewController) {
		guard let detailVC = viewController as? DetailViewController else { return }
		let router = DetailRouter()
		let presenter = DetailPresenter(view: detailVC, router: router, item: item)
		
		detailVC.presenter = presenter
	}
}
