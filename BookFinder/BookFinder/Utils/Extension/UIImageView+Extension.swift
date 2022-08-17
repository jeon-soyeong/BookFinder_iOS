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

        if let imageUrl = URL(string: url) {
            guard let cachedData = imageCacheManager.read(with: url) else {
                imageCacheManager.requestImage(imageUrl)
                    .observe(on: MainScheduler.instance)
                    .subscribe(onSuccess: { [weak self] image in
                        self?.image = image
                    }, onFailure: { error in
                        print(error)
                    })
                    .disposed(by: disposeBag)
                return
            }

            self.image = UIImage(data: cachedData.imageData)
        }
    }
}
