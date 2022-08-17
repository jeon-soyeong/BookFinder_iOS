//
//  BookListViewModel.swift
//  BookFinder
//
//  Created by 전소영 on 2022/08/16.
//

import Foundation

import RxSwift

class BookListViewModel: ViewModelType {
    var disposeBag = DisposeBag()
    private let apiService = APIService()
    private(set) var currentPage = 1
    private(set) var startIndex = 0
    private(set) var perPage = 20
    private(set) var currentItemCount = 0
    private(set) var isRequestCompleted = false
    private(set) var isRequesting = false
    private(set) var totalItemsCount = 0

    struct Action {
        let didSearch = PublishSubject<String>()
    }

    struct State {
        let bookListData = PublishSubject<Result<BookList, Error>>()
    }

    var action = Action()
    var state = State()

    init() {
        self.configure()
    }

    func initialize() {
        currentPage = 1
        isRequestCompleted = false
        currentItemCount = 0
        totalItemsCount = 0
    }

    private func configure() {
        action.didSearch
            .subscribe(onNext: { [weak self]  in
                self?.requestBookListData(query: $0)
            })
            .disposed(by: disposeBag)
    }

    private func requestBookListData(query: String) {
        self.isRequesting = true
        startIndex = (currentPage - 1) * perPage
        if let request = URLRequest(type: BookFinderAPI.getBookItem(q: query, startIndex: startIndex, maxResults: perPage)) {
            apiService.request(with: request)
                .subscribe(onSuccess: { [weak self] (bookList: BookList) in
                    print("bookList: \(bookList)")
                    if self?.totalItemsCount == 0 {
                        self?.totalItemsCount = bookList.totalItems
                    }
                    self?.process(bookList: bookList)
                    self?.isRequesting = false
                }, onFailure: {
                    self.state.bookListData.onNext(.failure($0))
                })
                .disposed(by: disposeBag)
        }
    }

    func process(bookList: BookList) {
        currentItemCount += perPage
        isRequestCompleted = totalItemsCount <= currentItemCount
        print("isRequestCompleted: \(isRequestCompleted)")
        currentPage += 1
        state.bookListData.onNext(.success(bookList))
    }
}
