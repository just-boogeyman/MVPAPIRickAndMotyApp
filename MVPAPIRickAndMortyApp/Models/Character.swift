//
//  Character.swift
//  MVPAPIRickAndMortyApp
//
//  Created by Ярослав Кочкин on 28.03.2025.
//

import Foundation

struct Characters: Decodable {
	let info: Info
	let results: [Character]
}

struct Info: Decodable {
	let count: Int
	let pages: Int
	let next: String
}

struct Character: Decodable {
	let id: Int
	let name: String
	let status: String
	let species: String
	let image: String
	let location: Location
	let origin: Location
}

struct Location: Decodable {
	let name: String
}
