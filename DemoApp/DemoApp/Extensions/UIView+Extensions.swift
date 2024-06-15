//
//  UIView+Extensions.swift
//  DemoApp
//
//  Created by Ali Mert Özhayta on 15.06.2024.
//

import UIKit

extension UIView {

    @discardableResult
    func fit(subview: UIView, padding: UIEdgeInsets = .zero) -> [NSLayoutConstraint] {
        if !subviews.contains(subview) {
            addSubview(subview)
        }

        subview.translatesAutoresizingMaskIntoConstraints = false

        let constrains = [
            subview.leftAnchor.constraint(equalTo: leftAnchor, constant: padding.left),
            subview.rightAnchor.constraint(equalTo: rightAnchor, constant: -padding.right),
            subview.topAnchor.constraint(equalTo: topAnchor, constant: padding.top),
            subview.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -padding.bottom)
        ]
        NSLayoutConstraint.activate(constrains)

        return constrains
    }

    @discardableResult
    func fitToSafeArea(subview: UIView) -> [NSLayoutConstraint] {
        if !subviews.contains(subview) {
            addSubview(subview)
        }

        subview.translatesAutoresizingMaskIntoConstraints = false

        let constrains = [
            subview.leftAnchor.constraint(equalTo: safeAreaLayoutGuide.leftAnchor),
            subview.rightAnchor.constraint(equalTo: safeAreaLayoutGuide.rightAnchor),
            subview.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            subview.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor)
        ]
        NSLayoutConstraint.activate(constrains)

        return constrains
    }
}
