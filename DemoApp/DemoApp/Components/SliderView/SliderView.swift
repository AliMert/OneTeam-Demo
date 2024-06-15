//
//  SliderView.swift
//  DemoApp
//
//  Created by Ali Mert Özhayta on 15.06.2024.
//

import UIKit

protocol SliderViewDelegate {
    func didSelect(index: Int)
    func currentPageDidChanged(from oldIndex: Int, to newIndex: Int)
}

final class SliderView: UIView {
    
    // MARK: - Constants

    private enum Constants {
        static let padding: CGFloat = -4
    }

    // MARK: - Properties

    private var images: [UIImage] = []
    private var imageUrls: [String] = []
    var delegate: SliderViewDelegate?

    var currentPage: Int {
        pageControl.currentPage
    }

    var numberOfPages: Int {
        pageControl.numberOfPages
    }

    // MARK: - Views

    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.isPagingEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(SliderCollectionViewCell.self, forCellWithReuseIdentifier: "SliderCollectionViewCell")
        return collectionView
    }()

    private let pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.pageIndicatorTintColor = .label.withAlphaComponent(0.2)
        pageControl.currentPageIndicatorTintColor = .gray
        return pageControl
    }()

    // MARK: - Init

    init() {
        super.init(frame: .zero)
        setupView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    // MARK: - UI

    private func setupView() {
        fit(subview: collectionView)
            .first(where: { $0.secondAttribute == .bottom })?
            .isActive = false

        let pageControlConstraints = fit(subview: pageControl)
        pageControlConstraints
            .first(where: {$0.secondAttribute == .bottom})?
            .constant = Constants.padding

        pageControlConstraints
            .first(where: { $0.secondAttribute == .top })?
            .isActive = false

        collectionView.bottomAnchor.constraint(equalTo: pageControl.topAnchor, constant: Constants.padding).isActive = true


        collectionView.delegate = self
        collectionView.dataSource = self

        pageControl.addTarget(self, action: #selector(self.pageControlHandle), for: .valueChanged)
    }

    /// this method will be trigerred when user has integration with page control. For instance instead of swiping the collectionView, user can change the pageControl's current page by long pressing the page control and dragging it to the left or right.
    @objc private func pageControlHandle(sender: UIPageControl) {
        guard let cell = collectionView.visibleCells.first,
           let row = collectionView.indexPath(for: cell)?.row,
           row != sender.currentPage else {
           return
        }

        collectionView.collectionViewLayout.invalidateLayout()

        collectionView.scrollToItem(
            at: .init(row: sender.currentPage, section: .zero),
            at: .centeredHorizontally,
            animated: false
        )
        collectionView.collectionViewLayout.invalidateLayout()
    }
}

// MARK: - SliderView Public Methods

extension SliderView {

    public func setupView(images: [UIImage]) {
        self.images = images
        pageControl.numberOfPages = images.count
        collectionView.reloadData()
    }

    public func setupView(imageUrls: [String]) {
        self.imageUrls = imageUrls
        images = Array(repeating: UIImage(resource: .placeholder), count: imageUrls.count)
        setupView(images: images)
    }
}

// MARK: - UICollectionView Delegate Methods

extension SliderView:  UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        pageControl.numberOfPages
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SliderCollectionViewCell", for: indexPath) as? SliderCollectionViewCell else {
            return UICollectionViewCell()
        }

        cell.configure(with: images[safeIndex: indexPath.row] ?? .placeholder)
        cell.configure(placeholder: images[safeIndex: indexPath.row] ?? .placeholder, url: imageUrls[safeIndex: indexPath.row])
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.didSelect(index: indexPath.row)
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let visibleRectangle = CGRect(origin: collectionView.contentOffset, size: collectionView.bounds.size)
        let visiblePoint = CGPoint(x: visibleRectangle.midX, y: visibleRectangle.midY)

        guard let newPage = collectionView.indexPathForItem(at: visiblePoint)?.row else {
            return
        }

        let oldPage = pageControl.currentPage
        pageControl.currentPage = newPage
        delegate?.currentPageDidChanged(from: oldPage, to: newPage)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        collectionView.frame.size
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        .zero
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        .zero
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        .zero
    }
}
