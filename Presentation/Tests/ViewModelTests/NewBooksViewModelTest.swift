//
//  NewBooksViewModelTest.swift
//  
//
//  Created by 육찬심 on 2021/12/27.
//

import Views
import XCTest
import Entities
import UseCases
import TestExtension

class NewBooksViewModelTest: XCTestCase {
    
    class NewBooksUseCaseMock: NewBooksUseCase {
        
        var callCount = 0
        
        func execute() async -> Result<[Book], Error> {
            callCount += 1
            return .success([])
        }
    }
    
    class FlowMock: NewBooksFlowDelegate {
        
        var callCount = 0
        
        func showDetail(book: Book) {
            callCount += 1
        }
    }
    
    func test_newBooksViewModel_whenLoad_thenLoadFunctionCallCountIsOne() {
        let mock = NewBooksUseCaseMock()
        let flowMock = FlowMock()
        let sut: NewBooksViewModelType = NewBooksViewModel(newBooksUseCase: mock, flowDelegate: flowMock)
        
        // when
        asyncTest {
            _ = sut.action.loadNewBooks()
        }
        
        // then
        XCTAssertTrue(mock.callCount == 1, "Called zero or more than 2 - count: \(mock.callCount)")
    }
    
    func test_newBooksViewModel_whenSelect_thenShowDetailFunctionCallCountIsOne() {
        let mock = NewBooksUseCaseMock()
        let flowMock = FlowMock()
        let sut: NewBooksViewModelType = NewBooksViewModel(newBooksUseCase: mock, flowDelegate: flowMock)
        
        // when
        sut.action.select(book: Book(title: "", subtitle: "", price: "", image: "", url: "", isbn13: ""))
        
        // then
        XCTAssertTrue(flowMock.callCount == 1, "Called zero or more than 2 - count: \(mock.callCount)")
    }
}
