//
//  ListCustomViewCell.swift
//  MVPAPIRickAndMortyApp
//
//  Created by Ярослав Кочкин on 28.03.2025.
//

import UIKit
import Kingfisher

final class CustomViewCell: UIView {
		
	// MARK: - Lazy Properties
	
	private lazy var nameLabel = CustomLabel(
		font: Constants.fontLabel,
		size: Constants.sizeNameLabel
	)
	private lazy var statusLabel = CustomLabel(
		font: Constants.fontLabel,
		size: Constants.sizeStatusLabel
	)
	private lazy var imageView = UIImageView()
	private lazy var statusView = UIView()
	
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		setupView()
	}
	
	@available (*, unavailable)
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	// MARK: - Public Metods
	
	func configure(_ item: ViewModelList) {
		nameLabel.text = item.name
		statusLabel.text = item.status
		updateStatus(status: item.status)
		fetchImage(image: item.image)
	}
}

// MARK: - Setup Views

private extension CustomViewCell {
	func setupView() {
		backgroundColor = .lightGray
		layer.cornerRadius = 12
		addView()
		setupImage()
		setupLabel()
		setupStatus()
		layout()
	}
	
	func addView() {
		[nameLabel, imageView, statusView, statusLabel].forEach {
			addSubview($0)
			$0.translatesAutoresizingMaskIntoConstraints = false
		}
	}
	
	func setupImage() {
		imageView.contentMode = .scaleAspectFit
		imageView.clipsToBounds = true
		imageView.layer.cornerRadius = 12
	}
	
	func setupLabel() {
		nameLabel.textAlignment = .left
		statusLabel.textAlignment = .left
		nameLabel.numberOfLines = 0
	}
	
	func setupStatus() {
		statusView.backgroundColor = .green
		statusView.widthAnchor.constraint(equalToConstant: 14).isActive = true
		statusView.heightAnchor.constraint(equalToConstant: 14).isActive = true
		statusView.layer.cornerRadius = 7
	}
}

// MARK: - Private Methods

private extension CustomViewCell {
	func updateStatus(status: String) {
		switch status {
		case "Alive":
			statusView.backgroundColor = .green
		case "Dead":
			statusView.backgroundColor = .red
		default:
			statusView.backgroundColor = .cyan
		}
	}
	
	func fetchImage(image: String) {
		let url = URL(string: image)
		let processor = ResizingImageProcessor(referenceSize: CGSize(width: 300, height: 300))
		imageView.kf.indicatorType = .activity
		imageView.kf.setImage(
			with: url,
			options: [
				.processor(processor),
				.scaleFactor(UIScreen.main.scale),
				.transition(.fade(1)),
				.cacheOriginalImage
			])
	}
}

// MARK: - Layout

private extension CustomViewCell {
	func layout() {
		NSLayoutConstraint.activate([
			imageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 4),
			imageView.topAnchor.constraint(equalTo: topAnchor, constant: 4),
			imageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -4),
			imageView.widthAnchor.constraint(equalTo: heightAnchor, multiplier: 0.9),
			
			nameLabel.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 8),
			nameLabel.topAnchor.constraint(equalTo: topAnchor, constant: 8),
			nameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
			
			statusView.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 14),
			statusView.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 12),
			
			statusLabel.leadingAnchor.constraint(equalTo: statusView.trailingAnchor, constant: 8),
			statusLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 12),
			statusLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8)
		])
	}
}


// MARK: - Constants

private extension CustomViewCell {
	enum Constants {
		static let fontLabel = "Arial Rounded MT Bold"
		static let sizeNameLabel: CGFloat = 20
		static let sizeStatusLabel: CGFloat = 14
	}
}
