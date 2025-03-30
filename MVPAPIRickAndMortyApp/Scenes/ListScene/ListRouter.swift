//
//  ListRouter.swift
//  MVPAPIRickAndMortyApp
//
//  Created by Ярослав Кочкин on 28.03.2025.
//

import UIKit

protocol IListRouter: BaseRouting {
}

final class ListRouter {
	enum Target {
		case detailVC(character: Character)
		case clearCached
		case infoVC
	}
	
	private let navigationController: UINavigationController
	
	init(navigationController: UINavigationController) {
		self.navigationController = navigationController
	}
}

extension ListRouter: IListRouter {
	
	func routeTo(target: Any) {
		guard let target = target as? ListRouter.Target else { return }
		
		switch target {
		case .detailVC(let character):
			let detailVC = DetailViewController()
			let detailAssembly = DetailAssembly(navigationController: navigationController, item: character)
			detailAssembly.configure(with: detailVC)
			
			detailVC.modalPresentationStyle = .fullScreen
			navigationController.pushViewController(detailVC, animated: true)
		case .clearCached:
			let alert = UIAlertController(title: "Успешно!", message: "Память успешно очищена", preferredStyle: .alert)
			let action = UIAlertAction(title: "Продолжить", style: .default)
			alert.addAction(action)
			navigationController.topViewController?.present(alert, animated: true)
		case .infoVC:
			break
		}
	}
}
