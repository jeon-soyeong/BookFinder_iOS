//
//  BookListViewModel.swift
//  BookFinder
//
//  Created by 전소영 on 2022/08/16.
//

import Foundation

import RxSwift
import RxRelay

final class BookListViewModel: ViewModelType {
    private let disposeBag = DisposeBag()
    private let apiService = APIService()
    private(set) var currentPage = 1
    private(set) var startIndex = 0
    private(set) var perPage = 20
    private(set) var currentItemCount = 0
    private(set) var isRequestCompleted = false
    private(set) var bookItems: [BookItem] = []
    var totalItemsCount = 0

    struct Action {
        let didSearch = PublishSubject<String>()
    }

    struct State {
        let searchResult = PublishSubject<Result<Void, Error>>()
        let isRequesting = BehaviorRelay<Bool>(value: false)
    }

    var action = Action()
    var state = State()

    init() {
        self.configure()
    }

    func initialize() {
        bookItems = []
        currentPage = 1
        isRequestCompleted = false
        currentItemCount = 0
        totalItemsCount = 0
    }

    private func configure() {
        action.didSearch
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                let isRequesting = self.state.isRequesting.value
                if self.isRequestCompleted == false, isRequesting == false {
                    self.requestBookListData(query: $0)
                }
            })
            .disposed(by: disposeBag)
    }

    private func requestBookListData(query: String) {
        self.state.isRequesting.accept(true)
        startIndex = (currentPage - 1) * perPage
        
        guard let request = URLRequest(type: BookFinderAPI.getBookItem(q: query, startIndex: startIndex, maxResults: perPage)) else {
            return
        }
        apiService.request(with: request)
            .subscribe(onSuccess: { [weak self] (bookList: BookList) in
                if self?.totalItemsCount == 0 {
                    self?.totalItemsCount = bookList.totalItems
                }
                self?.process(bookItems: bookList.items)
                self?.state.isRequesting.accept(false)
            }, onFailure: {
                self.state.searchResult.onNext(.failure($0))
            })
            .disposed(by: disposeBag)
    }

    func process(bookItems: [BookItem]?) {
        currentItemCount += perPage
        isRequestCompleted = totalItemsCount <= currentItemCount
        currentPage += 1
        if let bookItems = bookItems {
            for bookItem in bookItems {
                self.bookItems.append(bookItem)
            }
        }
        state.searchResult.onNext(.success(()))
    }
}
