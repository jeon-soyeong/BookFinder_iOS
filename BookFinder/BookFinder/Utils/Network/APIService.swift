//
//  APIService.swift
//  BookFinder
//
//  Created by 전소영 on 2022/08/16.
//

import Foundation

import RxSwift

final class APIService {
    private var session: URLSessionProtocol
    
    init(session: URLSessionProtocol = URLSession.shared) {
        self.session = session
    }
    
    func request<T: Codable>(with url: URLRequest) async throws -> T {
        let (data, response) = try await self.session.getData(for: url)
        
        guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode == 200 else {
            throw APIError.failedData
        }

        guard let parsedResponse = try? JSONDecoder().decode(T.self, from: data) else {
            throw APIError.failedDecode
        }
        
        return parsedResponse
    }
}
