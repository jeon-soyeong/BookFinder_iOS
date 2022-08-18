//
//  ImageCacheManager.swift
//  BookFinder
//
//  Created by 전소영 on 2022/08/17.
//

import Foundation

import RxSwift
import UIKit

class ImageCacheManager: NSObject {
    private let disposeBag = DisposeBag()
    
    static let shared = ImageCacheManager()
    private let cache = NSCache<NSString, CachedImage>()
    let maximumMemoryBytes = Int(ProcessInfo.processInfo.physicalMemory) / 4
    
    override init() {
        super.init()
        setupNotification()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: .memoryWarning, object: nil)
    }
    
    func configureCacheMemory() {
        cache.totalCostLimit = maximumMemoryBytes
    }
    
    func read(with key: String) -> CachedImage? {
        let key = NSString(string: key)
        return self.cache.object(forKey: key)
    }
    
    func save(data: CachedImage, with key: String) {
        let key = NSString(string: key)
        self.cache.setObject(data, forKey: key, cost: data.imageData.count)
    }
    
    private func setupNotification() {
        NotificationCenter.default.rx.notification(.memoryWarning)
            .subscribe(onNext: { _ in
                ImageCacheManager.shared.cache.removeAllObjects()
            }).disposed(by: disposeBag)
    }
}
