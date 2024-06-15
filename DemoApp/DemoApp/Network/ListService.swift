//
//  ListService.swift
//  DemoApp
//
//  Created by Ali Mert Özhayta on 15.06.2024.
//

protocol ListServiceProtocol {
    func getList(endpoint: String) async -> [ListResponse]?
}

final class ListService: ListServiceProtocol, ServiceProtocol {

    func getList(endpoint: String) async -> [ListResponse]? {
        return await fetchData(from: endpoint)
    }
}
