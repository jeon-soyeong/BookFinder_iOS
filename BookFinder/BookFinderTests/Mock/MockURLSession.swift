//
//  MockURLSession.swift
//  BookFinderTests
//
//  Created by 전소영 on 2022/08/18.
//

import Foundation
import BookFinder

final class MockURLSession {
    var mockResponse: MockResponse?
    
    init(mockResponse: MockResponse) {
        self.mockResponse = mockResponse
    }
}

extension MockURLSession: URLSessionProtocol {
    func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTaskProtocol {
        let mockURLSessionDataTask = MockURLSessionDataTask(completionHandler: completionHandler, mockResponse: mockResponse)
        return mockURLSessionDataTask
    }
}
