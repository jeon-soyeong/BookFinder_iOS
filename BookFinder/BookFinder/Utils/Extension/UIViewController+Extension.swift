//
//  UIViewController+Extension.swift
//  BookFinder
//
//  Created by 전소영 on 2022/08/17.
//

import Foundation
import UIKit

extension UIViewController {
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "확인", style: .default)
        alert.addAction(okAction)
        present(alert, animated: true)
    }
    
    func setNavigationBarTransparency() {
        let navigationBar = self.navigationController?.navigationBar
        navigationBar?.backgroundColor = UIColor.clear
            
        navigationBar?.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationBar?.shadowImage = UIImage()
    }
}
