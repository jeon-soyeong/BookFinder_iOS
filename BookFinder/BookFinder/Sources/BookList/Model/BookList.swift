//
//  BookList.swift
//  BookFinder
//
//  Created by 전소영 on 2022/08/16.
//

import Foundation

// MARK: - BookList
struct BookList: Codable {
    let totalItems: Int
    let items: [BookItem]?
}

// MARK: - Item
struct BookItem: Codable {
    let id: String
    let volumeInfo: VolumeInfo
    let etag: String
}

// MARK: - VolumeInfo
struct VolumeInfo: Codable {
    let title: String
    let subtitle: String?
    let authors: [String]?
    let publishedDate: String?
    let imageLinks: ImageLinks?
    let infoLink: String
    let description: String?
}

// MARK: - ImageLinks
struct ImageLinks: Codable {
    let thumbnail: String
}
