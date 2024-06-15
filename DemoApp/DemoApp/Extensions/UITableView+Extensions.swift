//
//  UITableView+Extensions.swift
//  DemoApp
//
//  Created by Ali Mert Özhayta on 15.06.2024.
//

import UIKit

extension UITableView {

    func updateHeaderViewFrameToFitContent() {

        guard let size = tableHeaderView?.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize) else {
            return
        }

        tableHeaderView?.frame = .init(
            x: .zero,
            y: .zero,
            width: UIScreen.main.bounds.width,
            height: size.height
        )
    }
}
