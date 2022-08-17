//
//  ImageCacheManager.swift
//  BookFinder
//
//  Created by 전소영 on 2022/08/17.
//

import Foundation

import RxSwift
import UIKit

final class CacheableImage {
    let imageData: Data
    init(imageData: Data) {
        self.imageData = imageData
    }
}

class ImageCacheManager: NSObject {
    static let shared = ImageCacheManager()
    private var cache = NSCache<NSString, CacheableImage>()
    let maximumMemoryBytes = 30 * 1024 * 1024
   
    override init() {
        super.init()
    }
    
    func configureCacheMemory() {
        cache.totalCostLimit = maximumMemoryBytes
    }
    
    func save(data: CacheableImage, with key: String) {
        let key = NSString(string: key)
        self.cache.setObject(data, forKey: key, cost: data.imageData.count)
    }
    
    func read(with key: String) -> CacheableImage? {
        let key = NSString(string: key)
        return self.cache.object(forKey: key)
    }

    func requestImage(_ url: URL) -> Single<UIImage> {
        return Single<UIImage>.create { single in
            let task = URLSession.shared.dataTask(with: url) { [weak self] (data, response, error) in
                guard let data = data else {
                    return
                }
                if let image = UIImage(data: data) {
                    single(.success(image))
                    self?.save(data: CacheableImage(imageData: data), with: url.path)
                }
            }
            task.resume()
            return Disposables.create {
                task.cancel()
            }
        }
    }
}
