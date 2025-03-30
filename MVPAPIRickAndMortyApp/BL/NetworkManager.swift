//
//  NetworkManager.swift
//  MVPAPIRickAndMortyApp
//
//  Created by Ярослав Кочкин on 28.03.2025.
//

import Foundation

enum RickAndMortyAPI: String {
	case characters = "https://rickandmortyapi.com/api/character?page="
	case locations = "https://rickandmortyapi.com/api/location"
	case episodes = "https://rickandmortyapi.com/api/episode"
}

enum NetworkError: Error {
	case invalidURL
	case noData
	case decodingError
}

protocol INetworkManager {
	func fetch<T: Decodable>(_ type: T.Type, url: String, completion: @escaping(Result<T, NetworkError>) -> Void)
}

final class NetworkManager: INetworkManager {
	func fetch<T: Decodable>(_ type: T.Type, url: String, completion: @escaping(Result<T, NetworkError>) -> Void) {
		guard let url = URL(string: url) else {
			completion(.failure(.invalidURL))
			return
		}
		URLSession.shared.dataTask(with: url) { data, _, error in
			guard let data = data else {
				completion(.failure(.noData))
				return
			}
			do {
				let decoder = JSONDecoder()
				decoder.keyDecodingStrategy = .convertFromSnakeCase
				let type = try decoder.decode(T.self, from: data)
				DispatchQueue.main.async {
					completion(.success(type))
				}
			} catch {
				completion(.failure(.decodingError))
			}
		}.resume()
	}
}
