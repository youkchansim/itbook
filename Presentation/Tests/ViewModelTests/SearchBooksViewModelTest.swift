//
//  SearchBooksViewModelTest.swift
//  
//
//  Created by 육찬심 on 2021/12/27.
//

import Views
import XCTest
import Entities
import UseCases
import Extension

class SearchBooksViewModelTest: XCTestCase {
    
    class SearchBooksUseCaseMock: SearchBooksUseCase {
        
        var callCount = 0
        
        func execute(query: String, page: Int) async -> Result<BookPage, Error> {
            callCount += 1
            return .success(BookPage(total: "", page: "", books: []))
        }
    }
    
    func test_newBooksViewModel_whenLoad_thenLoadFunctionCallCountIsOne() {
        let mock = SearchBooksUseCaseMock()
        let sut: SearchBooksResultViewModelType = SearchBooksResultViewModel(searchBooksUseCase: mock)
        
        // when
        asyncTest {
            _ = sut.action.search(query: "")
        }
        
        // then
        XCTAssertTrue(mock.callCount == 1, "'execute' was called zero or more than 2 - count: \(mock.callCount)")
    }
}
