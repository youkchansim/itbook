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
import TestExtension

class SearchBooksViewModelTest: XCTestCase {
    
    class SearchBooksUseCaseMock: SearchBooksUseCase {
        
        var callCount = 0
        
        func execute(query: String, page: Int) async -> Result<BookPage, Error> {
            callCount += 1
            return .success(BookPage(total: "", page: "", books: []))
        }
    }
    
    class FlowMock: SearchBooksResultFlowDelegate {
        
        var callCount = 0
        
        func showDetail(book: Book) {
            callCount += 1
        }
    }
    
    func test_newBooksViewModel_whenLoad_thenLoadFunctionCallCountIsOne() {
        let mock = SearchBooksUseCaseMock()
        let flowMock = FlowMock()
        let sut: SearchBooksResultViewModelType = SearchBooksResultViewModel(searchBooksUseCase: mock, flowDelegate: flowMock)
        
        // when
        asyncTest {
            _ = sut.action.search(query: "")
        }
        
        // then
        XCTAssertTrue(mock.callCount == 1, "Called zero or more than 2 - count: \(mock.callCount)")
    }
    
    func test_newBooksViewModel_whenSelect_thenShowDetailFunctionCallCountIsOne() {
        let mock = SearchBooksUseCaseMock()
        let flowMock = FlowMock()
        let sut: SearchBooksResultViewModelType = SearchBooksResultViewModel(searchBooksUseCase: mock, flowDelegate: flowMock)
        
        // when
        sut.action.select(book: Book(title: "", subtitle: "", price: "", image: "", url: "", isbn13: ""))
        
        // then
        XCTAssertTrue(flowMock.callCount == 1, "Called zero or more than 2 - count: \(mock.callCount)")
    }
}
