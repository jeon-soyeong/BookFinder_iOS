//
//  URLSessionProtocol.swift
//  BookFinder
//
//  Created by 전소영 on 2022/09/07.
//

import Foundation

public protocol URLSessionProtocol {
    func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTaskProtocol
}
