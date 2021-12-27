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
import Extension

class NewBooksViewModelTest: XCTestCase {
    
    class NewBooksUseCaseMock: NewBooksUseCase {
        
        var callCount = 0
        
        func execute() async -> Result<[Book], Error> {
            callCount += 1
            return .success([])
        }
    }
    
    func test_newBooksViewModel_whenLoad_thenLoadFunctionCallCountIsOne() {
        let mock = NewBooksUseCaseMock()
        let sut: NewBooksViewModelType = NewBooksViewModel(newBooksUseCase: mock)
        
        // when
        asyncTest {
            _ = sut.action.loadNewBooks()
        }
        
        // then
        XCTAssertTrue(mock.callCount == 1, "'execute' was called zero or more than 2 - count: \(mock.callCount)")
    }
}
