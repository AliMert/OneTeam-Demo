//
//  TableViewCell.swift
//  DemoApp
//
//  Created by Ali Mert Özhayta on 15.06.2024.
//

import UIKit

final class TableViewCell: UITableViewCell {

    // MARK: - Constants

    private enum Constants {
        static let stackSpacing: CGFloat = 4
        static let imageSize = CGSize(width: 32, height: 32)
        static let padding = UIEdgeInsets(
            top: 8,
            left: 8,
            bottom: 8,
            right: 8
        )
    }

    // MARK: - Views

    private let label = UILabel()
    private let cellImageView = UIImageView()

    // MARK: - Init

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        prepareUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - UI

    private func prepareUI() {
        label.textAlignment = .center

        let stackView = UIStackView(arrangedSubviews: [cellImageView, label])
        stackView.spacing = Constants.stackSpacing
        contentView.fit(subview: stackView, padding: Constants.padding)

        let constrainst = [
            cellImageView.heightAnchor.constraint(equalToConstant: Constants.imageSize.height),
            cellImageView.widthAnchor.constraint(equalToConstant: Constants.imageSize.width)
        ]
        constrainst.first?.priority = .defaultHigh
        NSLayoutConstraint.activate(constrainst)
    }

    // MARK: - Internal Methods

    func configure(text: String?, image: UIImage? = nil) {
        label.text = text
        cellImageView.image = image ?? .placeholder2
    }

    func configure(withUrl endpoint: String) {
        label.text = "Data is fetching from network..."
        cellImageView.image = .placeholder2
    }
}
