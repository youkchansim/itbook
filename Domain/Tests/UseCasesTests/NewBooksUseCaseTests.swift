//
//  NewBooksUseCaseTests.swift
//  
//
//  Created by 육찬심 on 2021/12/26.
//

import XCTest
import Entities
import Repositories
import UseCases

class NewBooksUseCaseTests: XCTestCase {
    
    class NewBooksRepositoryMock: NewBooksRepository {
        
        enum RepositoryError: Error {
            
            case failedFetch
        }
        
        var fetchCallCount = 0
        var isSuccessed: Bool
        
        init(
            isSuccessed: Bool
        ) {
            self.isSuccessed = isSuccessed
        }
        
        func fetch() async -> Result<[Book], Error> {
            fetchCallCount += 1
            
            if isSuccessed {
                return .success([
                    Book(title: "test1", subtitle: "", price: "", image: "", url: "", isbn13: ""),
                    Book(title: "test2", subtitle: "", price: "", image: "", url: "", isbn13: ""),
                    Book(title: "test3", subtitle: "", price: "", image: "", url: "", isbn13: ""),
                ])
            } else {
                return .failure(RepositoryError.failedFetch)
            }
        }
    }
    
    func test_newBooksUseCase_whenExecute_thenCallCountIsOne() {
        // given
        let mock = NewBooksRepositoryMock(isSuccessed: true)
        let sut = NewBooksUseCaseImp(repository: mock)
        
        // when
        asyncTest {
            _ = await sut.execute()
        }
        
        // then
        XCTAssertTrue(mock.fetchCallCount == 1, "execute function was called zero or more than 2 - count: \(mock.fetchCallCount)")
    }
    
    func test_newBooksUseCase_whenSuccessfullyFetch_thenResultIsNotEmpty() {
        // given
        let mock = NewBooksRepositoryMock(isSuccessed: true)
        let sut = NewBooksUseCaseImp(repository: mock)
        var result: Result<[Book], Error>?
        
        // when
        asyncTest {
            result = await sut.execute()
        }
        
        // then
        switch result {
        case .success(let books):
            XCTAssertTrue(!books.isEmpty, "execute failed")
        case .failure(let error):
            XCTFail(error.localizedDescription)
        case .none:
            XCTFail("Result is nil")
        }
    }
    
    func test_newBooksUseCase_whenFailedFetch_thenResultIsEmpty() {
        // given
        let mock = NewBooksRepositoryMock(isSuccessed: false)
        let sut = NewBooksUseCaseImp(repository: mock)
        var result: Result<[Book], Error>?
        
        // when
        asyncTest {
            result = await sut.execute()
        }
        
        // then
        switch result {
        case .success(_):
            XCTFail("Execute is Successed")
        case .failure(let error):
            XCTAssertTrue(error is NewBooksRepositoryMock.RepositoryError)
        case .none:
            XCTFail("Result is nil")
        }
    }
}
