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
                if let error = error {
                    single(.failure(error))
                    return
                }
                guard let data = data,
                      let parsedResponse = try? JSONDecoder().decode(T.self, from: data) else {
                          return
                      }
                let object = try? JSONSerialization.jsonObject(with: data)
                let data2 = try? JSONSerialization.data(withJSONObject: object, options: .prettyPrinted)
                print("resp: \(NSString.init(data: data2!, encoding: String.Encoding.utf8.rawValue))")
//                print("parsedResponse: \(parsedResponse)")
                single(.success(parsedResponse))
            }
            task?.resume()
            return Disposables.create {
                task?.cancel()
            }
        }
    }
}
