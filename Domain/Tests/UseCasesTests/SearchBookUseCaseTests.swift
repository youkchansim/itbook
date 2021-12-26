//
//  SearchBookUseCaseTests.swift
//  
//
//  Created by 육찬심 on 2021/12/26.
//

import XCTest
import Entities
import Repositories
import UseCases

class SearchBookUseCaseTests: XCTestCase {
    
    class SearchBooksRepositoryMock: SearchBooksRepository {
        
        enum RepositoryError: Error {
            
            case failedFetch
        }
        
        var fetchCallCount = 0
        private let isSuccessed: Bool
        
        private let books = [
            Book(title: "test1", subtitle: "", price: "", image: "", url: "", isbn13: ""),
            Book(title: "test2", subtitle: "", price: "", image: "", url: "", isbn13: ""),
            Book(title: "test3", subtitle: "", price: "", image: "", url: "", isbn13: ""),
            Book(title: "test4", subtitle: "", price: "", image: "", url: "", isbn13: "", authors: "author1"),
            Book(title: "test5", subtitle: "", price: "", image: "", url: "", isbn13: "", authors: "author2"),
            Book(title: "test6", subtitle: "", price: "", image: "", url: "", isbn13: "", authors: "author3"),
            Book(title: "test7", subtitle: "", price: "", image: "", url: "", isbn13: ""),
            Book(title: "test8", subtitle: "", price: "", image: "", url: "", isbn13: ""),
            Book(title: "test9", subtitle: "", price: "", image: "", url: "", isbn13: ""),
        ]
        
        init(
            isSuccessed: Bool
        ) {
            self.isSuccessed = isSuccessed
        }
        
        func fetch(query: String, page: Int) async -> Result<BookPage, Error> {
            fetchCallCount += 1
            
            if isSuccessed {
                let filteredBooks = books.filter {
                    $0.title.contains(query) ||
                    $0.authors.contains(query) ||
                    $0.isbn13.contains(query)
                }
                
                let result = BookPage(total: "9", page: "1", books: filteredBooks)
                return .success(result)
            } else {
                return .failure(RepositoryError.failedFetch)
            }
        }
    }
    
    func test_searchBooksUseCase_whenExecute_thenCallCountIsOne() {
        // given
        let mock = SearchBooksRepositoryMock(isSuccessed: true)
        let sut = SearchBooksUseCaseImp(repository: mock)
        
        // when
        asyncTest {
            _ = await sut.execute(query: "", page: 1)
        }
        
        // then
        XCTAssertTrue(mock.fetchCallCount == 1, "'execute' was called zero or more than 2 - count: \(mock.fetchCallCount)")
    }
    
    func test_searchBooksUseCase_whenSuccessfullyFetch_thenResultIsNotEmpty() {
        // given
        let mock = SearchBooksRepositoryMock(isSuccessed: true)
        let sut = SearchBooksUseCaseImp(repository: mock)
        var result: Result<BookPage, Error>?
        let query = "test1"
        
        // when
        asyncTest {
            result = await sut.execute(query: query, page: 1)
        }
        
        // then
        switch result {
        case .success(let bookPage):
            let books = bookPage.books
            XCTAssertTrue(books.contains(where: { $0.title.contains(query) || $0.authors.contains(query) || $0.isbn13.contains(query) }), "execute failed")
        case .failure(let error):
            XCTFail(error.localizedDescription)
        case .none:
            XCTFail("Result is nil")
        }
    }
    
    func test_searchBooksUseCase_whenFailedFetch_thenResultIsEmpty() {
        // given
        let mock = SearchBooksRepositoryMock(isSuccessed: false)
        let sut = SearchBooksUseCaseImp(repository: mock)
        var result: Result<BookPage, Error>?
        let query = "test1"
        
        // when
        asyncTest {
            result = await sut.execute(query: query, page: 1)
        }
        
        // then
        switch result {
        case .success(_):
            XCTFail("Execute is Successed")
        case .failure(let error):
            XCTAssertTrue(error is SearchBooksRepositoryMock.RepositoryError)
        case .none:
            XCTFail("Result is nil")
        }
    }
}
