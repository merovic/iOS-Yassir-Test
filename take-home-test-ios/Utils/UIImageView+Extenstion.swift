//
//  UIImageView+Extenstion.swift
//  take-home-test-ios
//
//  Created by Amir Morsy on 05/01/2025.
//

import UIKit

class ImageCache {
    static let shared = NSCache<NSString, UIImage>()
}

extension UIImageView {
    func loadImage(from urlString: String, placeholder: UIImage? = nil) {
        self.image = placeholder
        
        if let cachedImage = ImageCache.shared.object(forKey: urlString as NSString) {
            self.image = cachedImage
            return
        }
        
        guard let url = URL(string: urlString) else { return }
        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            if let data = data, let downloadedImage = UIImage(data: data), error == nil {
                ImageCache.shared.setObject(downloadedImage, forKey: urlString as NSString)
                DispatchQueue.main.async {
                    self?.image = downloadedImage
                }
            }
        }.resume()
    }
}
