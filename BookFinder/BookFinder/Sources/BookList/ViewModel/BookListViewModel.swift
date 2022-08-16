//
//  BookListViewModel.swift
//  BookFinder
//
//  Created by 전소영 on 2022/08/16.
//

import Foundation

import RxSwift
import RxRelay

class BookListViewModel: ViewModelType {
    var disposeBag = DisposeBag()
    let apiService = APIService()
    
    private(set) var isRequestCompleted = false
    private(set) var isRequesting = false
    
    struct Action {
        let didSearch = PublishSubject<String>()
    }
    
    struct State {
        let bookListData = PublishSubject<BookList>()
//        let bookListData = BehaviorRelay<BookList>(value: nil)
    }
    
    var action = Action()
    var state = State()
    
    init() {
        self.configure()
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
        
        if let request = URLRequest(type: BookFinderAPI.getBookItem(q: query, startIndex: 1)) {
            apiService.request(with: request)
                .subscribe(onSuccess: { [weak self] (bookList: BookList) in
                    print("bookList: \(bookList)")
                    self?.state.bookListData.onNext(bookList)
                    self?.isRequesting = false
                }, onFailure: {
                    print($0)
                })
                .disposed(by: disposeBag)
        }
        
        
        
        
//        APIService.shared.request(GitHubAPI.getUserStarRepositoryData(page: currentPage, perPage: perPage))
//            .subscribe(onSuccess: { [weak self] (userRepositories: [UserRepository]) in
//                self?.process(userRepositories: userRepositories)
//                self?.isRequesting = false
//            }, onFailure: {
//                print($0)
//            })
//            .disposed(by: disposeBag)
    }
    
//    func process(userRepositories: [UserRepository]) {
//        if currentPage != 1 {
//            isRequestCompleted = userRepositories.isEmpty
//        }
//        currentPage += 1
//        for item in userRepositories {
//            section.append(item)
//        }
//        if isRequestCompleted == false {
//            state.userStarRepositoryData.accept([UserRepositorySection(model: Void(), items: section)])
//        }
//    }
}
