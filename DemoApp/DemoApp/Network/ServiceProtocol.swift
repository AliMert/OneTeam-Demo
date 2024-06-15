//
//  ServiceProtocol.swift
//  DemoApp
//
//  Created by Ali Mert Özhayta on 15.06.2024.
//
import Foundation

protocol ServiceProtocol {
    func fetchData<T: Decodable>(from urlString: String) async -> [T]?
}

extension ServiceProtocol {

    func fetchData<T: Decodable>(from urlString: String) async -> [T]? {
        guard let url = URL(string: urlString) else {
            return nil
        }

        let urlRequest = URLRequest(url: url)


        guard let (data, _) = try? await URLSession.shared.data(for: urlRequest),
              let response = try? JSONDecoder().decode([T].self, from: data) else {
            return nil
        }

        return response
    }
}
