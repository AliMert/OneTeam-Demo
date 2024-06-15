//
//  SliderCollectionViewCell.swift
//  DemoApp
//
//  Created by Ali Mert Özhayta on 15.06.2024.
//

import UIKit

final class SliderCollectionViewCell: UICollectionViewCell {

    // MARK: - Views

    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()

    private let shadowView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.alpha = 0.4
        return view
    }()

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: .zero)

        fit(subview: shadowView)
        fit(subview: imageView)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Internal Methods

    func configure(with image: UIImage) {
        imageView.image = image
    }

    func configure(placeholder image: UIImage, url: String?) {
        imageView.image = image

        guard let url else {
            return
        }

        Task {
            guard let image = await ImageManager.shared.fetchImage(from: url) else {
                return
            }
            imageView.image = image
        }
    }
}
