//
//  URLSession+Extension.swift
//  BookFinder
//
//  Created by 전소영 on 2022/09/07.
//

import Foundation

extension URLSession: URLSessionProtocol {
    public func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTaskProtocol {
        dataTask(with: request, completionHandler: completionHandler) as URLSessionDataTask
    }
    
    public func getData(for request: URLRequest) async throws -> (Data, URLResponse) {
        try await data(for: request)
    }
}
