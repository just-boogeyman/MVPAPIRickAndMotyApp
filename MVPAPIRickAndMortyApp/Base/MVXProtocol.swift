//
//  MVXProtocol.swift
//  MVPAPIRickAndMortyApp
//
//  Created by Ярослав Кочкин on 28.03.2025.
//

import UIKit

protocol BaseAssembly {
	func configure(with viewController: UIViewController)
}

protocol BaseRouting {
	func routeTo(target: Any)
	init(navigationController: UINavigationController)
}
