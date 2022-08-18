//
//  MockURLSession.swift
//  BookFinderTests
//
//  Created by 전소영 on 2022/08/18.
//

import Foundation

class MockURLSession: URLSession {
    var mockResponse: MockResponse?
    var responseData: Data?
    var error: Error?
    var statusCode: Int = 200

    override func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        let mock = MockURLSessionDataTask()
        mock.mockResponse = mockResponse

        mock.completionHandler = completionHandler
        return mock
    }

    override func dataTask(with request: URLRequest) -> URLSessionDataTask {
        let mock = MockURLSessionDataTask()
        mock.mockResponse = mockResponse
        
        mock.completionHandler = nil
        return mock
    }
}
