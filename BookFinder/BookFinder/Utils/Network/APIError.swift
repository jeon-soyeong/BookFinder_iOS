//
//  APIError.swift
//  BookFinder
//
//  Created by 전소영 on 2022/08/17.
//

import Foundation

enum APIError: Error {
    case failedData
    case failedDecode
    
    public var description: String {
        switch self {
        case .failedData:
            return "데이터 처리 실패입니다."
        case .failedDecode:
            return "디코딩에 실패했습니다."
        }
    }
}
