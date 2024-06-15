//
//  ViewModel.swift
//  DemoApp
//
//  Created by Ali Mert Özhayta on 15.06.2024.
//

import Foundation
import class UIKit.UIImage

final class ViewModel: ViewModelProtocol {

    // MARK: - Properties

    private(set) var tableData = [
        ["Red", "Blue", "Green", "Yellow", "Orange", "Purple", "Pink", "Brown", "Black", "White", "Gray", "Cyan", "Magenta", "Lime", "Indigo", "Violet", "Turquoise", "Teal", "Navy", "Coral", "Maroon", "Olive", "Silver", "Gold", "Beige"],
        ["Argentina", "Australia", "Bahrain", "Belgium", "Brazil", "Canada", "China", "Denmark", "Egypt", "Finland", "France", "Germany", "India", "Israel", "Italy", "Japan", "Mexico", "Netherlands", "New Zealand", "Nigeria", "Norway", "Russia", "Saudi Arabia", "South Africa", "South Korea", "Spain", "Sweden", "Turkey", "United Arab Emirates", "United Kingdom", "United States"],
        ["Apple", "Banana", "Orange", "Grapes", "Strawberry", "Blueberry", "Mango", "Pineapple", "Watermelon", "Peach", "Cherry", "Lemon", "Lime", "Kiwi", "Pear"],
        ["iPhone", "iPad", "MacBook Pro", "MacBook Air", "Mac Studio", "iMac", "Mac Mini", "Apple Watch", "Apple TV 4K", "AirPods Pro", "AirPods Max", "HomePod"]
    ]

    let tableDataUrlList = [
        "https://jsonplaceholder.typicode.com/posts",
        "https://jsonplaceholder.typicode.com/albums",
        "https://jsonplaceholder.typicode.com/todos",
        "https://jsonplaceholder.typicode.com/photos"
    ]

    let imageData: [UIImage] = [
        UIImage(resource: .image1),
        UIImage(resource: .image2),
        UIImage(resource: .image3),
        UIImage(resource: .image4)
    ]

    let imageUrlData: [String] = [
        "https://images.pexels.com/photos/1374295/pexels-photo-1374295.jpeg",
        "https://images.pexels.com/photos/1374295/pexels-photo-1374295.jpeg",
        "https://images.pexels.com/photos/982263/pexels-photo-982263.jpeg",
        "https://images.pexels.com/photos/1933239/pexels-photo-1933239.jpeg",
        "https://images.pexels.com/photos/539711/pexels-photo-539711.jpeg"
    ]

    weak var delegate: ViewModelDelegate?
    var filteredTableData: [String] = []

    private let listService: ListServiceProtocol

    // MARK: - Init

    init(listService: ListServiceProtocol) {
        self.listService = listService
    }

    // MARK: - Methods

    func fetchListDataFromNetwork(numberOfPages: Int) {
        tableData.removeAll()

        tableDataUrlList
            // MARK: DEV_NOTES
            /// if sliderView has less data than the list, there is no need for extra network request.
            .prefix(numberOfPages)
            .enumerated().forEach { index, endpoint in
            Task { [weak self] in
                guard let self,
                      let response = await self.listService.getList(endpoint: endpoint) else {
                    return
                }

                // MARK: DEV_NOTES
                /// api service returns more data than necessary, so I capped it at 30
                let filteredResponse = response.prefix(30).compactMap({ $0.title })

                if index < self.tableData.count {
                    self.tableData.insert(filteredResponse, at: index)
                } else {
                    self.tableData.append(filteredResponse)
                }

                Task { @MainActor [weak self] in
                    self?.delegate?.handleViewModelOutput(.shouldReloadTableView(for: index))
                }
            }
        }
    }
}

