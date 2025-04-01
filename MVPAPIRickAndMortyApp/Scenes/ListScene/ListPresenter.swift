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
	func filterContentForSearchText(_ searchText: String, scope: String, isFiltering: Bool, searchBarIsEmpty: Bool)
}

final class ListPresenter {
	private weak var view: IListViewController?
	private let router: IListRouter
	private let networkManager: INetworkManager

	private var items: [Character] = []
	private var filteredCharacters: [Character] = []

	
	init(view: IListViewController, router: IListRouter, networkManager: INetworkManager) {
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
	
	func getListModels(items: [Character]) -> [ViewModelList] {
		var listModels: [ViewModelList] = []
		for item in items {
			let model = ViewModelList(image: item.image, name: item.name, status: item.status)
			listModels.append(model)
		}
		return listModels
	}
}

extension ListPresenter: IListPresenter {
	func filterContentForSearchText(_ searchText: String, scope: String, isFiltering: Bool, searchBarIsEmpty: Bool) {
		if isFiltering {
			filteredCharacters = items.filter({ (item: Character) -> Bool in
				let doesCategoryMatch = (scope == "All") || (item.status == scope)
				if searchBarIsEmpty {
					return doesCategoryMatch
				} else {
					return doesCategoryMatch && item.name.lowercased().contains(searchText.lowercased())
				}
			})
			let characters = getListModels(items: filteredCharacters)
			view?.render(with: characters)
		} else {
			render()
		}
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
		view?.refresh()
	}
	
	func render() {
		let characters = getListModels(items: items)
		view?.render(with: characters)
	}
}
