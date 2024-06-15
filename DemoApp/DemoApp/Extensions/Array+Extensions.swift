//
//  Array+Extensions.swift
//  DemoApp
//
//  Created by Ali Mert Özhayta on 15.06.2024.
//

import Foundation

extension Array {
    public subscript(safeIndex index: Int) -> Element? {
        guard index >= 0, index < endIndex else {
            return nil
        }

        return self[index]
    }
}
