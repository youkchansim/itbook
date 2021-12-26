//
//  DetailBookUseCaseTests.swift
//  
//
//  Created by 육찬심 on 2021/12/26.
//

import XCTest
import Repositories
import UseCases
import Entities

class DetailBookUseCaseTests: XCTestCase {
    
    class DetailBookRepositoryMock: DetailBookRepository {
        
        var fetchCallCount = 0
        
        func fetch(book: Book) async -> Result<Book, Error> {
            fetchCallCount += 1
            return .success(Book(title: "",
                                 subtitle: "",
                                 price: "",
                                 image: "",
                                 url: "",
                                 isbn13: ""))
        }
    }
    
    func test_detailBookUseCase_whenExecute_thenCallCountIsOne() {
        // given
        let mock = DetailBookRepositoryMock()
        let book = Book(title: "",
                        subtitle: "",
                        price: "",
                        image: "",
                        url: "",
                        isbn13: "")
        let sut = DetailBookUseCaseImp(repository: mock)
        
        // when
        asyncTest {
            _ = await sut.execute(book: book)
        }
        
        // then
        XCTAssertTrue(mock.fetchCallCount == 1, "'execute' was called zero or more than 2 - count: \(mock.fetchCallCount)")
    }
}
