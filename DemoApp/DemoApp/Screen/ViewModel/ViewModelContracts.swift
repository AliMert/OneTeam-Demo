//
//  ViewModelContracts.swift
//  DemoApp
//
//  Created by Ali Mert Özhayta on 15.06.2024.
//

import class UIKit.UIImage

protocol ViewModelProtocol {
    var delegate: ViewModelDelegate? { get set }
    var tableData: [[String]] { get }
    var tableDataUrlList: [String] { get }
    var imageData: [UIImage] { get }
    var imageUrlData: [String] { get }
    var filteredTableData: [String] { get set }
    var shouldUseLocalData: Bool { get }

    func fetchListDataFromNetwork(numberOfPages: Int)
}

protocol ViewModelDelegate: AnyObject {
    func handleViewModelOutput(_ output: ViewModelOutput)
}

enum ViewModelOutput: Equatable {
    case shouldReloadTableView(for: Int)
}
