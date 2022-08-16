//
//  APIConstants.swift
//  BookFinder
//
//  Created by 전소영 on 2022/08/16.
//

import Foundation

struct APIConstants {
    static let baseURL = "https://www.googleapis.com"
    
    static var apiKey: String {
        guard let filePath = Bundle.main.path(forResource: "Key", ofType: "plist") else {
            return ""
        }
        let plist = NSDictionary(contentsOfFile: filePath)
        guard let value = plist?.object(forKey: "apiKey") as? String else {
            return ""
        }
        return value
    }
}
