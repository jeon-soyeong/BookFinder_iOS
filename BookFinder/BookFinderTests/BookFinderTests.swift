//
//  BookFinderTests.swift
//  BookFinderTests
//
//  Created by 전소영 on 2022/08/16.
//

import XCTest
@testable import BookFinder

import RxSwift

class BookFinderTests: XCTestCase {
    let disposeBag = DisposeBag()
    let bookListViewModel = BookListViewModel()
    var responseData: Data?
    let imageCacheManager = ImageCacheManager.shared

    override func setUpWithError() throws {
        guard let path = Bundle(for: type(of: self)).path(forResource: "BookSearchResult", ofType: "json"),
              let jsonString = try? String(contentsOfFile: path) else {
            return
        }
        responseData = jsonString.data(using: .utf8)
    }
    
    func test_givenMockURLSession_whenRequestGetBookItem_ThenSuccess() throws {
        let mockURLSession = MockURLSession(mockResponse: MockResponse(url: "https://www.googleapis.com/books/v1/volumes", responseData: responseData, error: nil, statusCode: 200))
        let apiService = APIService(session: mockURLSession)

        guard let request = URLRequest(type: BookFinderAPI.getBookItem(q: "성장", startIndex: 0, maxResults: 20)) else {
            XCTFail()
            return
        }
        apiService.request(with: request)
            .subscribe(onSuccess: { (bookList: BookList) in
                XCTAssertNotNil(bookList)
                XCTAssertEqual(bookList.items?.first?.volumeInfo.title, "일하면서 성장하고 있습니다")
                XCTAssertEqual(bookList.items?.first?.volumeInfo.authors?.first, "박소연")
                XCTAssertNotEqual(bookList.items?.first?.volumeInfo.authors?.first, "박연")
            })
            .disposed(by: disposeBag)
    }

    func test_givenAPIService_whenRequestGetBookItem_ThenSuccess() throws {
        let expectation = XCTestExpectation(description: "GetBookItem API Test")

        let apiService = APIService()
        guard let request = URLRequest(type: BookFinderAPI.getBookItem(q: "온도", startIndex: 0, maxResults: 20)) else {
            XCTFail()
            return
        }
        apiService.request(with: request)
            .subscribe(onSuccess: { (bookList: BookList) in
                XCTAssertNotNil(bookList)
                XCTAssertEqual(bookList.items?.first?.volumeInfo.title, "언어의 온도(170만부 기념 에디션)")
                XCTAssertEqual(bookList.items?.first?.volumeInfo.authors?.first, "이기주")
                XCTAssertNotEqual(bookList.items?.first?.volumeInfo.authors?.first, "고경표표")
                
                expectation.fulfill()
            })
            .disposed(by: disposeBag)
        wait(for: [expectation], timeout: 10.0)
    }

    func test_givenBookListViewModel_WhenPagingProcess_ThenSuccess() throws {
        guard let responseData = responseData else { return }
        let bookList = try JSONDecoder().decode(BookList.self, from: responseData)

        bookListViewModel.totalItemsCount = 40

        bookListViewModel.process(bookItems: bookList.items)
        XCTAssertTrue(bookListViewModel.currentPage == 2)
        XCTAssertTrue(bookListViewModel.currentItemCount == 20)
        XCTAssertFalse(bookListViewModel.isRequestCompleted == true)

        bookListViewModel.process(bookItems: bookList.items)
        XCTAssertTrue(bookListViewModel.currentPage == 3)
        XCTAssertTrue(bookListViewModel.currentItemCount == 40)
        XCTAssertTrue(bookListViewModel.isRequestCompleted == true)
    }
    
    func test_givenImageCacheManager_WhenSaveAndReadCachedImage_ThenSuccess() throws {
        let testString = "abcdefg"
        guard let testData = """
        \(testString)
        """.data(using: .utf8) else {
            XCTFail()
            return
        }
        let data = CachedImage(imageData: testData)
        imageCacheManager.save(data: data, with: "imageDataKey")

        guard let result = imageCacheManager.read(with: "imageDataKey") else {
            XCTFail()
            return
        }
        XCTAssert(result.imageData.count == 7)

        let resultString = String(data: result.imageData, encoding: .utf8)
        XCTAssert(resultString == testString)
    }
}
