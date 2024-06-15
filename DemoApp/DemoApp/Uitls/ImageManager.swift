//
//  ImageManager.swift
//  DemoApp
//
//  Created by Ali Mert Özhayta on 15.06.2024.
//

import UIKit

final class ImageManager {

    static let shared = ImageManager()

    private let cache = NSCache<NSString, UIImage>()

    func fetchImage(from url: String) async -> UIImage? {
        if let cachedImage = cache.object(forKey: url as NSString) as UIImage? {
            return cachedImage
        }

        guard let imageUrl = URL(string: url) else {
            return nil
        }

        let urlRequest = URLRequest(url: imageUrl)

        guard let (imageData, _) = try? await URLSession.shared.data(for: urlRequest),
              let image = UIImage(data: imageData) else {
            return nil
        }

        cache.setObject(image, forKey: url as NSString)
        return image
    }
}
