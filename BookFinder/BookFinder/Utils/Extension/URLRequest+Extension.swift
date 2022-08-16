//
//  URLRequest+Extension.swift
//  BookFinder
//
//  Created by 전소영 on 2022/08/16.
//

import Foundation

extension URLRequest {
    init?(type: EndPointType) {
        var components = URLComponents(string: type.baseURL)
        components?.path = type.path
        components?.queryItems = type.query

        guard let url = components?.url else {
            return nil
        }

        self.init(url: url)
    }
}
