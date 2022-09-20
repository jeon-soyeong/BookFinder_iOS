//
//  BookDetailViewModel.swift
//  BookFinder
//
//  Created by 전소영 on 2022/09/20.
//

import Foundation

class BookDetailViewModel {
    private(set) var bookItem: BookItem
    
    init(bookItem: BookItem) {
        self.bookItem = bookItem
    }
}
