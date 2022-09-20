//
//  MockURLSessionDataTask.swift
//  BookFinderTests
//
//  Created by 전소영 on 2022/08/18.
//

import Foundation
import BookFinder

final class MockURLSessionDataTask {
    var completionHandler: ((Data?, URLResponse?, Error?) -> Void)?
    var mockResponse: MockResponse?
    
    init(completionHandler: ((Data?, URLResponse?, Error?) -> Void)?, mockResponse: MockResponse?) {
        self.completionHandler = completionHandler
        self.mockResponse = mockResponse
    }
}

extension MockURLSessionDataTask: URLSessionDataTaskProtocol {
    func resume() {
        let response: HTTPURLResponse?
        
        if let url = mockResponse?.url,
           let requestURL = URL(string: url) {
            response = HTTPURLResponse(url: requestURL, statusCode: mockResponse?.statusCode ?? 200, httpVersion: nil, headerFields: nil)
            completionHandler?(mockResponse?.responseData, response, mockResponse?.error)
        }
    }

    func cancel() {
        completionHandler?(nil, nil, NSError(domain: "", code: NSURLErrorCancelled, userInfo: nil))
    }
}
