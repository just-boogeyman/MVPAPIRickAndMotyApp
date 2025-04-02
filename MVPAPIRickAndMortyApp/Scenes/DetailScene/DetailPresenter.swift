//
//  DetailPresenter.swift
//  MVPAPIRickAndMortyApp
//
//  Created by Ярослав Кочкин on 30.03.2025.
//

import UIKit

protocol IDetailPresenter {
	func render()
}

final class DetailPresenter {
	
	private weak var view: IDetailViewController!
	private let router: IDetailRouter!
	private let item: Character!
	
	init(view: IDetailViewController, router: IDetailRouter, item: Character) {
		self.view = view
		self.router = router
		self.item = item
	}
}

// MARK: - IDetailPresenter

extension DetailPresenter: IDetailPresenter {
	func render() {
		view.render(item)
	}
}
