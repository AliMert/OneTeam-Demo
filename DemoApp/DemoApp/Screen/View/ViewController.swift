//
//  ViewController.swift
//  DemoApp
//
//  Created by Ali Mert Özhayta on 15.06.2024.
//

import UIKit

final class ViewController: UIViewController {

    // MARK: - Constants

    private enum Constants {
        static let sliderViewHeight: CGFloat = 250
    }

    // MARK: - Properties

    private var viewModel: ViewModelProtocol!
    private var isSearch = false

    // MARK: DEV_NOTES
    /// if you want to load data from local set to `true`
    /// if you want to load data from network set to `false`
    ///
    private var shouldUseLocalData = true

    // MARK: - Views

    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(TableViewCell.self, forCellReuseIdentifier: "TableViewCell")
        tableView.allowsSelection = false
        tableView.sectionHeaderTopPadding = .zero
        return tableView
    }()

    private let searchBar = UISearchBar()
    private let sliderView = SliderView()

    // MARK: - Init

    convenience init(viewModel: ViewModelProtocol) {
        self.init()
        self.viewModel = viewModel
        self.viewModel.delegate = self
    }

    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        preapareUI()

        // MARK: DEV_NOTES
        /// sliderView's images can be set from local or remote
        /// use setupView(images: [UIImage]) for images that are located in resources
        /// use setupView(imageUrls: [String]) for downloading and then showing the images. While the image is downloading a placeholder image will be shown in the mean time
        ///
        shouldUseLocalData
        ? sliderView.setupView(images: viewModel.imageData)
        : sliderView.setupView(imageUrls: viewModel.imageUrlData)

        // MARK: DEV_NOTES
        /// removes sliderView if there is no image that could be displayed
        if sliderView.numberOfPages <= .zero {
            tableView.tableHeaderView = nil
        }

        // MARK: DEV_NOTES
        /// if you want to fetch the data from network please set  `shouldUseLocalData` to false or change the code
        /// `fetchListDataFromNetwork(numberOfPages:)` method  will try to fetch the data from the `viewModel.tableDataUrlList`
        ///
        if !shouldUseLocalData {
            viewModel.fetchListDataFromNetwork(numberOfPages: sliderView.numberOfPages)
        }
    }

    // MARK: - UI

    private func preapareUI() {
        view.backgroundColor = .systemBackground

        view.fitToSafeArea(subview: tableView)
        tableView.tableHeaderView = sliderView

        sliderView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            sliderView.widthAnchor.constraint(equalTo: tableView.widthAnchor),
            sliderView.heightAnchor.constraint(equalToConstant: Constants.sliderViewHeight),
        ])

        sliderView.delegate = self
        tableView.dataSource = self
        tableView.delegate = self
        searchBar.delegate = self
        searchBar.enablesReturnKeyAutomatically = false

        tableView.updateHeaderViewFrameToFitContent()
    }
}

// MARK: - UISearchBarDelegate

extension ViewController: UISearchBarDelegate {

    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        isSearch = true
    }

    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        isSearch = false
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        isSearch = false
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        isSearch = false
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        isSearch = searchText.count != .zero

        if isSearch {
            viewModel.filteredTableData = viewModel.tableData[sliderView.currentPage].filter {
                $0.range(of: searchText, options: .caseInsensitive)?.isEmpty == false
            }
        }

        tableView.reloadData()
    }
}

// MARK: - UITableViewDelegate

extension ViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        searchBar
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath) as? TableViewCell else {
            return .init()
        }

        let array = isSearch
        ? viewModel.filteredTableData
        : viewModel.tableData[safeIndex: sliderView.currentPage]

        let text = array?[safeIndex: indexPath.row] ?? nil
        // MARK: DEV_NOTES
        /// if data is fetching from the network there will be only one cell and the cell's label's text will be set to "Loading..."
        cell.configure(text: text ?? (viewModel.tableDataUrlList.isEmpty ? nil : "Loading..."))
        return cell
    }
}

// MARK: - UITableViewDataSource

extension ViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSearch {
            return viewModel.filteredTableData.count
        }

        // MARK: DEV_NOTES
        /// if data is fetching from the network there will be only one cell else zero
        guard let count = viewModel.tableData[safeIndex: sliderView.currentPage]?.count else {
            return sliderView.currentPage < viewModel.tableDataUrlList.count ? 1 : 0
        }
        return count
    }
}

// MARK: - SliderViewDelegate

extension ViewController: SliderViewDelegate {

    func didSelect(index: Int) {
        // MARK: DEV_NOTES
        /// we can use this method to navigate another page when an image in the sliderView is clicked (tapped)
    }

    func currentPageDidChanged(from oldIndex: Int, to newIndex: Int) {
        searchBar.text = ""
        searchBar.resignFirstResponder()
        tableView.reloadData()
    }
}

// MARK: - ViewModelDelegate

extension ViewController: ViewModelDelegate {

    func handleViewModelOutput(_ output: ViewModelOutput) {
        switch output {
        case .shouldReloadTableView(let index):
            if sliderView.currentPage == index {
                tableView.reloadData()
            }
        }
    }
}
