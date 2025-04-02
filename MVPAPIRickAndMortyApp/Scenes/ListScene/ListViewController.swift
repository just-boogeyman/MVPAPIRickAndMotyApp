//
//  ViewController.swift
//  MVPAPIRickAndMortyApp
//
//  Created by Ярослав Кочкин on 28.03.2025.
//

import UIKit

protocol IListViewController: AnyObject {
	func failure(error: Error)
	func render(with items: [ViewModelList])
	func refresh()
}

final class ListViewController: UITableViewController {
	
	var presenter: IListPresenter?
	
	// MARK: - Private Property
	
	private let cellIdentifier = "cellList"
	private var items: [ViewModelList] = []
	private let searchController = UISearchController(searchResultsController: nil)

	private var searchBarIsEmpty: Bool {
		guard let text = searchController.searchBar.text else { return false }
		return text.isEmpty
	}
	
	private var isFiltering: Bool {
		let searchBarScopeIsFiltering = searchController.searchBar.selectedScopeButtonIndex != 0
		return searchController.isActive && (!searchBarIsEmpty || searchBarScopeIsFiltering)
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		setupView()
	}
}

// MARK: - IListViewController

extension ListViewController: IListViewController {
	func refresh() {
		self.searchController.searchBar.selectedScopeButtonIndex = 0
	}
	
	func failure(error: Error) {
		// TODO: что-то делаем если данных нет
		print(error.localizedDescription)
	}
	
	func render(with items: [ViewModelList]) {
		self.items = items
		tableView.reloadData()
		if refreshControl != nil {
			refreshControl?.endRefreshing()
		}
	}
}

// MARK: - Private SetupView

private extension ListViewController {
	func setupView() {
		view.backgroundColor = .darkGray
		title = Constants.title
		setupTableView()
		setupSearchController()
		setupScopeBar()
		setupRefreshControl()
		presenter?.render()
	}
	
	func setupTableView() {
		tableView.backgroundColor = .darkGray
		tableView.register(ListCell.self, forCellReuseIdentifier: cellIdentifier)
		tableView.rowHeight = 115
		tableView.separatorStyle = .none
		tableView.delegate = self
		tableView.dataSource = self
	}
	
	func setupSearchController() {
		searchController.searchResultsUpdater = self
		searchController.obscuresBackgroundDuringPresentation = false
		searchController.searchBar.placeholder = Constants.searchPlaceholder
		searchController.searchBar.barTintColor = .white
		searchController.searchBar.tintColor = .systemPurple
		searchController.searchBar.searchBarStyle = .minimal
		
		let buttonTrash = UIBarButtonItem(
			barButtonSystemItem: .trash,
			target: self,
			action: #selector(clearCache)
		)
		let buttonInfo = UIBarButtonItem(
			barButtonSystemItem: .bookmarks,
			target: self,
			action: #selector(infoApplication)
		)

		buttonTrash.tintColor = .systemPurple
		buttonInfo.tintColor = .systemPurple
		
		navigationItem.rightBarButtonItem = buttonTrash
		navigationItem.leftBarButtonItem = buttonInfo
		
		navigationItem.searchController = searchController
		definesPresentationContext = true
	}
	
	func setupScopeBar() {
		let scopeBarAppearance = UISearchBar.appearance()
		scopeBarAppearance.setScopeBarButtonTitleTextAttributes(
			[.foregroundColor: UIColor.gray], for: .normal)
			   
		searchController.searchBar.scopeButtonTitles = Constants.allScope
		searchController.searchBar.delegate = self
		
		if let textField = searchController.searchBar.value(forKey: "searchField") as? UITextField {
			textField.font = UIFont.boldSystemFont(ofSize: 17)
			textField.textColor = .white
			textField.backgroundColor = .lightGray
		}
	}
	
	func setupRefreshControl() {
		refreshControl = UIRefreshControl()
		refreshControl?.tintColor = .systemPurple
		let attributes: [NSAttributedString.Key: Any] = [
			.foregroundColor: UIColor.systemPurple,
			.font: UIFont.systemFont(ofSize: 16)
		]
		let attributedTitle = NSAttributedString(
			string: Constants.refreshAttributeString,
			attributes: attributes
		)
		refreshControl?.attributedTitle = attributedTitle
		refreshControl?.addTarget(self, action: #selector(chengeRefresh), for: .valueChanged)
	}
}

// MARK: - Action

private extension ListViewController {
	@objc func clearCache() {
		presenter?.clearCache()
	}
	
	@objc func infoApplication() {
		// TODO: Переход на экран и информацией
	}
	
	@objc private func chengeRefresh() {
		presenter?.refresh()
	}
}

// MARK: - UITableViewDataSource

extension ListViewController {
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		items.count
	}
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard let cell = tableView.dequeueReusableCell(
			withIdentifier: cellIdentifier,
			for: indexPath
		) as? ListCell else { return UITableViewCell() }
		
		let item = items[indexPath.row]
		cell.configure(with: item)
		
		return cell
	}
}

// MARK: - UITableViewDelegate

extension ListViewController {
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: true)
		presenter?.pressedCell(indexPath.row)
	}
}

// MARK: - UISearchBarDelegate

extension ListViewController: UISearchBarDelegate {
	func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
		presenter?.filterContentForSearchText(
			searchBar.text!,
			scope: searchBar.scopeButtonTitles![selectedScope],
			isFiltering: isFiltering,
			searchBarIsEmpty: searchBarIsEmpty
		)
	}
	
	func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
		if searchController.isActive {
			searchBar.showsScopeBar = false
			searchBar.selectedScopeButtonIndex = 0
		}
	}
}

// MARK: - UISearchResultsUpdating

extension ListViewController: UISearchResultsUpdating {
	func updateSearchResults(for searchController: UISearchController) {
		let searchBar = searchController.searchBar
		let scope = searchBar.scopeButtonTitles![searchBar.selectedScopeButtonIndex]
		if searchController.isActive {
			searchBar.setShowsScope(true, animated: true)
		}
		presenter?.filterContentForSearchText(
			searchController.searchBar.text!,
			scope: scope,
			isFiltering: isFiltering,
			searchBarIsEmpty: searchBarIsEmpty
		)
	}
}

// MARK: - Enum Constants

extension ListViewController {
	private enum Constants {
		static let title = "Rick and Morty"
		static let searchPlaceholder = "Search"
		static let allScope = ["All", "Alive", "Dead", "unknown"]
		
		static let alertTitle = "Cached"
		static let alertMessage = "Память устройства, очищена!"
		static let alertOk = "Ok"
		
		static let refreshAttributeString = "Обновление..."
	}
}
