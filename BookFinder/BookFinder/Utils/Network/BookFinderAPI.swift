//
//  BookFinderAPI.swift
//  BookFinder
//
//  Created by 전소영 on 2022/08/16.
//

import Foundation

enum BookFinderAPI: EndPointType {
    case getBookItem(q: String, startIndex: Int, maxResults: Int)
    
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
        case .getBookItem(let q, let startIndex, let maxResults):
            return [URLQueryItem(name: "q", value: "\(q)"),
                    URLQueryItem(name: "startIndex", value: "\(startIndex)"),
                    URLQueryItem(name: "maxResults", value: "\(maxResults)"),
                    URLQueryItem(name: "key", value: APIConstants.apiKey)]
        }
    }
}
