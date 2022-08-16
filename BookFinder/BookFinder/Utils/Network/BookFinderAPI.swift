//
//  BookFinderAPI.swift
//  BookFinder
//
//  Created by 전소영 on 2022/08/16.
//

import Foundation

enum BookFinderAPI: EndPointType {
    case getBookItem(q: String, startIndex: Int)
    
    var baseURL: String {
        return APIConstants.baseURL
    }

    var path: String {
        switch self {
        case .getBookItem:
            return "/books/v1/volumes"
        }
    }

    var query: [URLQueryItem]? {
        switch self {
        case .getBookItem(let q, let startIndex):
            return [URLQueryItem(name: "q", value: "\(q)"),
//                    URLQueryItem(name: "startIndex", value: "\(startIndex)"),
                    URLQueryItem(name: "key", value: APIConstants.apiKey)]
        }
    }
}
