//
//  ListPresenter.swift
//  MVPAPIRickAndMortyApp
//
//  Created by Ярослав Кочкин on 28.03.2025.
//

import UIKit
import Kingfisher

struct ViewModelList {
	let image: String
	let name: String
	let status: String
}

protocol IListPresenter {
	func render()
	func refresh()
	func clearCache()
	func pressedCell(_ index: Int)
	func filterContentForSearchText(_ searchText: String, scope: String)
}

final class ListPresenter {
	private weak var view: IListViewController?
	private let router: IListRouter
	private let networkManager: NetworkManager

	private var items: [Character] = []
	
	init(view: IListViewController, router: IListRouter, networkManager: NetworkManager) {
		self.view = view
		self.router = router
		self.networkManager = networkManager
		fetchCharacters()
	}
}

private extension ListPresenter {
	func fetchCharacters() {
		networkManager.fetch(
			Characters.self,
			url: "\(RickAndMortyAPI.characters.rawValue)\(Int.random(in: 1...42))") { [weak self] result in
				DispatchQueue.main.async {
					switch result {
					case .success(let items):
						self?.items = items.results
						self?.render()
					case .failure(let error):
						self?.view?.failure(error: error)
					}
				}
			}
	}
}

extension ListPresenter: IListPresenter {
	func filterContentForSearchText(_ searchText: String, scope: String) {
		// TODO: sorted по введеному значению
	}
	
	func pressedCell(_ index: Int) {
		let item = items[index]
		router.routeTo(target: ListRouter.Target.detailVC(character: item))
	}
	
	func clearCache() {
		let cache = ImageCache.default
		cache.clearMemoryCache()
		cache.clearDiskCache()
		router.routeTo(target: ListRouter.Target.clearCached)
	}
	
	func refresh() {
		fetchCharacters()
	}
	
	func render() {
		var characters: [ViewModelList] = []
		for item in items {
			let character = ViewModelList(image: item.image, name: item.name, status: item.status)
			characters.append(character)
		}
		view?.render(with: characters)
	}
}
