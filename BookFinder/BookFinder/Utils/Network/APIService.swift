//
//  APIService.swift
//  BookFinder
//
//  Created by 전소영 on 2022/08/16.
//

import Foundation

import RxSwift

class APIService {
    var session = URLSession.shared
    
    func request<T: Codable>(with url: URLRequest) -> Single<T> {
        return Single<T>.create { [weak self] single in
            let task = self?.session.dataTask(with: url) { (data, response, error) in
                guard let data = data else {
                    single(.failure(APIError.failedData))
                    return
                }
                guard let parsedResponse = try? JSONDecoder().decode(T.self, from: data) else {
                    single(.failure(APIError.failedDecode))
                    return
                }
                single(.success(parsedResponse))
            }
            task?.resume()
            return Disposables.create {
                task?.cancel()
            }
        }
    }
}
