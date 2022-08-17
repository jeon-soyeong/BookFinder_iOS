//
//  LoadingActivityIndicatorManager.swift
//  BookFinder
//
//  Created by 전소영 on 2022/08/17.
//

import Foundation
import UIKit

class LoadingActivityIndicatorManager {
    static func showLoadingActivityIndicator() {
        DispatchQueue.main.async {
            guard let window = UIApplication.shared.windows.last else { return }
            let loadingIndicatorView: UIActivityIndicatorView
            if let existedView = window.subviews.first(where: { $0 is UIActivityIndicatorView } ) as? UIActivityIndicatorView {
                loadingIndicatorView = existedView
            } else {
                loadingIndicatorView = UIActivityIndicatorView(style: .large)
                loadingIndicatorView.frame = window.frame
                loadingIndicatorView.color = .gray
                window.addSubview(loadingIndicatorView)
            }
            loadingIndicatorView.startAnimating()
        }
    }

    static func hideLoadingActivityIndicator() {
        DispatchQueue.main.async {
            guard let window = UIApplication.shared.windows.last else { return }
            window.subviews.filter({ $0 is UIActivityIndicatorView }).forEach { $0.removeFromSuperview() }
        }
    }
}
