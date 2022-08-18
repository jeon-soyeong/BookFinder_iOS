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
    func setImage(with url: String, disposeBag: DisposeBag) {
        let imageCacheManager = ImageCacheManager.shared
        
        guard let cachedData = imageCacheManager.read(with: url) else {
            if let imageUrl = URL(string: url) {
                let task = URLSession.shared.dataTask(with: imageUrl) { [weak self] (data, response, error) in
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
                task.resume()
            }
            return
        }
        self.image = UIImage(data: cachedData.imageData)
    }
}
