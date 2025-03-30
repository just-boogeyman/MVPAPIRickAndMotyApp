//
//  ListCell.swift
//  MVPAPIRickAndMortyApp
//
//  Created by Ярослав Кочкин on 28.03.2025.
//

import UIKit

final class ListCell: UITableViewCell {
	
	private lazy var customView = CustomViewCell()
	
	// MARK: - Init
	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		setup()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	func configure(with item: ViewModelList) {
		customView.configure(item)
	}
}

private extension ListCell {
	func setup() {
		backgroundColor = .darkGray
		addSubview(customView)
		layout()
	}
}

private extension ListCell {
	func layout() {
		customView.translatesAutoresizingMaskIntoConstraints = false
		
		NSLayoutConstraint.activate([
			customView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
			customView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
			customView.topAnchor.constraint(equalTo: topAnchor, constant: 8),
			customView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8),
		])
	}
}
