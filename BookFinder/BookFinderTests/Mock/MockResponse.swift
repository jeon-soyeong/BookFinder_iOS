//
//  MockResponse.swift
//  BookFinderTests
//
//  Created by 전소영 on 2022/08/18.
//

import Foundation

class MockResponse {
    var url: String
    var responseData: Data?
    var error: Error?
    var statusCode: Int

    init(url: String,
         responseData: Data? = nil,
         error: Error? = nil,
         statusCode: Int = 200) {
        self.url = url
        self.responseData = responseData
        self.error = error
        self.statusCode = statusCode
    }
}
