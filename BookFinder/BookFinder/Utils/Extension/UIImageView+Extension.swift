//
//  UIImageView+Extension.swift
//  BookFinder
//
//  Created by 전소영 on 2022/08/17.
//

import Foundation
import UIKit

import RxSwift

extension UIImageView {
    func setImage(with url: String) -> URLSessionDataTask? {
        let imageCacheManager = ImageCacheManager.shared
        var dataTask: URLSessionDataTask?
        
        guard let cachedData = imageCacheManager.read(with: url) else {
            self.image = UIImage()
            if let imageUrl = URL(string: url) {
                dataTask = URLSession.shared.dataTask(with: imageUrl) { [weak self] (data, response, error) in
                    guard let data = data else {
                        return
                    }
                    if let downloadedImage = UIImage(data: data) {
                        imageCacheManager.save(data: CachedImage(imageData: data), with: url)
                        DispatchQueue.main.async {
                            self?.image = downloadedImage
                        }
                    }
                }
                dataTask?.resume()
            }
            return dataTask
        }
        self.image = UIImage(data: cachedData.imageData)
        return dataTask
    }
}
