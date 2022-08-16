//
//  EndPointType.swift
//  BookFinder
//
//  Created by 전소영 on 2022/08/16.
//

import Foundation

protocol EndPointType {
    var baseURL: String { get }
    var path: String { get }
    var query: [URLQueryItem]? { get }
}
