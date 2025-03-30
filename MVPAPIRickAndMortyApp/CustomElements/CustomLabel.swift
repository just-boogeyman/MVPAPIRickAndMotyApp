//
//  CustomLabel.swift
//  MVPAPIRickAndMortyApp
//
//  Created by Ярослав Кочкин on 28.03.2025.
//

import UIKit

final class CustomLabel: UILabel {
		
	init(font: String, size: CGFloat, color: UIColor = .white) {
		super.init(frame: .zero)
		setupLabel(fontName: font, size: size, color: color)
	}
	
	@available(*, unavailable)
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}

// MARK: - SetupLabel
extension CustomLabel {
	private func setupLabel(fontName: String, size: CGFloat, color: UIColor) {
		font = UIFont(name: fontName, size: size)
		textColor = color
		textAlignment = .left
	}
}

